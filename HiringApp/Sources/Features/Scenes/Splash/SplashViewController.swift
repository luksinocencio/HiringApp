import UIKit

class SplashViewController: UIViewController {
    let contentView: SplashView
    public weak var flowDelegate: SplashFlowDelegate?

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
        
        contentView.homeButton.addTarget(self, action: #selector(navigateToSignIn), for: .touchUpInside)
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
}
