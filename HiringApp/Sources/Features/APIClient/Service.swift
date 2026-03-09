import Foundation

@MainActor
final class Service: Sendable {
    static let shared = Service()
    private let client = Client()

    func signIn(email: String, password: String) async -> Result<Void, NetworkError> {
        let result: Result<SignInResponse, NetworkError> = await client.request(AuthEndpoint.signIn(email: email, password: password))

        switch result {
        case let .success(response):
            let didSave = AuthTokenKeychainManager.shared.save(token: response.token)
            return didSave ? .success(()) : .failure(.failedToPersistToken)
        case let .failure(error):
            return .failure(error)
        }
    }
    
    func signUp(firstName: String, lastName: String, email: String, password: String) async -> Result<SignUpResponse, NetworkError> {
        await client.request(
            AuthEndpoint.signUp(
                firstName: firstName,
                lastName: lastName,
                email: email,
                password: password
            )
        )
    }
    
    func getAllDoors(page: Int, size: Int) async -> Result<Doors, NetworkError> {
        await client.request(DoorsEndpoint.listAll(page: page, size: size))
    }
    
    func listDoorEvents(doorId: Int, page: Int, size: Int) async -> Result<PaginatedResponse<DoorEvent>, NetworkError> {
        await client.request(EventsEndpoint.listAll(doorId: doorId, page: page, size: size))
    }
    
    func listDoorByName(name: String, page: Int, size: Int) async -> Result<Doors, NetworkError> {
        await client.request(DoorsEndpoint.find(name: name, page: page, size: size))
    }
}
