import Foundation

public protocol SignInFlowDelegate: AnyObject {
    func navigateToSignUp()
    func navigateToDoors()
}
