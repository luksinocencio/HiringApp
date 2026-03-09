import UIKit

final class DoorSearchViewController: UIViewController {
    // MARK: - Private Enum(s).
    private enum Constants {
        static let pageSize = 20
        static let searchDebounceNanoseconds: UInt64 = 350_000_000
    }

    // MARK: - Private Property(ies).
    private let contentView: DoorSearchView

    private var doors: [DoorDTO] = []
    private var currentQuery = ""
    private var currentPage = 0
    private var hasMorePages = true
    private var isLoadingPage = false
    private var debounceSearchTask: Task<Void, Never>?

    // MARK: - Init(s).
    init(contentView: DoorSearchView = DoorSearchView()) {
        self.contentView = contentView
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
        debounceSearchTask?.cancel()
    }

    // MARK: - Lifecycle.
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }

    // MARK: - Private Function(s).
    private func setup() {
        view.backgroundColor = .systemBackground
        title = "Pesquisar Doors"

        view.addSubview(contentView)
        setupContentViewToBounds(contentView: contentView)

        contentView.searchBar.delegate = self
        contentView.tableView.dataSource = self
        contentView.tableView.delegate = self
        contentView.tableView.register(DoorTableViewCell.self, forCellReuseIdentifier: DoorTableViewCell.reuseIdentifier)
        contentView.tableView.separatorStyle = .none
        contentView.tableView.tableFooterView = UIView()
        contentView.tableView.estimatedRowHeight = 96
        contentView.tableView.rowHeight = UITableView.automaticDimension
    }

    private func scheduleSearch(with query: String) {
        debounceSearchTask?.cancel()

        let trimmedQuery = query.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedQuery.isEmpty else {
            currentQuery = ""
            doors = []
            hasMorePages = false
            currentPage = 0
            isLoadingPage = false
            contentView.loadingIndicator.stopAnimating()
            contentView.tableView.reloadData()
            return
        }

        debounceSearchTask = Task { [weak self] in
            do {
                try await Task.sleep(nanoseconds: Constants.searchDebounceNanoseconds)
                guard !Task.isCancelled else { return }
                await MainActor.run {
                    self?.startSearch(with: trimmedQuery)
                }
            } catch {
                return
            }
        }
    }

    private func startSearch(with query: String) {
        currentQuery = query
        currentPage = 0
        hasMorePages = true
        loadPage(resetData: true)
    }

    private func loadNextPageIfNeeded(for indexPath: IndexPath) {
        guard indexPath.row >= doors.count - 5 else { return }
        loadPage(resetData: false)
    }

    private func loadPage(resetData: Bool) {
        guard !currentQuery.isEmpty else { return }
        guard !isLoadingPage else { return }
        guard hasMorePages || resetData else { return }

        isLoadingPage = true

        if resetData {
            contentView.loadingIndicator.startAnimating()
        }

        let pageToLoad = resetData ? 0 : currentPage + 1
        let requestQuery = currentQuery

        Task {
            let result = await Service.shared.listDoorByName(name: currentQuery, page: pageToLoad, size: Constants.pageSize)

            DispatchQueue.main.async { [weak self] in
                guard let self else { return }

                // Ignore outdated results from previous query values.
                guard requestQuery == self.currentQuery else {
                    self.isLoadingPage = false
                    return
                }

                switch result {
                case let .success(response):
                    if resetData {
                        self.doors = response.content
                    } else {
                        self.doors.append(contentsOf: response.content)
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
            message: "Failed to search doors.",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

// MARK: - Extension UISearchBarDelegate.
extension DoorSearchViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        scheduleSearch(with: searchText)
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        scheduleSearch(with: searchBar.text ?? "")
    }
}

// MARK: - Extension UITableViewDataSource.
extension DoorSearchViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        doors.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: DoorTableViewCell.reuseIdentifier,
            for: indexPath
        ) as? DoorTableViewCell else {
            return UITableViewCell()
        }

        cell.configure(with: doors[indexPath.row])
        return cell
    }
}

// MARK: - Extension UITableViewDelegate.
extension DoorSearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let selectedDoor = doors[indexPath.row]
        let viewController = DoorDetailViewController(door: selectedDoor)
        navigationController?.pushViewController(viewController, animated: true)
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        loadNextPageIfNeeded(for: indexPath)
    }
}
