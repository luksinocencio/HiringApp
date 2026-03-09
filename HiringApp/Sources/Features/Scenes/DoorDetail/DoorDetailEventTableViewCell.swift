import UIKit

final class DoorDetailEventTableViewCell: UITableViewCell {
    // MARK: - Property(ies).
    static let reuseIdentifier = "DoorDetailEventTableViewCell"

    // MARK: - Private Property(ies).
    private let cardView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .secondarySystemBackground
        view.layer.cornerRadius = 14
        view.layer.masksToBounds = true
        return view
    }()

    private let typeBadgeLabel = DSLabel(
        configuration: DSLabelConfiguration(
            style: .caption,
            color: .primary,
            alignment: .center,
            numberOfLines: 1
        )
    )

    private let typeBadgeContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        view.layer.cornerRadius = 10
        view.layer.borderWidth = 1
        view.layer.masksToBounds = true
        return view
    }()

    private let eventNumberLabel = DSLabel(
        configuration: DSLabelConfiguration(
            style: .cellTitle,
            color: .primary,
            numberOfLines: 1
        )
    )

    private let timestampLabel = DSLabel(
        configuration: DSLabelConfiguration(
            style: .cellSubtitle,
            color: .secondary,
            numberOfLines: 1
        )
    )

    private let detailsLabel = DSLabel(
        configuration: DSLabelConfiguration(
            style: .caption,
            color: .secondary
        )
    )

    // MARK: - Init(s).
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Functions(s).
    override func prepareForReuse() {
        super.prepareForReuse()
        typeBadgeLabel.text = nil
        eventNumberLabel.text = nil
        timestampLabel.text = nil
        detailsLabel.text = nil
    }

    func configure(with event: DoorEvent) {
        typeBadgeLabel.text = event.logType
        eventNumberLabel.text = "Log #\(event.logNumber)"
        timestampLabel.text = event.eventTimestamp

        let detailRows = event.additionalData.map { item in
            "\(item.parameterName): \(item.parsedValue) (hex: \(item.hexValue))"
        }
        detailsLabel.text = detailRows.joined(separator: "\n")

        let badgeColor: UIColor
        switch event.logType {
        case "UNLOCK":
            badgeColor = .systemGreen
        case "LOCK":
            badgeColor = .systemOrange
        default:
            badgeColor = .systemBlue
        }

        typeBadgeLabel.textColor = badgeColor
        typeBadgeContainer.layer.borderColor = badgeColor.cgColor
    }

    // MARK: - Private Functions(s).
    private func setupUI() {
        typeBadgeLabel.font = UIFontMetrics(forTextStyle: .caption1)
            .scaledFont(for: UIFont.systemFont(ofSize: 12, weight: .semibold))
        typeBadgeLabel.adjustsFontForContentSizeCategory = true

        backgroundColor = .clear
        selectionStyle = .none

        contentView.backgroundColor = .clear
        contentView.addSubview(cardView)

        cardView.addSubview(typeBadgeContainer)
        typeBadgeContainer.addSubview(typeBadgeLabel)
        cardView.addSubview(eventNumberLabel)
        cardView.addSubview(timestampLabel)
        cardView.addSubview(detailsLabel)

        NSLayoutConstraint.activate([
            cardView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 6),
            cardView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            cardView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            cardView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -6),

            eventNumberLabel.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 12),
            eventNumberLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 12),
            eventNumberLabel.trailingAnchor.constraint(lessThanOrEqualTo: cardView.trailingAnchor, constant: -12),

            typeBadgeContainer.topAnchor.constraint(equalTo: eventNumberLabel.bottomAnchor, constant: 8),
            typeBadgeContainer.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 12),

            typeBadgeLabel.topAnchor.constraint(equalTo: typeBadgeContainer.topAnchor, constant: 4),
            typeBadgeLabel.leadingAnchor.constraint(equalTo: typeBadgeContainer.leadingAnchor, constant: 8),
            typeBadgeLabel.trailingAnchor.constraint(equalTo: typeBadgeContainer.trailingAnchor, constant: -8),
            typeBadgeLabel.bottomAnchor.constraint(equalTo: typeBadgeContainer.bottomAnchor, constant: -4),

            timestampLabel.topAnchor.constraint(equalTo: typeBadgeContainer.bottomAnchor, constant: 8),
            timestampLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 12),
            timestampLabel.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -12),

            detailsLabel.topAnchor.constraint(equalTo: timestampLabel.bottomAnchor, constant: 8),
            detailsLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 12),
            detailsLabel.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -12),
            detailsLabel.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -12)
        ])
    }
}
