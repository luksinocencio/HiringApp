import UIKit

enum DSTextFieldStyle {
    case primary

    var backgroundColor: UIColor {
        switch self {
        case .primary:
            return .secondarySystemBackground
        }
    }

    var textColor: UIColor {
        switch self {
        case .primary:
            return .label
        }
    }

    var placeholderColor: UIColor {
        switch self {
        case .primary:
            return .tertiaryLabel
        }
    }

    var borderStyle: UITextField.BorderStyle {
        switch self {
        case .primary:
            return .roundedRect
        }
    }

    var cornerRadius: CGFloat {
        switch self {
        case .primary:
            return 12
        }
    }

    var height: CGFloat {
        switch self {
        case .primary:
            return 48
        }
    }
}
