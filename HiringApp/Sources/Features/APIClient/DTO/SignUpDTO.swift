import Foundation

struct SignUpRequest: Codable {
    let firstName: String
    let lastName: String
    let email: String
    let password: String
}

struct SignUpResponse: Decodable {
    let id: String
    let firstName: String
    let lastName: String
    let email: String
    let createdAt: String
}


