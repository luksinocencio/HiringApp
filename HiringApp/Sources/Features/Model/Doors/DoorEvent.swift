import Foundation

struct DoorEvent: Decodable {
    let id: Int
    let logType: String
    let logNumber: Int
    let eventTimestamp: String
    let additionalData: [DoorEventAdditionalData]

    var titleText: String {
        "\(logType) #\(logNumber)"
    }

    var subtitleText: String {
        eventTimestamp
    }
}

struct DoorEventAdditionalData: Decodable {
    let parameterName: String
    let hexValue: String
    let parsedValue: String
}
