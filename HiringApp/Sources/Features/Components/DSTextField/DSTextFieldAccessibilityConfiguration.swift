import UIKit

struct DSTextFieldAccessibilityConfiguration {
    let label: String?
    let identifier: String?
    let hint: String?
    let value: String?

    init(
        label: String? = nil,
        identifier: String? = nil,
        hint: String? = nil,
        value: String? = nil
    ) {
        self.label = label
        self.identifier = identifier
        self.hint = hint
        self.value = value
    }
}
