import UIKit

struct DSLabelAccessibilityConfiguration {
    let label: String?
    let identifier: String?
    let hint: String?
    let value: String?
    let traits: UIAccessibilityTraits?

    init(
        label: String? = nil,
        identifier: String? = nil,
        hint: String? = nil,
        value: String? = nil,
        traits: UIAccessibilityTraits? = nil
    ) {
        self.label = label
        self.identifier = identifier
        self.hint = hint
        self.value = value
        self.traits = traits
    }
}
