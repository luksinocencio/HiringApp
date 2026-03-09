import Foundation

protocol Endpoint {
    var baseURL: URL { get }
    var path: String { get }
    var query: [String: String] { get }
    var method: HTTPMethod { get }
    var headers: [String: String] { get }
    var body: Data? { get }
    var isEncrypted: Bool { get }
    var isAuthorizationRequired: Bool { get }
}

extension Endpoint {
    var baseURL: URL {
        return URL(string: "https://hiring-api.samba.dev.assaabloyglobalsolutions.net/")!
    }
    
    var headers: [String: String] {
        var dictionary: [String: String] = [
            "Content-Type": "application/json",
            "Accept": "application/json"
        ]
        
        if isAuthorizationRequired,
           let authToken = AuthTokenKeychainManager.shared.token(),
           !authToken.isEmpty {
            dictionary["Authorization"] = "Bearer \(authToken)"
        }
        
        return dictionary
    }
    
    var isEncrypted: Bool {
        return false
    }
    
    var body: Data? {
        return nil
    }
    
    var isAuthorizationRequired: Bool {
        return true
    }
    
    var query: [String: String] {
        return [:]
    }
}

extension Endpoint {
    func asURLRequest() -> URLRequest {
        var components = URLComponents(url: baseURL.appendingPathComponent(path), resolvingAgainstBaseURL: false)!
        
        if !query.isEmpty {
            components.queryItems = query.map { URLQueryItem(name: $0.key, value: $0.value) }
        }
        
        var request = URLRequest(url: components.url!)
        request.httpMethod = method.rawValue
        request.allHTTPHeaderFields = headers
        request.httpBody = body
        return request
    }
}
