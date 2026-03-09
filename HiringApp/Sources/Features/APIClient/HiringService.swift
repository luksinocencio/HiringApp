import Foundation

final class HiringService {
    static let shared = HiringService()

    private let session: URLSession
    private let decoder: JSONDecoder
    private let cacheManager = HiringAPICacheManager()

    private init(
        session: URLSession = .shared,
        decoder: JSONDecoder = JSONDecoder()
    ) {
        self.session = session
        self.decoder = decoder
    }

    enum HiringServiceError: Error {
        case invalidResponse
        case requestFailed(statusCode: Int)
        case failedToPersistToken
    }

    func login(email: String, password: String, completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            let request = try HiringRequest.loginRequest(email: email, password: password)

            execute(request, expecting: LoginResponse.self) { result in
                switch result {
                case let .success(response):
                    let didSave = AuthTokenKeychainManager.shared.save(token: response.token)
                    if didSave {
                        completion(.success(()))
                    } else {
                        completion(.failure(HiringServiceError.failedToPersistToken))
                    }
                case let .failure(error):
                    completion(.failure(error))
                }
            }
        } catch {
            completion(.failure(error))
        }
    }

    func signUp(
        firstName: String,
        lastName: String,
        email: String,
        password: String,
        completion: @escaping (Result<Void, Error>) -> Void
    ) {
        do {
            let request = try HiringRequest.signUpRequest(
                firstName: firstName,
                lastName: lastName,
                email: email,
                password: password
            )
            execute(request, completion: completion)
        } catch {
            completion(.failure(error))
        }
    }

    func execute<T: Decodable>(
        _ request: HiringRequest,
        expecting type: T.Type,
        completion: @escaping (Result<T, Error>) -> Void
    ) {
        do {
            let url = try request.url()

            if request.shouldUseCache,
               let cachedData = cacheManager.cachedResponse(for: url) {
                let decoded = try decoder.decode(type.self, from: cachedData)
                completion(.success(decoded))
                return
            }

            executeRaw(request) { [weak self] result in
                guard let self else { return }

                switch result {
                case let .success(data):
                    do {
                        let decoded = try self.decoder.decode(type.self, from: data)

                        if request.shouldUseCache {
                            self.cacheManager.setCache(for: url, data: data)
                        }

                        completion(.success(decoded))
                    } catch {
                        completion(.failure(error))
                    }
                case let .failure(error):
                    completion(.failure(error))
                }
            }
        } catch {
            completion(.failure(error))
        }
    }

    func execute(_ request: HiringRequest, completion: @escaping (Result<Void, Error>) -> Void) {
        executeRaw(request) { result in
            switch result {
            case .success:
                completion(.success(()))
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }

    private func executeRaw(_ request: HiringRequest, completion: @escaping (Result<Data, Error>) -> Void) {
        do {
            let authToken = AuthTokenKeychainManager.shared.token()
            let urlRequest = try request.asURLRequest(authToken: authToken)

            session.dataTask(with: urlRequest) { data, response, error in
                if let error {
                    completion(.failure(error))
                    return
                }

                guard let httpResponse = response as? HTTPURLResponse else {
                    completion(.failure(HiringServiceError.invalidResponse))
                    return
                }

                guard (200...299).contains(httpResponse.statusCode) else {
                    completion(.failure(HiringServiceError.requestFailed(statusCode: httpResponse.statusCode)))
                    return
                }

                completion(.success(data ?? Data()))
            }.resume()
        } catch {
            completion(.failure(error))
        }
    }
}
