import UIKit

class SignInViewController: UIViewController {
    // MARK: - Internal Property(ies).
    let contentView: SignInView
    private let service: AppServiceProtocol
    
    // MARK: - Public Property(ies).
    public weak var flowDelegate: SignInFlowDelegate?

    // MARK: - Init.
    init(contentView: SignInView, service: AppServiceProtocol = Service.shared, flowDelegate: SignInFlowDelegate? = nil) {
        self.contentView = contentView
        self.service = service
        self.flowDelegate = flowDelegate
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecyle.
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
        navigationItem.hidesBackButton = true
    }
    
    // MARK: - Private method(s).
    private func setup() {
        view.addSubview(contentView)
        view.backgroundColor = .systemBackground
        setupConstraints()

        contentView.signUpButton.addTarget(self, action: #selector(navigateToSignUp), for: .touchUpInside)
        contentView.signInButton.addTarget(self, action: #selector(signIn), for: .touchUpInside)
    }

    private func setupConstraints() {
        setupContentViewToBounds(contentView: contentView)
    }
    
    private func showAlert(message: String) {
        let alert = UIAlertController(title: "Attention", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    // MARK: - Private Selector(s).
    @objc
    private func navigateToSignUp() {
        flowDelegate?.navigateToSignUp()
    }

    @objc
    private func signIn() {
        guard
            let email = contentView.emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines),
            let password = contentView.passwordTextField.text,
            !email.isEmpty,
            !password.isEmpty
        else {
            showAlert(message: "Please fill email and password.")
            return
        }

        contentView.signInButton.isEnabled = false
        
        Task {
            let result = await service.signIn(email: email, password: password)
            
            DispatchQueue.main.async { [weak self] in
                guard let self else { return }
                self.contentView.signInButton.isEnabled = true

                switch result {
                case .success:
                    self.flowDelegate?.navigateToDoors()
                case .failure:
                    self.showAlert(message: "Login failed. Check your credentials and try again.")
                }
            }
        }
    }
}
