import Foundation

enum SimulatedPermissionType: String, CaseIterable {
    case passcode = "PASSCODE"
    case smartphone = "SMARTPHONE"
    case card = "CARD"
}

struct SimulatedPermission {
    let messageKey: String
    let type: String
    let value: String
    let startDateTime: String
    let endDateTime: String
    let weekDays: Int
}

protocol SimulatedPermissionResponse {
    var messageKey: String { get }
    var type: String { get }
    var valueText: String { get }
    var startDateTime: String { get }
    var endDateTime: String { get }
    var weekDays: Int { get }
}

extension SimulatedPermissionResponse {
    var asDomain: SimulatedPermission {
        SimulatedPermission(
            messageKey: messageKey,
            type: type,
            value: valueText,
            startDateTime: startDateTime,
            endDateTime: endDateTime,
            weekDays: weekDays
        )
    }
}

struct PasscodeSimulatedPermissionResponse: Decodable, SimulatedPermissionResponse {
    let messageKey: String
    let type: String
    let value: String
    let startDateTime: String
    let endDateTime: String
    let weekDays: Int

    var valueText: String { value }
}

struct SmartphoneSimulatedPermissionResponse: Decodable, SimulatedPermissionResponse {
    let messageKey: String
    let type: String
    let value: String
    let startDateTime: String
    let endDateTime: String
    let weekDays: Int

    var valueText: String { value }
}

struct CardSimulatedPermissionResponse: Decodable, SimulatedPermissionResponse {
    let messageKey: String
    let type: String
    let value: String
    let startDateTime: String
    let endDateTime: String
    let weekDays: Int

    var valueText: String { value }
}
