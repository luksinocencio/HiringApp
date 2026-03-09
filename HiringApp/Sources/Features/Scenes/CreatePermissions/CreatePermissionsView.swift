import UIKit

final class CreatePermissionsView: UIView {
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
        text: "Create Permission",
        configuration: .screenTitle
    )

    let subtitleLabel = DSLabel(
        text: "Fill in the fields and create a permission",
        configuration: .screenSubtitle
    )

    let typeSegmentedControl: UISegmentedControl = {
        let control = UISegmentedControl(items: ["PASSCODE", "SMARTPHONE", "CARD"])
        control.translatesAutoresizingMaskIntoConstraints = false
        return control
    }()

    let valueTextField = DSTextField(
        configuration: DSTextFieldConfiguration(
            style: .primary,
            inputType: .generic,
            placeholder: "Value"
        )
    )

    let startDateTextField = DSTextField(
        configuration: DSTextFieldConfiguration(
            style: .primary,
            inputType: .generic,
            placeholder: "Start DateTime (yyyy-MM-dd'T'HH:mm:ssZ)"
        )
    )

    let endDateTextField = DSTextField(
        configuration: DSTextFieldConfiguration(
            style: .primary,
            inputType: .generic,
            placeholder: "End DateTime (yyyy-MM-dd'T'HH:mm:ssZ)"
        )
    )

    let weekDaysTextField = DSTextField(
        configuration: DSTextFieldConfiguration(
            style: .primary,
            inputType: .numeric,
            placeholder: "WeekDays (Int)"
        )
    )

    let createButton = DSButton(style: .primary, title: "Create")

    let stackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.spacing = 14
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        backgroundColor = .systemBackground

        addSubview(scrollView)
        scrollView.addSubview(contentContainer)

        contentContainer.addSubview(titleLabel)
        contentContainer.addSubview(subtitleLabel)
        contentContainer.addSubview(typeSegmentedControl)
        contentContainer.addSubview(stackView)

        stackView.addArrangedSubview(valueTextField)
        stackView.addArrangedSubview(startDateTextField)
        stackView.addArrangedSubview(endDateTextField)
        stackView.addArrangedSubview(weekDaysTextField)
        stackView.addArrangedSubview(createButton)

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

            titleLabel.topAnchor.constraint(equalTo: contentContainer.topAnchor, constant: 24),
            titleLabel.leadingAnchor.constraint(equalTo: contentContainer.leadingAnchor, constant: 24),
            titleLabel.trailingAnchor.constraint(equalTo: contentContainer.trailingAnchor, constant: -24),

            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            subtitleLabel.leadingAnchor.constraint(equalTo: contentContainer.leadingAnchor, constant: 24),
            subtitleLabel.trailingAnchor.constraint(equalTo: contentContainer.trailingAnchor, constant: -24),

            typeSegmentedControl.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 20),
            typeSegmentedControl.leadingAnchor.constraint(equalTo: contentContainer.leadingAnchor, constant: 24),
            typeSegmentedControl.trailingAnchor.constraint(equalTo: contentContainer.trailingAnchor, constant: -24),

            stackView.topAnchor.constraint(equalTo: typeSegmentedControl.bottomAnchor, constant: 20),
            stackView.leadingAnchor.constraint(equalTo: contentContainer.leadingAnchor, constant: 24),
            stackView.trailingAnchor.constraint(equalTo: contentContainer.trailingAnchor, constant: -24),
            stackView.bottomAnchor.constraint(equalTo: contentContainer.bottomAnchor, constant: -24)
        ])
    }
}
