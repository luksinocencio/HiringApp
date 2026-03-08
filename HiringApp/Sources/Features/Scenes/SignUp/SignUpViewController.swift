import UIKit

class SignUpViewController: UIViewController {
    let contentView: SignUpView
    public weak var flowDelegate: SignUpFlowDelegate?

    init(contentView: SignUpView, flowDelegate: SignUpFlowDelegate? = nil) {
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
    
    private func setup() {
        self.view.addSubview(contentView)
        self.view.backgroundColor = .systemBackground
        setupConstraints()
        
//        contentView.signUpButton.addTarget(self, action: #selector(navigateToSignUp), for: .touchUpInside)
    }
    
    private func setupConstraints() {
        setupContentViewToBounds(contentView: contentView)
    }
}
