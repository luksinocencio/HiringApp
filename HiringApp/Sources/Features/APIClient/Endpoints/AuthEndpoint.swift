import Foundation

enum AuthEndpoint: Endpoint {
    case signIn(email: String, password: String)
    case signUp(firstName: String, lastName: String, email: String, password: String)
    
    var path: String {
        switch self {
        case .signIn:
            return "users/signin"
        case .signUp:
            return "users/signup"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .signIn:
            return .post
        case .signUp:
            return .post
        }
    }
    
    var body: Data? {
        switch self {
        case let .signIn(email, password):
            return try? JSONEncoder().encode(
                SignInRequest(
                    email: email,
                    password: password
                )
            )
        case let .signUp(firstName, lastName, email, password):
            return try? JSONEncoder().encode(
                SignUpRequest(
                    firstName: firstName,
                    lastName: lastName,
                    email: email,
                    password: password
                )
            )
        }
    }
    
    var isAuthorizationRequired: Bool {
        return false
    }
}
