import UIKit

class HiringAppFlowController {
    // MARK: - Property(ies).
    
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
}

// MARK: - Splash
extension HiringAppFlowController: SplashFlowDelegate {
    
}
