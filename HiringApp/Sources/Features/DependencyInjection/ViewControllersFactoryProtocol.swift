import Foundation

protocol ViewControllersFactoryProtocol: AnyObject {
    func makeSplashViewController(flowDelegate: SplashFlowDelegate) -> SplashViewController
    func makeSignInViewController(flowDelegate: SignInFlowDelegate) -> SignInViewController
}
