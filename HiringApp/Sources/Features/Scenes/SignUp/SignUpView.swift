import UIKit

class SignUpView: UIView {
    // MARK: - Property(ies).
     let scrollView: UIScrollView = {
        let view = UIScrollView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.alwaysBounceVertical = true
        view.keyboardDismissMode = .interactive
        return view
    }()

     let contentContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    let titleLabel = DSLabel(
        text: "Criar Conta",
        configuration: .screenTitle
    )
    
    let subtitleLabel = DSLabel(
        text: "Preencha os campos para se cadastrar",
        configuration: .screenSubtitle
    )

    let firstNameTextField = DSTextField(configuration: .firstName)
    let lastNameTextField = DSTextField(configuration: .lastName)
    let emailTextField = DSTextField(configuration: .email)
    let passwordTextField = DSTextField(configuration: .password)

    let signUpButton = DSButton(
        style: .primary, title: "Criar Conta"
    )

    let vStack: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.spacing = 14
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()

    // MARK: - Init(s).
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
