import Foundation

enum EventsEndpoint: Endpoint {
    case listAll(doorId: Int, page: Int, size: Int)
    
    var path: String {
        switch self {
        case .listAll(let doorId, _, _):
            return "doors/\(doorId)/events"
        
        }
    }

    var method: HTTPMethod {
        switch self {
        case .listAll:
            return .get
        }
    }
    
    var query: [String : String] {
        switch self {
        case .listAll(_, let page, let size):
            return [
                "page": "\(page)",
                "size": "\(size)"
            ]
        }
    }
}
