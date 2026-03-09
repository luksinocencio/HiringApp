import Foundation

struct SignInRequest: Codable {
    let email: String
    let password: String
}

struct SignInResponse: Decodable {
    let token: String
}

