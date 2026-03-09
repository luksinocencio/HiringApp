import Foundation
import CryptoKit

enum NetworkError: Error {
    case requestFailed
    case invalidResponse
    case decodingFailed
    case failedToPersistToken
}

@MainActor
final class Client {
    func request<T>(_ endpoint: Endpoint) async -> Result<T, NetworkError> where T: Decodable {
        var urlRequest = endpoint.asURLRequest()
        var clientPrivateKey: P256.KeyAgreement.PrivateKey?

        if endpoint.isEncrypted {
            let keyPair = makeClientKeyPairHeader()
            clientPrivateKey = keyPair.privateKey
            urlRequest.setValue(keyPair.publicKeyBase64, forHTTPHeaderField: "X-Client-Public-Key")
        }

        do {
            let (data, response) = try await URLSession.shared.data(for: urlRequest)

            guard let httpResponse = response as? HTTPURLResponse,
                  200..<300 ~= httpResponse.statusCode else {
                return .failure(.invalidResponse)
            }

            if endpoint.isEncrypted {
                guard let clientPrivateKey,
                      let serverPublicKeyBase64 = httpResponse.value(forHTTPHeaderField: "X-Server-Public-Key")
                else {
                    return .failure(.invalidResponse)
                }

                do {
                    let decryptedData = try decryptData(
                        data,
                        serverPublicKeyBase64: serverPublicKeyBase64,
                        clientPrivateKey: clientPrivateKey
                    )
                    return decode(decryptedData)
                } catch {
                    return .failure(.invalidResponse)
                }
            } else {
                return decode(data)
            }
        } catch {
            return .failure(.requestFailed)
        }
    }
    
    private func decode<T>(_ data: Data) -> Result<T, NetworkError> where T: Decodable {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(T.self, from: data)
            return .success(decodedData)
        } catch {
            return .failure(.decodingFailed)
        }
    }
    
    private struct EncryptedPayload: Decodable {
        let iv: String
        let ciphertext: String
    }

    private func makeClientKeyPairHeader() -> (privateKey: P256.KeyAgreement.PrivateKey, publicKeyBase64: String) {
        let clientPrivateKey = P256.KeyAgreement.PrivateKey()
        let clientPublicKey = clientPrivateKey.publicKey
        let publicKeyBase64 = clientPublicKey.derRepresentation.base64EncodedString()
        return (privateKey: clientPrivateKey, publicKeyBase64: publicKeyBase64)
    }

    private func decryptData(
        _ data: Data,
        serverPublicKeyBase64: String,
        clientPrivateKey: P256.KeyAgreement.PrivateKey
    ) throws -> Data {
        let serverPublicKeyData = Data(base64Encoded: serverPublicKeyBase64) ?? Data()
        let serverPublicKey = try P256.KeyAgreement.PublicKey(derRepresentation: serverPublicKeyData)

        let payload = try JSONDecoder().decode(EncryptedPayload.self, from: data)
        let ivData = Data(base64Encoded: payload.iv) ?? Data()
        let cipherData = Data(base64Encoded: payload.ciphertext) ?? Data()

        let sharedSecret = try clientPrivateKey.sharedSecretFromKeyAgreement(with: serverPublicKey)
        let symmetricKey = sharedSecret.hkdfDerivedSymmetricKey(
            using: SHA256.self,
            salt: Data(),
            sharedInfo: Data("door-event-api-v1".utf8),
            outputByteCount: 32
        )

        let nonce = try AES.GCM.Nonce(data: ivData)
        let sealedBox = try AES.GCM.SealedBox(nonce: nonce, ciphertext: cipherData, tag: Data())
        return try AES.GCM.open(sealedBox, using: symmetricKey)
    }
}
