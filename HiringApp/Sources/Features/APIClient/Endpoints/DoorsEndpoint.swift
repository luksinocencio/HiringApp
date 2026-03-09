import Foundation

enum DoorsEndpoint: Endpoint {
    case listAll(page: Int, size: Int)
    case find(name: String, page: Int, size: Int)

    var path: String {
        switch self {
        case .listAll:
            return "doors"
        case .find:
            return "doors/find"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .listAll, .find:
            return .get
        }
    }
    
    var query: [String : String] {
        switch self {
        case .listAll(let page, let size):
            return [
                "page": "\(page)",
                "size": "\(size)"
            ]
        case .find(let name , let page, let size):
            return [
                "name": name,
                "page": "\(page)",
                "size": "\(size)"
            ]
        }
    }
    
    var isEncrypted: Bool {
        return false
    }
}
