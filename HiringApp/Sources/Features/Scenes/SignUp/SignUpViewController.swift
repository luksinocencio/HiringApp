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

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = false
    }

    private func setup() {
        view.addSubview(contentView)
        view.backgroundColor = .systemBackground
        title = "Criar Conta"
        setupConstraints()

        contentView.signUpButton.addTarget(self, action: #selector(signUp), for: .touchUpInside)
    }

    private func setupConstraints() {
        setupContentViewToBounds(contentView: contentView)
    }

    @objc
    private func signUp() {
        guard
            let firstName = contentView.firstNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines),
            let lastName = contentView.lastNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines),
            let email = contentView.emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines),
            let password = contentView.passwordTextField.text,
            !firstName.isEmpty,
            !lastName.isEmpty,
            !email.isEmpty,
            !password.isEmpty
        else {
            showAlert(title: "Atenção", message: "Preencha todos os campos.")
            return
        }

        contentView.signUpButton.isEnabled = false
        
        Task {
            let result = await Service.shared.signUp(firstName: firstName, lastName: lastName, email: email, password: password)
            
            DispatchQueue.main.async { [weak self] in
                guard let self else { return }
                self.contentView.signUpButton.isEnabled = true

                switch result {
                case .success:
                    self.showAlert(
                        title: "Sucesso",
                        message: "Conta criada com sucesso.",
                        onConfirm: { [weak self] in
                            self?.flowDelegate?.navigateBackToSignIn()
                        }
                    )
                case .failure:
                    self.showAlert(title: "Erro", message: "Não foi possível criar a conta. Tente novamente.")
                }
            }
        }
    }

    private func showAlert(title: String, message: String, onConfirm: (() -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in
            onConfirm?()
        })
        present(alert, animated: true)
    }
}
