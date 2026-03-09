import UIKit

final class DoorDetailViewController: UIViewController {
    private enum Constants {
        static let pageSize = 20
    }

    private let contentView: DoorDetailView
    private let door: DoorDTO
    private let service: AppServiceProtocol

    private let emptyStateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.textColor = .secondaryLabel
        label.numberOfLines = 0
        label.text = "door_detail.empty".localized
        return label
    }()
    private lazy var emptyStateView: UIView = {
        let view = UIView(frame: .zero)
        view.addSubview(emptyStateLabel)

        NSLayoutConstraint.activate([
            emptyStateLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyStateLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            emptyStateLabel.leadingAnchor.constraint(greaterThanOrEqualTo: view.leadingAnchor, constant: 24),
            emptyStateLabel.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: -24)
        ])

        return view
    }()

    private var events: [DoorEvent] = []
    private var currentPage = 0
    private var hasMorePages = true
    private var isLoadingPage = false

    init(door: DoorDTO, service: AppServiceProtocol = Service.shared, contentView: DoorDetailView = DoorDetailView()) {
        self.door = door
        self.service = service
        self.contentView = contentView
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        loadFirstPage()
    }

    private func setup() {
        view.backgroundColor = .systemBackground
        title = door.name

        view.addSubview(contentView)
        setupContentViewToBounds(contentView: contentView)

        contentView.tableView.dataSource = self
        contentView.tableView.delegate = self
        contentView.tableView.register(DoorDetailEventTableViewCell.self, forCellReuseIdentifier: DoorDetailEventTableViewCell.reuseIdentifier)
        contentView.tableView.separatorStyle = .none
        contentView.tableView.tableFooterView = UIView()
        contentView.tableView.estimatedRowHeight = 140
        contentView.tableView.rowHeight = UITableView.automaticDimension
    }

    private func loadFirstPage() {
        currentPage = 0
        hasMorePages = true
        loadPage(resetData: true)
    }

    private func loadNextPageIfNeeded(for indexPath: IndexPath) {
        guard indexPath.row >= events.count - 5 else { return }
        loadPage(resetData: false)
    }

    private func loadPage(resetData: Bool) {
        guard !isLoadingPage else { return }
        guard hasMorePages || resetData else { return }

        isLoadingPage = true

        if resetData {
            contentView.loadingIndicator.startAnimating()
        }

        let pageToLoad = resetData ? 0 : currentPage + 1

        Task {
            let result = await service.listDoorEvents(doorId: door.id, page: pageToLoad, size: Constants.pageSize)

            DispatchQueue.main.async { [weak self] in
                guard let self else { return }

                switch result {
                case let .success(response):
                    if resetData {
                        self.events = response.content
                    } else {
                        self.events.append(contentsOf: response.content)
                    }

                    self.currentPage = response.page ?? pageToLoad
                    self.hasMorePages = !(response.last ?? true)
                    self.contentView.tableView.reloadData()
                    self.updateEmptyState(isEmpty: self.events.isEmpty)
                    self.contentView.loadingIndicator.stopAnimating()
                    self.isLoadingPage = false

                case .failure:
                    self.contentView.loadingIndicator.stopAnimating()
                    self.updateEmptyState(isEmpty: false)
                    self.isLoadingPage = false
                    self.showErrorAlert()
                }
            }
        }
    }

    private func showErrorAlert() {
        let alert = UIAlertController(
            title: "common.attention".localized,
            message: "door_detail.alert.load_failed".localized,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "common.ok".localized, style: .default))
        present(alert, animated: true)
    }

    private func updateEmptyState(isEmpty: Bool) {
        contentView.tableView.backgroundView = isEmpty ? emptyStateView : nil
    }
}

extension DoorDetailViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        events.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: DoorDetailEventTableViewCell.reuseIdentifier,
            for: indexPath
        ) as? DoorDetailEventTableViewCell else {
            return UITableViewCell()
        }

        cell.configure(with: events[indexPath.row])
        return cell
    }
}

extension DoorDetailViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        loadNextPageIfNeeded(for: indexPath)
    }
}
