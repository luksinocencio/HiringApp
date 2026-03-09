import UIKit

final class SimulatePermissionTableViewCell: UITableViewCell {
    // MARK: - Property(ies).
    static let reuseIdentifier = "SimulatePermissionTableViewCell"

    // MARK: - Private Property(ies).
    private let cardView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .secondarySystemBackground
        view.layer.cornerRadius = 14
        view.layer.masksToBounds = true
        return view
    }()

    private let messageKeyLabel = DSLabel(
        configuration: DSLabelConfiguration(
            style: .cellTitle,
            color: .primary,
            numberOfLines: 1
        )
    )

    private let typeLabel = DSLabel(
        configuration: DSLabelConfiguration(
            style: .cellSubtitle,
            color: .secondary,
            numberOfLines: 1
        )
    )

    private let valueLabel = DSLabel(
        configuration: DSLabelConfiguration(
            style: .caption,
            color: .primary,
            numberOfLines: 1
        )
    )

    private let periodLabel = DSLabel(
        configuration: DSLabelConfiguration(
            style: .caption,
            color: .secondary,
            numberOfLines: 2
        )
    )

    private let weekDaysLabel = DSLabel(
        configuration: DSLabelConfiguration(
            style: .caption,
            color: .secondary,
            numberOfLines: 1
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

    // MARK: - Function(s).
    override func prepareForReuse() {
        super.prepareForReuse()
        messageKeyLabel.text = nil
        typeLabel.text = nil
        valueLabel.text = nil
        periodLabel.text = nil
        weekDaysLabel.text = nil
    }

    func configure(with permission: SimulatedPermission) {
        messageKeyLabel.text = "\("simulate_permissions.field.message_key".localized): \(permission.messageKey)"
        typeLabel.text = "\("simulate_permissions.field.type".localized): \(permission.type)"
        valueLabel.text = "\("simulate_permissions.field.value".localized): \(permission.value)"
        periodLabel.text = "\("simulate_permissions.field.period".localized): \(Self.displayDate(from: permission.startDateTime)) - \(Self.displayDate(from: permission.endDateTime))"
        weekDaysLabel.text = "\("simulate_permissions.field.week_days".localized)"
    }

    // MARK: - Private Function(s).
    private func setupUI() {
        backgroundColor = .clear
        selectionStyle = .none

        contentView.backgroundColor = .clear
        contentView.addSubview(cardView)

        cardView.addSubview(messageKeyLabel)
        cardView.addSubview(typeLabel)
        cardView.addSubview(valueLabel)
        cardView.addSubview(periodLabel)
        cardView.addSubview(weekDaysLabel)

        NSLayoutConstraint.activate([
            cardView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 6),
            cardView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            cardView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            cardView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -6),

            messageKeyLabel.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 12),
            messageKeyLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 12),
            messageKeyLabel.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -12),

            typeLabel.topAnchor.constraint(equalTo: messageKeyLabel.bottomAnchor, constant: 6),
            typeLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 12),
            typeLabel.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -12),

            valueLabel.topAnchor.constraint(equalTo: typeLabel.bottomAnchor, constant: 6),
            valueLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 12),
            valueLabel.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -12),

            periodLabel.topAnchor.constraint(equalTo: valueLabel.bottomAnchor, constant: 6),
            periodLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 12),
            periodLabel.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -12),

            weekDaysLabel.topAnchor.constraint(equalTo: periodLabel.bottomAnchor, constant: 6),
            weekDaysLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 12),
            weekDaysLabel.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -12),
            weekDaysLabel.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -12)
        ])
    }

    // MARK: - Private Property(ies).
    private static let inputDateFormatter: ISO8601DateFormatter = {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime]
        return formatter
    }()

    private static let outputDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter
    }()

    // MARK: - Private Function(s).
    private static func displayDate(from raw: String) -> String {
        guard let date = inputDateFormatter.date(from: raw) else { return raw }
        return outputDateFormatter.string(from: date)
    }
}
