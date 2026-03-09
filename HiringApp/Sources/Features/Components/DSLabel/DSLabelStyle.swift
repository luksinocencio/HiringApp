import UIKit

enum DSLabelStyle {
    case largeTitle
    case title
    case subtitle
    case body
    case bodyBold
    case caption
    case cellTitle
    case cellSubtitle

    var fontSize: CGFloat {
        switch self {
        case .largeTitle:
            return 32
        case .title:
            return 24
        case .subtitle:
            return 18
        case .body:
            return 16
        case .bodyBold:
            return 16
        case .caption:
            return 12
        case .cellTitle:
            return 17
        case .cellSubtitle:
            return 15
        }
    }

    var fontWeight: UIFont.Weight {
        switch self {
        case .largeTitle:
            return .bold
        case .title:
            return .bold
        case .subtitle:
            return .semibold
        case .body:
            return .regular
        case .bodyBold:
            return .semibold
        case .caption:
            return .regular
        case .cellTitle:
            return .semibold
        case .cellSubtitle:
            return .regular
        }
    }

    var textStyle: UIFont.TextStyle {
        switch self {
        case .largeTitle:
            return .largeTitle
        case .title:
            return .title2
        case .subtitle:
            return .title3
        case .body:
            return .body
        case .bodyBold:
            return .body
        case .caption:
            return .caption1
        case .cellTitle:
            return .headline
        case .cellSubtitle:
            return .subheadline
        }
    }

    var defaultNumberOfLines: Int {
        switch self {
        case .largeTitle, .title, .subtitle, .body, .bodyBold, .caption:
            return 0
        case .cellTitle:
            return 1
        case .cellSubtitle:
            return 2
        }
    }

    var accessibilityTraits: UIAccessibilityTraits {
        switch self {
        case .largeTitle, .title:
            return .header
        default:
            return .staticText
        }
    }
}
