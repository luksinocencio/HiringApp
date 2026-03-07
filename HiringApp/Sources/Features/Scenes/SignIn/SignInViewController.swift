import UIKit

class SignInViewController: UIViewController {
    let contentView: SignInView
    public weak var flowDelegate: SignInFlowDelegate?

    init(contentView: SignInView, flowDelegate: SignInFlowDelegate? = nil) {
        self.contentView = contentView
        self.flowDelegate = flowDelegate
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
