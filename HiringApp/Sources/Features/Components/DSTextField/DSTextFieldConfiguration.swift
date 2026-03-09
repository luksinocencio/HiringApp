import UIKit

struct DSTextFieldConfiguration {
    let style: DSTextFieldStyle
    let inputType: DSTextFieldInputType
    let placeholder: String?
    let font: UIFont
    let clearButtonMode: UITextField.ViewMode
    let accessibility: DSTextFieldAccessibilityConfiguration

    init(
        style: DSTextFieldStyle = .primary,
        inputType: DSTextFieldInputType = .generic,
        placeholder: String? = nil,
        font: UIFont = .preferredFont(forTextStyle: .body),
        clearButtonMode: UITextField.ViewMode = .whileEditing,
        accessibility: DSTextFieldAccessibilityConfiguration = .init()
    ) {
        self.style = style
        self.inputType = inputType
        self.placeholder = placeholder
        self.font = font
        self.clearButtonMode = clearButtonMode
        self.accessibility = accessibility
    }
}


extension DSTextFieldConfiguration {
    static let firstName = DSTextFieldConfiguration(
        inputType: .name,
        placeholder: "textfield.first_name".localized
    )

    static let lastName = DSTextFieldConfiguration(
        inputType: .lastName,
        placeholder: "textfield.last_name".localized
    )

    static let email = DSTextFieldConfiguration(
        inputType: .email,
        placeholder: "textfield.email".localized
    )

    static let password = DSTextFieldConfiguration(
        inputType: .password,
        placeholder: "textfield.password".localized
    )
}
