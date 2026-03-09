import Foundation

struct DoorDTO: Codable {
    let id: Int
    let serial: String
    let lockMac: String
    let name: String
    let address: String
    let latitude: Double
    let longitude: Double
    let battery: Int
}
