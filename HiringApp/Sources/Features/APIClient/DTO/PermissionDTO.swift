import Foundation

// MARK: - Create Permission Request.
struct CreatePermissionRequest: Codable {
    let type: String
    let value: String
    let startDateTime: String
    let endDateTime: String
    let weekDays: Int
}

// MARK: - Create Permission Response.
struct CreatePermissionResponse: Decodable {
    let id: Int
    let doorId: Int
    let type: String
    let value: String
    let startDateTime: String
    let endDateTime: String
    let weekDays: Int

    private enum CodingKeys: String, CodingKey {
        case id
        case doorId
        case type
        case value
        case startDateTime
        case endDateTime
        case weekDays
    }

    // MARK: - Init(s).
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int.self, forKey: .id)
        doorId = try container.decode(Int.self, forKey: .doorId)
        type = try container.decode(String.self, forKey: .type)

        if let rawValue = try? container.decode(String.self, forKey: .value) {
            value = rawValue
        } else if let rawValue = try? container.decode(Int.self, forKey: .value) {
            value = String(rawValue)
        } else {
            throw DecodingError.typeMismatch(
                String.self,
                DecodingError.Context(
                    codingPath: container.codingPath + [CodingKeys.value],
                    debugDescription: "Could not decode value as String/Int."
                )
            )
        }

        startDateTime = try container.decode(String.self, forKey: .startDateTime)
        endDateTime = try container.decode(String.self, forKey: .endDateTime)
        weekDays = try container.decode(Int.self, forKey: .weekDays)
    }
}
