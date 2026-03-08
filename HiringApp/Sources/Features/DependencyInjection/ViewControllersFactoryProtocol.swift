import Foundation

protocol ViewControllersFactoryProtocol: AnyObject {
    func makeSplashViewController(flowDelegate: SplashFlowDelegate) -> SplashViewController
    func makeSignInViewController(flowDelegate: SignInFlowDelegate) -> SignInViewController
    func makeSignUpViewController(flowDelegate: SignUpFlowDelegate) -> SignUpViewController
    func makeHomeViewController(flowDelegate: HomeFlowDelegate) -> HomeViewController
}
