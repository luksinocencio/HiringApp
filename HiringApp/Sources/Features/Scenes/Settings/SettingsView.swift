import UIKit

final class SettingsView: UIView {
    // MARK: - Property(ies).
    let titleLabel = DSLabel(
        text: "settings.title".localized,
        configuration: .screenTitle
    )

    let subtitleLabel = DSLabel(
        text: "settings.subtitle".localized,
        configuration: .screenSubtitle
    )

    let languageTitleLabel = DSLabel(
        text: "settings.language.title".localized,
        configuration: DSLabelConfiguration(
            style: .cellSubtitle,
            color: .secondary,
            numberOfLines: 1
        )
    )

    let languageSegmentedControl: UISegmentedControl = {
        let control = UISegmentedControl(items: [
            AppLanguage.english.displayKey.localized,
            AppLanguage.portugueseBrazil.displayKey.localized
        ])
        control.translatesAutoresizingMaskIntoConstraints = false
        return control
    }()

    let themeTitleLabel = DSLabel(
        text: "settings.theme.title".localized,
        configuration: DSLabelConfiguration(
            style: .cellSubtitle,
            color: .secondary,
            numberOfLines: 1
        )
    )

    let themeSegmentedControl: UISegmentedControl = {
        let control = UISegmentedControl(items: [
            AppTheme.light.displayKey.localized,
            AppTheme.dark.displayKey.localized
        ])
        control.translatesAutoresizingMaskIntoConstraints = false
        return control
    }()

    let saveButton = DSButton(style: .primary, title: "settings.button.save".localized)

    let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    // MARK: - Init(s).
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Private Function(s).
    private func setupUI() {
        backgroundColor = .systemBackground

        addSubview(stackView)

        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(subtitleLabel)
        stackView.addArrangedSubview(languageTitleLabel)
        stackView.addArrangedSubview(languageSegmentedControl)
        stackView.addArrangedSubview(themeTitleLabel)
        stackView.addArrangedSubview(themeSegmentedControl)
        stackView.addArrangedSubview(saveButton)

        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 24),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24)
        ])
    }
}
