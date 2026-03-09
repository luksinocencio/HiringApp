import UIKit

struct DSLabelConfiguration {
    let style: DSLabelStyle
    let color: DSLabelColor
    let alignment: NSTextAlignment
    let numberOfLines: Int
    let accessibility: DSLabelAccessibilityConfiguration

    init(
        style: DSLabelStyle,
        color: DSLabelColor = .primary,
        alignment: NSTextAlignment = .natural,
        numberOfLines: Int? = nil,
        accessibility: DSLabelAccessibilityConfiguration = .init()
    ) {
        self.style = style
        self.color = color
        self.alignment = alignment
        self.numberOfLines = numberOfLines ?? style.defaultNumberOfLines
        self.accessibility = accessibility
    }
}

extension DSLabelConfiguration {
    static let screenTitle = DSLabelConfiguration(
        style: .title,
        color: .primary
    )

    static let screenSubtitle = DSLabelConfiguration(
        style: .body,
        color: .secondary
    )

    static let cellTitle = DSLabelConfiguration(
        style: .cellTitle,
        color: .primary
    )

    static let cellSubtitle = DSLabelConfiguration(
        style: .cellSubtitle,
        color: .secondary
    )
}
