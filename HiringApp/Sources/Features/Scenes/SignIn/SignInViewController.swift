import UIKit

class SignInViewController: UIViewController {
    let contentView: SignInView
    public weak var flowDelegate: SignInFlowDelegate?
    private let service = HiringService.shared

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
        setup()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
        navigationItem.hidesBackButton = true
    }

    private func setup() {
        view.addSubview(contentView)
        view.backgroundColor = .systemBackground
        title = "Sign In"
        setupConstraints()

        contentView.signUpButton.addTarget(self, action: #selector(navigateToSignUp), for: .touchUpInside)
        contentView.signInButton.addTarget(self, action: #selector(signIn), for: .touchUpInside)
    }

    private func setupConstraints() {
        setupContentViewToBounds(contentView: contentView)
    }

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

        service.login(email: email, password: password) { [weak self] result in
            DispatchQueue.main.async {
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

    private func showAlert(message: String) {
        let alert = UIAlertController(title: "Attention", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}
