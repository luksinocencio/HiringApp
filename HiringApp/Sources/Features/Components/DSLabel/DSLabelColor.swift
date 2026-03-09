import UIKit

enum DSLabelColor {
    case primary
    case secondary
    case inverse
    case error
    case success
    case warning
    case custom(UIColor)

    var uiColor: UIColor {
        switch self {
        case .primary:
            return .label
        case .secondary:
            return .secondaryLabel
        case .inverse:
            return .white
        case .error:
            return .systemRed
        case .success:
            return .systemGreen
        case .warning:
            return .systemOrange
        case .custom(let color):
            return color
        }
    }
}

