import UIKit

final class SimulatePermissionsView: UIView {
    // MARK: - Property(ies).
    let typeSegmentedControl: UISegmentedControl = {
        let control = UISegmentedControl(items: [
            "permission_types.passcode".localized,
            "permission_types.smartphone".localized,
            "permission_types.card".localized
        ])
        control.translatesAutoresizingMaskIntoConstraints = false
        return control
    }()

    let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 140
        return tableView
    }()

    let loadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.hidesWhenStopped = true
        return indicator
    }()

    // MARK: - Init(s).
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Private Function(s).
    private func setupUI() {
        addSubview(typeSegmentedControl)
        addSubview(tableView)
        addSubview(loadingIndicator)

        NSLayoutConstraint.activate([
            typeSegmentedControl.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 12),
            typeSegmentedControl.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            typeSegmentedControl.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),

            tableView.topAnchor.constraint(equalTo: typeSegmentedControl.bottomAnchor, constant: 12),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor),

            loadingIndicator.centerXAnchor.constraint(equalTo: centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}
