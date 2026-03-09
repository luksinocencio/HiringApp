import Foundation

struct PaginatedResponse<Item: Decodable>: Decodable {
    let content: [Item]
    let page: Int?
    let size: Int?
    let totalElements: Int?
    let totalPages: Int?
    let last: Bool?

    init(from decoder: Decoder) throws {
        if let container = try? decoder.container(keyedBy: CodingKeys.self),
           let items = try? container.decode([Item].self, forKey: .content) {
            content = items
            page = try? container.decode(Int.self, forKey: .page)
            size = try? container.decode(Int.self, forKey: .size)
            totalElements = try? container.decode(Int.self, forKey: .totalElements)
            totalPages = try? container.decode(Int.self, forKey: .totalPages)
            last = try? container.decode(Bool.self, forKey: .last)
            return
        }

        let singleValueContainer = try decoder.singleValueContainer()
        content = (try? singleValueContainer.decode([Item].self)) ?? []
        page = nil
        size = nil
        totalElements = nil
        totalPages = nil
        last = nil
    }

    private enum CodingKeys: String, CodingKey {
        case content
        case page
        case size
        case totalElements
        case totalPages
        case last
    }
}
