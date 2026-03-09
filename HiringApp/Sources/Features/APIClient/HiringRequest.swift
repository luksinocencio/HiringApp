import Foundation

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case patch = "PATCH"
    case delete = "DELETE"
}

enum HiringRequestError: Error {
    case invalidBaseURL
    case failedToEncodeBody
}

struct HiringRequest {
    let endpoint: HiringEndpoint
    let pathComponents: [String]
    let queryParameters: [URLQueryItem]
    let httpMethod: HTTPMethod
    let httpBody: Data?
    let headers: [String: String]

    init(
        endpoint: HiringEndpoint,
        pathComponents: [String] = [],
        queryParameters: [URLQueryItem] = [],
        httpMethod: HTTPMethod = .get,
        httpBody: Data? = nil,
        headers: [String: String] = [:]
    ) {
        self.endpoint = endpoint
        self.pathComponents = pathComponents
        self.queryParameters = queryParameters
        self.httpMethod = httpMethod
        self.httpBody = httpBody
        self.headers = headers
    }

    var shouldUseCache: Bool {
        httpMethod == .get
    }

    func asURLRequest(authToken: String? = nil) throws -> URLRequest {
        let url = try self.url()

        var request = URLRequest(url: url)
        request.httpMethod = httpMethod.rawValue
        request.httpBody = httpBody

        var mergedHeaders = headers
        if let authToken, !authToken.isEmpty {
            mergedHeaders["Authorization"] = "Bearer \(authToken)"
        }

        mergedHeaders.forEach { key, value in
            request.setValue(value, forHTTPHeaderField: key)
        }

        return request
    }

    func url() throws -> URL {
        guard var components = URLComponents(string: BASE_URL) else {
            throw HiringRequestError.invalidBaseURL
        }

        var path = "/\(endpoint.rawValue)"
        if !pathComponents.isEmpty {
            path += "/" + pathComponents.joined(separator: "/")
        }

        components.path = path
        components.queryItems = queryParameters.isEmpty ? nil : queryParameters

        guard let url = components.url else {
            throw HiringRequestError.invalidBaseURL
        }

        return url
    }
}

extension HiringRequest {
    private static let defaultJSONHeaders = [
        "Content-Type": "application/json",
        "Accept": "application/json"
    ]

    static func doorsRequest(page: Int, size: Int) -> HiringRequest {
        HiringRequest(
            endpoint: .doors,
            queryParameters: [
                URLQueryItem(name: "page", value: "\(page)"),
                URLQueryItem(name: "size", value: "\(size)")
            ]
        )
    }

    static func doorEventsRequest(doorID: Int, page: Int, size: Int) -> HiringRequest {
        HiringRequest(
            endpoint: .doors,
            pathComponents: ["\(doorID)", "events"],
            queryParameters: [
                URLQueryItem(name: "page", value: "\(page)"),
                URLQueryItem(name: "size", value: "\(size)")
            ]
        )
    }

    static func findDoorsRequest(name: String, page: Int, size: Int) -> HiringRequest {
        HiringRequest(
            endpoint: .doors,
            pathComponents: ["find"],
            queryParameters: [
                URLQueryItem(name: "name", value: name),
                URLQueryItem(name: "page", value: "\(page)"),
                URLQueryItem(name: "size", value: "\(size)")
            ]
        )
    }

    static func loginRequest(email: String, password: String) throws -> HiringRequest {
        let payload = LoginPayload(email: email, password: password)
        let body = try encodeBody(payload)

        return HiringRequest(
            endpoint: .users,
            pathComponents: ["signin"],
            httpMethod: .post,
            httpBody: body,
            headers: defaultJSONHeaders
        )
    }

    static func signUpRequest(
        firstName: String,
        lastName: String,
        email: String,
        password: String
    ) throws -> HiringRequest {
        let payload = SignUpPayload(
            firstName: firstName,
            lastName: lastName,
            email: email,
            password: password
        )
        let body = try encodeBody(payload)

        return HiringRequest(
            endpoint: .users,
            pathComponents: ["signup"],
            httpMethod: .post,
            httpBody: body,
            headers: defaultJSONHeaders
        )
    }

    private static func encodeBody<T: Encodable>(_ payload: T) throws -> Data {
        do {
            return try JSONEncoder().encode(payload)
        } catch {
            throw HiringRequestError.failedToEncodeBody
        }
    }
}

private struct LoginPayload: Encodable {
    let email: String
    let password: String
}

private struct SignUpPayload: Encodable {
    let firstName: String
    let lastName: String
    let email: String
    let password: String
}
