import UIKit

final class DSTextField: UITextField {

    private var fieldHeightConstraint: NSLayoutConstraint?

    init(configuration: DSTextFieldConfiguration) {
        super.init(frame: .zero)
        setupBase()
        apply(configuration: configuration)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupBase()
    }

    func apply(configuration: DSTextFieldConfiguration) {
        applyStyle(configuration.style)
        applyInputType(configuration.inputType)
        applyTextConfiguration(configuration)
        applyAccessibility(configuration.accessibility, placeholder: configuration.placeholder)
    }

    private func setupBase() {
        translatesAutoresizingMaskIntoConstraints = false
        adjustsFontForContentSizeCategory = true
        isAccessibilityElement = true
        layer.masksToBounds = true
    }

    private func applyStyle(_ style: DSTextFieldStyle) {
        borderStyle = style.borderStyle
        backgroundColor = style.backgroundColor
        textColor = style.textColor
        layer.cornerRadius = style.cornerRadius

        fieldHeightConstraint?.isActive = false
        fieldHeightConstraint = heightAnchor.constraint(equalToConstant: style.height)
        fieldHeightConstraint?.isActive = true
    }

    private func applyInputType(_ inputType: DSTextFieldInputType) {
        keyboardType = inputType.keyboardType
        textContentType = inputType.textContentType
        autocorrectionType = inputType.autocorrectionType
        autocapitalizationType = inputType.autocapitalizationType
        isSecureTextEntry = inputType.isSecureTextEntry
        returnKeyType = inputType.returnKeyType
    }

    private func applyTextConfiguration(_ configuration: DSTextFieldConfiguration) {
        font = configuration.font
        clearButtonMode = configuration.clearButtonMode

        if let placeholderText = configuration.placeholder {
            attributedPlaceholder = NSAttributedString(
                string: placeholderText,
                attributes: [
                    .foregroundColor: configuration.style.placeholderColor,
                    .font: configuration.font
                ]
            )
        } else {
            attributedPlaceholder = nil
            placeholder = nil
        }
    }

    private func applyAccessibility(
        _ accessibility: DSTextFieldAccessibilityConfiguration,
        placeholder: String?
    ) {
        accessibilityLabel = accessibility.label ?? placeholder
        accessibilityIdentifier = accessibility.identifier
        accessibilityHint = accessibility.hint
        accessibilityValue = accessibility.value
        accessibilityTraits = .staticText
    }
}
