import UIKit

class SplashViewController: UIViewController {
    let contentView: SplashView
    public weak var flowDelegate: SplashFlowDelegate?
    private var hasHandledInitialRoute = false
    private var didRouteFromSplash = false

    private enum RouteTiming {
        static let minimumSplashDuration: TimeInterval = 0.7
        static let keychainLookupTimeout: TimeInterval = 1.5
    }

    init(contentView: SplashView, flowDelegate: SplashFlowDelegate? = nil) {
        self.contentView = contentView
        self.flowDelegate = flowDelegate
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        handleInitialRoute()
    }
    
    private func setup() {
        self.view.addSubview(contentView)
        self.navigationController?.navigationBar.isHidden = true
        self.view.backgroundColor = .systemBackground
        setupConstraints()
    }
    
    private func setupConstraints() {
        setupContentViewToBounds(contentView: contentView)
    }
    
    @objc
    private func navigateToSignIn() {
        flowDelegate?.navigateToSignIn()
    }
    
    @objc
    private func navigateToDoors() {
        flowDelegate?.navigateToDoors()
    }

    private func handleInitialRoute() {
        guard !hasHandledInitialRoute else { return }
        hasHandledInitialRoute = true

        let earliestRouteDate = Date().addingTimeInterval(RouteTiming.minimumSplashDuration)

        // Fallback route in case reading auth state takes too long.
        DispatchQueue.main.asyncAfter(deadline: .now() + RouteTiming.keychainLookupTimeout) { [weak self] in
            self?.routeAfterMinimumSplashDuration(toDoors: false, earliestRouteDate: earliestRouteDate)
        }

        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            let hasToken = AuthTokenKeychainManager.shared.hasToken
            DispatchQueue.main.async {
                self?.routeAfterMinimumSplashDuration(toDoors: hasToken, earliestRouteDate: earliestRouteDate)
            }
        }
    }

    private func routeAfterMinimumSplashDuration(toDoors: Bool, earliestRouteDate: Date) {
        guard !didRouteFromSplash else { return }
        didRouteFromSplash = true

        let delay = max(0, earliestRouteDate.timeIntervalSinceNow)
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) { [weak self] in
            guard let self else { return }
            toDoors ? self.navigateToDoors() : self.navigateToSignIn()
        }
    }
}
