import UIKit

final class DoorTableViewCell: UITableViewCell {
    // MARK: - Property(ies).
    static let reuseIdentifier = "DoorTableViewCell"

    // MARK: - Private Property(ies).
    private let cardView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .secondarySystemBackground
        view.layer.cornerRadius = 14
        view.layer.masksToBounds = true
        return view
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 17, weight: .semibold)
        label.textColor = .label
        label.numberOfLines = 1
        return label
    }()

    private let addressIconView: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "mappin.and.ellipse"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.tintColor = .secondaryLabel
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private let addressLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 13, weight: .regular)
        label.textColor = .secondaryLabel
        label.numberOfLines = 2
        return label
    }()

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

    private let batteryLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 13, weight: .semibold)
        label.textColor = .secondaryLabel
        return label
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

        batteryContainerView.addSubview(batteryIconView)
        batteryContainerView.addSubview(batteryLabel)

        NSLayoutConstraint.activate([
            cardView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 6),
            cardView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            cardView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            cardView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -6),

            titleLabel.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 14),
            titleLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 14),
            titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: batteryContainerView.leadingAnchor, constant: -10),

            addressIconView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            addressIconView.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 14),
            addressIconView.widthAnchor.constraint(equalToConstant: 14),
            addressIconView.heightAnchor.constraint(equalToConstant: 14),

            addressLabel.centerYAnchor.constraint(equalTo: addressIconView.centerYAnchor),
            addressLabel.leadingAnchor.constraint(equalTo: addressIconView.trailingAnchor, constant: 6),
            addressLabel.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -14),
            addressLabel.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -14),

            batteryContainerView.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 12),
            batteryContainerView.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -12),

            batteryIconView.leadingAnchor.constraint(equalTo: batteryContainerView.leadingAnchor, constant: 8),
            batteryIconView.centerYAnchor.constraint(equalTo: batteryContainerView.centerYAnchor),
            batteryIconView.widthAnchor.constraint(equalToConstant: 14),
            batteryIconView.heightAnchor.constraint(equalToConstant: 14),

            batteryLabel.leadingAnchor.constraint(equalTo: batteryIconView.trailingAnchor, constant: 6),
            batteryLabel.trailingAnchor.constraint(equalTo: batteryContainerView.trailingAnchor, constant: -8),
            batteryLabel.topAnchor.constraint(equalTo: batteryContainerView.topAnchor, constant: 6),
            batteryLabel.bottomAnchor.constraint(equalTo: batteryContainerView.bottomAnchor, constant: -6)
        ])
    }
}
