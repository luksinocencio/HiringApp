import Foundation

enum DoorsEndpoint: Endpoint {
    case listAll(page: Int, size: Int)
    case find(name: String, page: Int, size: Int)
    case simulatePermissions(count: Int, type: SimulatedPermissionType)
    case createPermission(request: CreatePermissionRequest)

    var path: String {
        switch self {
        case .listAll:
            return "doors"
        case .find:
            return "doors/find"
        case .simulatePermissions:
            return "doors/permissions/simulate"
        case .createPermission:
            return "doors/permissions"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .listAll, .find, .simulatePermissions:
            return .get
        case .createPermission:
            return .post
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
        case let .simulatePermissions(count, type):
            return [
                "count": "\(count)",
                "type": type.rawValue
            ]
        case .createPermission:
            return [:]
        }
    }

    var body: Data? {
        switch self {
        case let .createPermission(request):
            return try? JSONEncoder().encode(request)
        case .listAll, .find, .simulatePermissions:
            return nil
        }
    }
    
    var isEncrypted: Bool {
        return false
    }
}
