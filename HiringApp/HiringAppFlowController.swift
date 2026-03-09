import UIKit

class HiringAppFlowController {
    // MARK: - Propery(ies).
    private var navigationController: UINavigationController?
    private let viewControllerFactory: ViewControllersFactoryProtocol

    // MARK: - init

    public init() {
        self.viewControllerFactory = ViewControllersFactory()
    }

    required init ?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - startFlow

    func start() -> UINavigationController? {
        let startViewController = viewControllerFactory.makeSplashViewController(flowDelegate: self)
        self.navigationController = UINavigationController(rootViewController: startViewController)
        return navigationController
    }

    // MARK: - Private navigation helper(s)

    private func push(_ viewController: UIViewController, animated: Bool) {
        navigationController?.dismiss(animated: false)
        navigationController?.pushViewController(viewController, animated: animated)
    }

    private func presentDoors(_ viewController: UIViewController) {
        viewController.modalPresentationStyle = .fullScreen
        viewController.modalTransitionStyle = .coverVertical
        viewController.isModalInPresentation = true
        navigationController?.present(viewController, animated: true)
    }
}

// MARK: - SplashFlowDelegate
extension HiringAppFlowController: SplashFlowDelegate {
    func navigateToSignIn() {
        let viewController = viewControllerFactory.makeSignInViewController(flowDelegate: self)
        push(viewController, animated: false)
    }

    func navigateToDoors() {
        let viewController = viewControllerFactory.makeDoorsViewController(flowDelegate: self)
        presentDoors(viewController)
    }
}

// MARK: - SignInFlowDelegate
extension HiringAppFlowController: SignInFlowDelegate {
    func navigateToSignUp() {
        let viewController = viewControllerFactory.makeSignUpViewController(flowDelegate: self)
        push(viewController, animated: true)
    }
}

// MARK: - SignUpFlowDelegate
extension HiringAppFlowController: SignUpFlowDelegate {
    func navigateBackToSignIn() {
        navigationController?.popViewController(animated: true)
    }
}

// MARK: - DoorsFlowDelegate
extension HiringAppFlowController: DoorsFlowDelegate {
    func didTapLogout() {
        AuthTokenKeychainManager.shared.deleteToken()

        navigationController?.dismiss(animated: true) { [weak self] in
            guard let self else { return }
            let signInViewController = self.viewControllerFactory.makeSignInViewController(flowDelegate: self)
            self.navigationController?.setViewControllers([signInViewController], animated: false)
        }
    }
}
