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
    
    func makeSignInViewController(flowDelegate: any SignInFlowDelegate) -> SignInViewController {
        let contentView = SignInView()
        let viewController = SignInViewController(
            contentView: contentView,
            flowDelegate: flowDelegate
        )
        return viewController
    }
}
