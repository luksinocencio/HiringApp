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
    }
}
