import UIKit

final class DSLabel: UILabel {
    init(
        text: String? = nil,
        configuration: DSLabelConfiguration
    ) {
        super.init(frame: .zero)
        setupBase()
        self.text = text
        apply(configuration: configuration)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupBase()
    }

    func apply(configuration: DSLabelConfiguration) {
        let baseFont = UIFont.systemFont(
            ofSize: configuration.style.fontSize,
            weight: configuration.style.fontWeight
        )

        font = UIFontMetrics(forTextStyle: configuration.style.textStyle)
            .scaledFont(for: baseFont)

        textColor = configuration.color.uiColor
        textAlignment = configuration.alignment
        numberOfLines = configuration.numberOfLines

        applyAccessibility(configuration: configuration)
    }

    private func setupBase() {
        translatesAutoresizingMaskIntoConstraints = false
        adjustsFontForContentSizeCategory = true
        isAccessibilityElement = true
    }

    private func applyAccessibility(configuration: DSLabelConfiguration) {
        accessibilityLabel = configuration.accessibility.label ?? text
        accessibilityIdentifier = configuration.accessibility.identifier
        accessibilityHint = configuration.accessibility.hint
        accessibilityValue = configuration.accessibility.value
        accessibilityTraits = configuration.accessibility.traits ?? configuration.style.accessibilityTraits
    }
}
