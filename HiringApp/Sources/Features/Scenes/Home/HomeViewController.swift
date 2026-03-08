import UIKit

class HomeViewController: UIViewController {
    let contentView: HomeView
    public weak var flowDelegate: HomeFlowDelegate?

    init(contentView: HomeView, flowDelegate: HomeFlowDelegate? = nil) {
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
    }
    
    private func setupConstraints() {
        setupContentViewToBounds(contentView: contentView)
    }
}
