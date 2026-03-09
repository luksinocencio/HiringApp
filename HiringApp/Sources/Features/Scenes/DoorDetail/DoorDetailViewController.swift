import UIKit

final class DoorDetailViewController: UIViewController {
    private enum Constants {
        static let eventCellIdentifier = "DoorEventCell"
        static let pageSize = 20
    }

    private let contentView: DoorDetailView
    private let service = HiringService.shared
    private let door: Door

    private var events: [DoorEvent] = []
    private var currentPage = 0
    private var hasMorePages = true
    private var isLoadingPage = false

    init(door: Door, contentView: DoorDetailView = DoorDetailView()) {
        self.door = door
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
        contentView.tableView.register(UITableViewCell.self, forCellReuseIdentifier: Constants.eventCellIdentifier)
        contentView.tableView.tableFooterView = UIView()
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

        let request = HiringRequest.doorEventsRequest(
            doorID: door.id,
            page: pageToLoad,
            size: Constants.pageSize
        )

        service.execute(request, expecting: PaginatedResponse<DoorEvent>.self) { [weak self] result in
            DispatchQueue.main.async {
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
                    self.contentView.loadingIndicator.stopAnimating()
                    self.isLoadingPage = false

                case .failure:
                    self.contentView.loadingIndicator.stopAnimating()
                    self.isLoadingPage = false
                    self.showErrorAlert()
                }
            }
        }
    }

    private func showErrorAlert() {
        let alert = UIAlertController(
            title: "Attention",
            message: "Failed to load door events.",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

extension DoorDetailViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        events.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.eventCellIdentifier, for: indexPath)
        var content = cell.defaultContentConfiguration()
        let event = events[indexPath.row]
        content.text = event.titleText
        content.secondaryText = event.subtitleText
        cell.contentConfiguration = content
        cell.selectionStyle = .none
        return cell
    }
}

extension DoorDetailViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        loadNextPageIfNeeded(for: indexPath)
    }
}
