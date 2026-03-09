import UIKit

enum DSTextFieldInputType {
    case generic
    case name
    case lastName
    case email
    case password
    case phone

    var keyboardType: UIKeyboardType {
        switch self {
        case .email:
            return .emailAddress
        case .phone:
            return .phonePad
        case .generic, .name, .lastName, .password:
            return .default
        }
    }

    var textContentType: UITextContentType? {
        switch self {
        case .name:
            return .givenName
        case .lastName:
            return .familyName
        case .email:
            return .emailAddress
        case .password:
            return .password
        case .phone:
            return .telephoneNumber
        case .generic:
            return nil
        }
    }

    var autocorrectionType: UITextAutocorrectionType {
        switch self {
        case .email, .password, .phone:
            return .no
        case .generic, .name, .lastName:
            return .default
        }
    }

    var autocapitalizationType: UITextAutocapitalizationType {
        switch self {
        case .email, .password:
            return .none
        case .name, .lastName:
            return .words
        case .phone:
            return .none
        case .generic:
            return .sentences
        }
    }

    var isSecureTextEntry: Bool {
        switch self {
        case .password:
            return true
        default:
            return false
        }
    }

    var returnKeyType: UIReturnKeyType {
        switch self {
        case .name, .lastName, .email, .phone:
            return .next
        case .password:
            return .done
        case .generic:
            return .default
        }
    }
}
