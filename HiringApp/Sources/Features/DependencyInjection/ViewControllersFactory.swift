import UIKit

final class ViewControllersFactory: ViewControllersFactoryProtocol {
    private let service: AppServiceProtocol

    init(service: AppServiceProtocol = Service.shared) {
        self.service = service
    }

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
            service: service,
            flowDelegate: flowDelegate
        )
        return viewController
    }

    func makeDoorsViewController(flowDelegate: DoorsFlowDelegate) -> UINavigationController {
        let doorsViewController = DoorsViewController(service: service, flowDelegate: flowDelegate)
        let navigationController = UINavigationController(rootViewController: doorsViewController)
        return navigationController
    }

    func makeSignUpViewController(flowDelegate: SignUpFlowDelegate) -> SignUpViewController {
        let contentView = SignUpView()
        let viewController = SignUpViewController(
            contentView: contentView,
            service: service,
            flowDelegate: flowDelegate
        )
        return viewController
    }
}
