import UIKit

final class DoorDetailEventTableViewCell: UITableViewCell {
    static let reuseIdentifier = "DoorDetailEventTableViewCell"

    private let cardView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .secondarySystemBackground
        view.layer.cornerRadius = 14
        view.layer.masksToBounds = true
        return view
    }()

    private let typeBadgeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 11, weight: .bold)
        label.textColor = .white
        label.backgroundColor = .systemBlue
        label.layer.cornerRadius = 8
        label.layer.masksToBounds = true
        label.textAlignment = .center
        return label
    }()

    private let eventNumberLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        label.textColor = .label
        return label
    }()

    private let timestampLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 13, weight: .regular)
        label.textColor = .secondaryLabel
        label.numberOfLines = 1
        return label
    }()

    private let detailsLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 12, weight: .regular)
        label.textColor = .secondaryLabel
        label.numberOfLines = 0
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        typeBadgeLabel.text = nil
        eventNumberLabel.text = nil
        timestampLabel.text = nil
        detailsLabel.text = nil
    }

    func configure(with event: DoorEvent) {
        typeBadgeLabel.text = "  \(event.logType)  "
        eventNumberLabel.text = "Log #\(event.logNumber)"
        timestampLabel.text = event.eventTimestamp

        let detailRows = event.additionalData.map { item in
            "\(item.parameterName): \(item.parsedValue) (hex: \(item.hexValue))"
        }
        detailsLabel.text = detailRows.joined(separator: "\n")

        switch event.logType {
        case "UNLOCK":
            typeBadgeLabel.backgroundColor = .systemGreen
        case "LOCK":
            typeBadgeLabel.backgroundColor = .systemOrange
        default:
            typeBadgeLabel.backgroundColor = .systemBlue
        }
    }

    private func setupUI() {
        backgroundColor = .clear
        selectionStyle = .none

        contentView.backgroundColor = .clear
        contentView.addSubview(cardView)

        cardView.addSubview(typeBadgeLabel)
        cardView.addSubview(eventNumberLabel)
        cardView.addSubview(timestampLabel)
        cardView.addSubview(detailsLabel)

        NSLayoutConstraint.activate([
            cardView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 6),
            cardView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            cardView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            cardView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -6),

            typeBadgeLabel.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 12),
            typeBadgeLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 12),

            eventNumberLabel.centerYAnchor.constraint(equalTo: typeBadgeLabel.centerYAnchor),
            eventNumberLabel.leadingAnchor.constraint(equalTo: typeBadgeLabel.trailingAnchor, constant: 10),
            eventNumberLabel.trailingAnchor.constraint(lessThanOrEqualTo: cardView.trailingAnchor, constant: -12),

            timestampLabel.topAnchor.constraint(equalTo: typeBadgeLabel.bottomAnchor, constant: 8),
            timestampLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 12),
            timestampLabel.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -12),

            detailsLabel.topAnchor.constraint(equalTo: timestampLabel.bottomAnchor, constant: 8),
            detailsLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 12),
            detailsLabel.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -12),
            detailsLabel.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -12)
        ])
    }
}
