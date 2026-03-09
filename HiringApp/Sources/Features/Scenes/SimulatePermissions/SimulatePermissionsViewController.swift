import UIKit

final class SimulatePermissionsViewController: UIViewController {
    // MARK: - Private Enum(s).
    private enum Constants {
        static let defaultSimulatedCount = 5
        static let cardSimulatedCount = 3
    }

    // MARK: - Private Property(ies).
    private let contentView: SimulatePermissionsView
    private let service: AppServiceProtocol

    private var permissions: [SimulatedPermission] = []
    private var currentType: SimulatedPermissionType = .smartphone

    // MARK: - Init(s).
    init(
        contentView: SimulatePermissionsView = SimulatePermissionsView(),
        service: AppServiceProtocol = Service.shared
    ) {
        self.contentView = contentView
        self.service = service
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle.
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        loadPermissions()
    }

    // MARK: - Private Function(s).
    private func setup() {
        view.backgroundColor = .systemBackground
        title = "simulate_permissions.title".localized

        view.addSubview(contentView)
        setupContentViewToBounds(contentView: contentView)

        if let defaultIndex = SimulatedPermissionType.allCases.firstIndex(of: .smartphone) {
            contentView.typeSegmentedControl.selectedSegmentIndex = defaultIndex
        }
        contentView.typeSegmentedControl.addTarget(self, action: #selector(didChangeType), for: .valueChanged)

        contentView.tableView.dataSource = self
        contentView.tableView.register(
            SimulatePermissionTableViewCell.self,
            forCellReuseIdentifier: SimulatePermissionTableViewCell.reuseIdentifier
        )
        contentView.tableView.separatorStyle = .none
        contentView.tableView.tableFooterView = UIView()
    }

    private func loadPermissions() {
        let requestType = currentType
        permissions = []
        contentView.tableView.reloadData()
        contentView.loadingIndicator.startAnimating()

        Task {
            let result = await service.simulatePermissions(
                count: simulatedCount(for: requestType),
                type: requestType
            )

            DispatchQueue.main.async { [weak self] in
                guard let self else { return }
                guard requestType == self.currentType else { return }

                self.contentView.loadingIndicator.stopAnimating()

                switch result {
                case let .success(response):
                    self.permissions = response
                    self.contentView.tableView.reloadData()

                case .failure:
                    self.showErrorAlert()
                }
            }
        }
    }

    // MARK: - Private Selector(s).
    @objc
    private func didChangeType() {
        let index = contentView.typeSegmentedControl.selectedSegmentIndex
        guard SimulatedPermissionType.allCases.indices.contains(index) else { return }
        currentType = SimulatedPermissionType.allCases[index]
        loadPermissions()
    }

    private func simulatedCount(for type: SimulatedPermissionType) -> Int {
        switch type {
        case .card:
            return Constants.cardSimulatedCount
        case .passcode, .smartphone:
            return Constants.defaultSimulatedCount
        }
    }

    private func showErrorAlert() {
        let alert = UIAlertController(
            title: "common.attention".localized,
            message: "simulate_permissions.alert.load_failed".localized,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "common.ok".localized, style: .default))
        present(alert, animated: true)
    }
}

extension SimulatePermissionsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        permissions.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: SimulatePermissionTableViewCell.reuseIdentifier,
            for: indexPath
        ) as? SimulatePermissionTableViewCell else {
            return UITableViewCell()
        }

        cell.configure(with: permissions[indexPath.row])
        return cell
    }
}
