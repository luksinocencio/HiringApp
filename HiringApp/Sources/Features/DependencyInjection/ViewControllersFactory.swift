import UIKit

final class ViewControllersFactory: ViewControllersFactoryProtocol {
    func makeSplashViewController(flowDelegate: SplashFlowDelegate) -> SplashViewController {
        let contentView = SplashView()
        let viewController = SplashViewController(
            contentView: contentView,
            flowDelegate: flowDelegate
        )
        return viewController
    }
    
    func makeSignInViewController(flowDelegate: SignInFlowDelegate) -> SignInViewController {
        let contentView = SignInView()
        let viewController = SignInViewController(
            contentView: contentView,
            flowDelegate: flowDelegate
        )
        return viewController
    }
    
    func makeHomeViewController(flowDelegate: HomeFlowDelegate) -> HomeViewController {
        let contentView = HomeView()
        let viewController = HomeViewController(
            contentView: contentView,
            flowDelegate: flowDelegate
        )
        return viewController
    }
    
    func makeSignUpViewController(flowDelegate: SignUpFlowDelegate) -> SignUpViewController {
        let contentView = SignUpView()
        let viewController = SignUpViewController(
            contentView: contentView,
            flowDelegate: flowDelegate
        )
        return viewController
    }
}
