import UIKit

final class DSButton: UIButton {

    typealias Action = () -> Void

    private var onTap: Action?

    init(
        style: DSButtonStyle,
        title: String,
        action: Action? = nil
    ) {
        self.onTap = action
        super.init(frame: .zero)
        setupBase()
        applyStyle(style, title: title)
        bindAction()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupBase()
    }

    private func setupBase() {
        translatesAutoresizingMaskIntoConstraints = false
        titleLabel?.adjustsFontForContentSizeCategory = true
    }

    private func bindAction() {
        addAction(
            UIAction { [weak self] _ in
                self?.onTap?()
            },
            for: .touchUpInside
        )
    }

    private func applyStyle(_ style: DSButtonStyle, title: String) {
        switch style {
        case .primary:
            applyPrimary(title: title)

        case .secondary:
            applySecondary(title: title)

        case .tertiary(let highlightedText):
            applyTertiary(title: title, highlightedText: highlightedText)
        }
    }

    private func applyPrimary(title: String) {
        var configuration = UIButton.Configuration.filled()
        configuration.title = title
        configuration.cornerStyle = .medium
        configuration.baseBackgroundColor = .systemBlue
        configuration.baseForegroundColor = .white
        configuration.contentInsets = NSDirectionalEdgeInsets(
            top: 12,
            leading: 16,
            bottom: 12,
            trailing: 16
        )

        self.configuration = configuration
        titleLabel?.font = .preferredFont(forTextStyle: .headline)
    }

    private func applySecondary(title: String) {
        var configuration = UIButton.Configuration.filled()
        configuration.title = title
        configuration.cornerStyle = .medium
        configuration.baseBackgroundColor = .systemGray5
        configuration.baseForegroundColor = .label
        configuration.contentInsets = NSDirectionalEdgeInsets(
            top: 12,
            leading: 16,
            bottom: 12,
            trailing: 16
        )

        self.configuration = configuration
        titleLabel?.font = .preferredFont(forTextStyle: .headline)
    }

    private func applyTertiary(title: String, highlightedText: String) {
        configuration = nil
        backgroundColor = .clear
        layer.cornerRadius = 0
        contentEdgeInsets = .zero

        let attributedTitle = makeTertiaryAttributedTitle(
            fullText: title,
            highlightedText: highlightedText
        )

        setAttributedTitle(attributedTitle, for: .normal)
    }

    private func makeTertiaryAttributedTitle(
        fullText: String,
        highlightedText: String
    ) -> NSAttributedString {
        let baseFont = UIFont.preferredFont(forTextStyle: .body)
        let highlightedFont = UIFont.systemFont(
            ofSize: baseFont.pointSize,
            weight: .semibold
        )

        let attributedText = NSMutableAttributedString(
            string: fullText,
            attributes: [
                .font: baseFont,
                .foregroundColor: UIColor.secondaryLabel
            ]
        )

        let nsText = fullText as NSString
        let range = nsText.range(of: highlightedText)

        if range.location != NSNotFound {
            attributedText.addAttributes(
                [
                    .font: highlightedFont,
                    .foregroundColor: UIColor.systemBlue
                ],
                range: range
            )
        }

        return attributedText
    }
}
