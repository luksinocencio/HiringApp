import UIKit

final class DoorTableViewCell: UITableViewCell {
    // MARK: - Property(ies).
    static let reuseIdentifier = "DoorTableViewCell"
    var onTapAdd: (() -> Void)?
    var onTapDetails: (() -> Void)?

    // MARK: - Private Property(ies).
    private let cardView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .secondarySystemBackground
        view.layer.cornerRadius = 14
        view.layer.masksToBounds = true
        return view
    }()

    private let titleLabel = DSLabel(
        configuration: .cellTitle
    )

    private let addressIconView: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "mappin.and.ellipse"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.tintColor = .secondaryLabel
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private let addressLabel = DSLabel(
        configuration: DSLabelConfiguration(
            style: .cellSubtitle,
            color: .secondary,
            numberOfLines: 2
        )
    )

    private let batteryContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .tertiarySystemBackground
        view.layer.cornerRadius = 10
        view.layer.masksToBounds = true
        return view
    }()

    private let batteryIconView: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "battery.100"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.tintColor = .systemGreen
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private let batteryLabel = DSLabel(
        configuration: DSLabelConfiguration(
            style: .caption,
            color: .secondary,
            numberOfLines: 1
        )
    )

    private let detailsButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "info.circle.fill"), for: .normal)
        button.tintColor = .systemBlue
        button.backgroundColor = .systemBlue.withAlphaComponent(0.12)
        button.layer.cornerRadius = 16
        return button
    }()

    private let addButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "plus.circle.fill"), for: .normal)
        button.tintColor = .systemGreen
        button.backgroundColor = .systemGreen.withAlphaComponent(0.12)
        button.layer.cornerRadius = 16
        return button
    }()

    private let actionsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = 12
        stackView.alignment = .center
        return stackView
    }()

    // MARK: - Init(s).
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Function(s).
    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = nil
        addressLabel.text = nil
        batteryLabel.text = nil
        onTapAdd = nil
        onTapDetails = nil
    }

    func configure(with door: DoorDTO) {
        titleLabel.text = door.name
        addressLabel.text = door.address
        batteryLabel.text = "\(door.battery)%"

        let tintColor: UIColor
        switch door.battery {
        case 0..<20:
            tintColor = .systemRed
        case 20..<50:
            tintColor = .systemOrange
        default:
            tintColor = .systemGreen
        }

        batteryIconView.tintColor = tintColor
    }

    // MARK: - Private Function(s).
    private func setupUI() {
        backgroundColor = .clear
        selectionStyle = .none

        contentView.backgroundColor = .clear
        contentView.addSubview(cardView)

        cardView.addSubview(titleLabel)
        cardView.addSubview(addressIconView)
        cardView.addSubview(addressLabel)
        cardView.addSubview(batteryContainerView)
        cardView.addSubview(actionsStackView)

        batteryContainerView.addSubview(batteryIconView)
        batteryContainerView.addSubview(batteryLabel)
        actionsStackView.addArrangedSubview(detailsButton)
        actionsStackView.addArrangedSubview(addButton)

        detailsButton.addTarget(self, action: #selector(didTapDetails), for: .touchUpInside)
        addButton.addTarget(self, action: #selector(didTapAdd), for: .touchUpInside)

        NSLayoutConstraint.activate([
            cardView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 6),
            cardView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            cardView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            cardView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -6),

            titleLabel.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 14),
            titleLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 14),
            titleLabel.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -14),

            addressIconView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            addressIconView.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 14),
            addressIconView.widthAnchor.constraint(equalToConstant: 14),
            addressIconView.heightAnchor.constraint(equalToConstant: 14),

            addressLabel.centerYAnchor.constraint(equalTo: addressIconView.centerYAnchor),
            addressLabel.leadingAnchor.constraint(equalTo: addressIconView.trailingAnchor, constant: 6),
            addressLabel.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -14),
            addressLabel.bottomAnchor.constraint(lessThanOrEqualTo: batteryContainerView.topAnchor, constant: -10),
            addressLabel.bottomAnchor.constraint(lessThanOrEqualTo: actionsStackView.topAnchor, constant: -10),

            actionsStackView.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -12),
            actionsStackView.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -10),

            detailsButton.widthAnchor.constraint(equalToConstant: 32),
            detailsButton.heightAnchor.constraint(equalToConstant: 32),
            addButton.widthAnchor.constraint(equalToConstant: 32),
            addButton.heightAnchor.constraint(equalToConstant: 32),

            batteryContainerView.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 12),
            batteryContainerView.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -10),

            batteryIconView.leadingAnchor.constraint(equalTo: batteryContainerView.leadingAnchor, constant: 8),
            batteryIconView.centerYAnchor.constraint(equalTo: batteryContainerView.centerYAnchor),
            batteryIconView.widthAnchor.constraint(equalToConstant: 12),
            batteryIconView.heightAnchor.constraint(equalToConstant: 18),

            batteryLabel.leadingAnchor.constraint(equalTo: batteryIconView.trailingAnchor, constant: 6),
            batteryLabel.trailingAnchor.constraint(equalTo: batteryContainerView.trailingAnchor, constant: -8),
            batteryLabel.topAnchor.constraint(equalTo: batteryContainerView.topAnchor, constant: 6),
            batteryLabel.bottomAnchor.constraint(equalTo: batteryContainerView.bottomAnchor, constant: -6)
        ])

        batteryIconView.transform = CGAffineTransform(rotationAngle: -.pi / 2)
    }

    // MARK: - Private Selector(s).
    @objc
    private func didTapAdd() {
        onTapAdd?()
    }

    @objc
    private func didTapDetails() {
        onTapDetails?()
    }
}
