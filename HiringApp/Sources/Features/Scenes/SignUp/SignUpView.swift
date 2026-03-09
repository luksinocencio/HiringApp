import UIKit

class SignUpView: UIView {
    // MARK: - Property(ies).
    private let scrollView: UIScrollView = {
        let view = UIScrollView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.alwaysBounceVertical = true
        view.keyboardDismissMode = .interactive
        return view
    }()

    private let contentContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .preferredFont(forTextStyle: .largeTitle)
        label.adjustsFontForContentSizeCategory = true
        label.textColor = .label
        label.text = "Criar Conta"
        label.textAlignment = .center
        label.accessibilityTraits = .header
        return label
    }()

    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .preferredFont(forTextStyle: .subheadline)
        label.adjustsFontForContentSizeCategory = true
        label.textColor = .secondaryLabel
        label.text = "Preencha os campos para se cadastrar"
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()

    let firstNameTextField: UITextField = {
        let tf = UITextField()
        tf.borderStyle = .roundedRect
        tf.autocorrectionType = .no
        tf.autocapitalizationType = .words
        tf.textContentType = .givenName
        tf.clearButtonMode = .whileEditing
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.placeholder = "First name"
        tf.font = .preferredFont(forTextStyle: .body)
        tf.adjustsFontForContentSizeCategory = true
        tf.backgroundColor = .secondarySystemBackground
        tf.layer.cornerRadius = 12
        tf.layer.masksToBounds = true
        tf.heightAnchor.constraint(equalToConstant: 48).isActive = true
        tf.accessibilityLabel = "Nome"
        tf.accessibilityIdentifier = "signup.first_name"
        return tf
    }()

    let lastNameTextField: UITextField = {
        let tf = UITextField()
        tf.borderStyle = .roundedRect
        tf.autocorrectionType = .no
        tf.autocapitalizationType = .words
        tf.textContentType = .familyName
        tf.clearButtonMode = .whileEditing
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.placeholder = "Last name"
        tf.font = .preferredFont(forTextStyle: .body)
        tf.adjustsFontForContentSizeCategory = true
        tf.backgroundColor = .secondarySystemBackground
        tf.layer.cornerRadius = 12
        tf.layer.masksToBounds = true
        tf.heightAnchor.constraint(equalToConstant: 48).isActive = true
        tf.accessibilityLabel = "Sobrenome"
        tf.accessibilityIdentifier = "signup.last_name"
        return tf
    }()

    let emailTextField: UITextField = {
        let tf = UITextField()
        tf.borderStyle = .roundedRect
        tf.autocorrectionType = .no
        tf.keyboardType = .emailAddress
        tf.autocapitalizationType = .none
        tf.textContentType = .emailAddress
        tf.clearButtonMode = .whileEditing
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.placeholder = "E-mail"
        tf.font = .preferredFont(forTextStyle: .body)
        tf.adjustsFontForContentSizeCategory = true
        tf.backgroundColor = .secondarySystemBackground
        tf.layer.cornerRadius = 12
        tf.layer.masksToBounds = true
        tf.heightAnchor.constraint(equalToConstant: 48).isActive = true
        tf.accessibilityLabel = "E-mail"
        tf.accessibilityIdentifier = "signup.email"
        return tf
    }()

    let passwordTextField: UITextField = {
        let tf = UITextField()
        tf.borderStyle = .roundedRect
        tf.autocorrectionType = .no
        tf.isSecureTextEntry = true
        tf.textContentType = .newPassword
        tf.clearButtonMode = .whileEditing
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.placeholder = "Password"
        tf.font = .preferredFont(forTextStyle: .body)
        tf.adjustsFontForContentSizeCategory = true
        tf.backgroundColor = .secondarySystemBackground
        tf.layer.cornerRadius = 12
        tf.layer.masksToBounds = true
        tf.heightAnchor.constraint(equalToConstant: 48).isActive = true
        tf.accessibilityLabel = "Senha"
        tf.accessibilityIdentifier = "signup.password"
        return tf
    }()

    let signUpButton: UIButton = {
        var configuration = UIButton.Configuration.filled()
        configuration.title = "Criar Conta"
        configuration.cornerStyle = .medium
        configuration.baseBackgroundColor = .systemBlue
        configuration.baseForegroundColor = .white
        configuration.contentInsets = NSDirectionalEdgeInsets(top: 12, leading: 16, bottom: 12, trailing: 16)

        let button = UIButton(type: .system)
        button.configuration = configuration
        button.titleLabel?.font = .preferredFont(forTextStyle: .headline)
        button.titleLabel?.adjustsFontForContentSizeCategory = true
        button.translatesAutoresizingMaskIntoConstraints = false
        button.accessibilityLabel = "Criar Conta"
        button.accessibilityIdentifier = "signup.submit"
        return button
    }()

    let vStack: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.spacing = 14
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
        backgroundColor = .systemBackground

        addSubview(scrollView)
        scrollView.addSubview(contentContainer)

        contentContainer.addSubview(titleLabel)
        contentContainer.addSubview(subtitleLabel)
        contentContainer.addSubview(vStack)

        vStack.addArrangedSubview(firstNameTextField)
        vStack.addArrangedSubview(lastNameTextField)
        vStack.addArrangedSubview(emailTextField)
        vStack.addArrangedSubview(passwordTextField)
        vStack.addArrangedSubview(signUpButton)

        setupConstraints()
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: bottomAnchor),

            contentContainer.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            contentContainer.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            contentContainer.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            contentContainer.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            contentContainer.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor),

            titleLabel.topAnchor.constraint(equalTo: contentContainer.topAnchor, constant: 32),
            titleLabel.leadingAnchor.constraint(equalTo: contentContainer.leadingAnchor, constant: 24),
            titleLabel.trailingAnchor.constraint(equalTo: contentContainer.trailingAnchor, constant: -24),

            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            subtitleLabel.leadingAnchor.constraint(equalTo: contentContainer.leadingAnchor, constant: 24),
            subtitleLabel.trailingAnchor.constraint(equalTo: contentContainer.trailingAnchor, constant: -24),

            vStack.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 28),
            vStack.leadingAnchor.constraint(equalTo: contentContainer.leadingAnchor, constant: 24),
            vStack.trailingAnchor.constraint(equalTo: contentContainer.trailingAnchor, constant: -24),
            vStack.bottomAnchor.constraint(equalTo: contentContainer.bottomAnchor, constant: -32)
        ])
    }
}
