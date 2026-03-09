import UIKit

final class DSRoundedIconButton: UIButton {
    // MARK: - Typealias.
    typealias Action = () -> Void

    // MARK: - Private Property(ies).
    private var onTap: Action?

    // MARK: - Init(s).
    init(
        systemName: String,
        tintColor: UIColor,
        backgroundColor: UIColor,
        diameter: CGFloat = 32,
        action: Action? = nil
    ) {
        self.onTap = action
        super.init(frame: .zero)
        setupBase(diameter: diameter)
        applyStyle(systemName: systemName, tintColor: tintColor, backgroundColor: backgroundColor)
        bindAction()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    // MARK: - Private Function(s).
    private func setupBase(diameter: CGFloat) {
        translatesAutoresizingMaskIntoConstraints = false
        layer.cornerRadius = diameter / 2
        clipsToBounds = true

        NSLayoutConstraint.activate([
            widthAnchor.constraint(equalToConstant: diameter),
            heightAnchor.constraint(equalToConstant: diameter)
        ])
    }

    private func applyStyle(systemName: String, tintColor: UIColor, backgroundColor: UIColor) {
        setImage(UIImage(systemName: systemName), for: .normal)
        self.tintColor = tintColor
        self.backgroundColor = backgroundColor
    }

    private func bindAction() {
        addAction(
            UIAction { [weak self] _ in
                self?.onTap?()
            },
            for: .touchUpInside
        )
    }
}
