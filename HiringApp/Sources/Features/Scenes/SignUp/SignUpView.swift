import UIKit

class SignUpView: UIView {
    // MARK: - Property(ies).
    let firstNameTextField: UITextField = {
        let tf = UITextField()
        tf.borderStyle = .roundedRect
        tf.autocorrectionType = .no
        tf.autocapitalizationType = .words
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.placeholder = "First name"
        return tf
    }()

    let lastNameTextField: UITextField = {
        let tf = UITextField()
        tf.borderStyle = .roundedRect
        tf.autocorrectionType = .no
        tf.autocapitalizationType = .words
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.placeholder = "Last name"
        return tf
    }()

    let emailTextField: UITextField = {
        let tf = UITextField()
        tf.borderStyle = .roundedRect
        tf.autocorrectionType = .no
        tf.keyboardType = .emailAddress
        tf.autocapitalizationType = .none
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.placeholder = "E-mail"
        return tf
    }()

    let passwordTextField: UITextField = {
        let tf = UITextField()
        tf.borderStyle = .roundedRect
        tf.autocorrectionType = .no
        tf.isSecureTextEntry = true
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.placeholder = "Password"
        return tf
    }()

    let signUpButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Criar Conta", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    let vStack: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.spacing = 16
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Private function(s).

    private func setupUI() {
        vStack.addArrangedSubview(firstNameTextField)
        vStack.addArrangedSubview(lastNameTextField)
        vStack.addArrangedSubview(emailTextField)
        vStack.addArrangedSubview(passwordTextField)
        vStack.addArrangedSubview(signUpButton)
        setupConstraints()
    }

    private func setupConstraints() {
        addSubview(vStack)

        NSLayoutConstraint.activate([
            vStack.centerXAnchor.constraint(equalTo: centerXAnchor),
            vStack.centerYAnchor.constraint(equalTo: centerYAnchor),
            vStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 32),
            vStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -32)
        ])
    }
}
