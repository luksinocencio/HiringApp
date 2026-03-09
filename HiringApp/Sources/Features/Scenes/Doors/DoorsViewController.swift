import UIKit

final class DoorsViewController: UIViewController {
    // MARK: - Private Property(ies).
    private enum Constants {
        static let pageSize = 20
    }

    private let contentView: DoorsView
    private let service: AppServiceProtocol
    private weak var flowDelegate: DoorsFlowDelegate?
    private var doors: [DoorDTO] = []
    private var currentPage = 0
    private var hasMorePages = true
    private var isLoadingPage = false
    
    // MARK: - Private Init(s).
    init(contentView: DoorsView = DoorsView(), service: AppServiceProtocol = Service.shared, flowDelegate: DoorsFlowDelegate? = nil) {
        self.contentView = contentView
        self.service = service
        self.flowDelegate = flowDelegate
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle.
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        loadFirstPage()
    }
    
    // MARK: - Private Function(s).
    private func setup() {
        view.backgroundColor = .systemBackground
        title = "Doors"

        view.addSubview(contentView)
        setupContentViewToBounds(contentView: contentView)

        contentView.tableView.dataSource = self
        contentView.tableView.delegate = self
        contentView.tableView.register(DoorTableViewCell.self, forCellReuseIdentifier: DoorTableViewCell.reuseIdentifier)
        contentView.tableView.separatorStyle = .none
        contentView.tableView.tableFooterView = UIView()
        contentView.tableView.estimatedRowHeight = 96
        contentView.tableView.rowHeight = UITableView.automaticDimension

        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "ellipsis.circle"),
            style: .plain,
            target: self,
            action: #selector(didTapOptions)
        )
    }

    private func loadFirstPage() {
        currentPage = 0
        hasMorePages = true
        loadPage(resetData: true)
    }

    private func loadNextPageIfNeeded(for indexPath: IndexPath) {
        guard indexPath.row >= doors.count - 5 else { return }
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
            let result = await service.getAllDoors(page: pageToLoad, size: Constants.pageSize)

            DispatchQueue.main.async { [weak self] in
                guard let self else { return }

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

    private func presentOptionsSheet() {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)

        actionSheet.addAction(UIAlertAction(title: "Pesquisar", style: .default) { [weak self] _ in
            guard let self else { return }
            let searchViewController = DoorSearchViewController(service: self.service)
            self.navigationController?.pushViewController(searchViewController, animated: true)
        })

        actionSheet.addAction(UIAlertAction(title: "Sair", style: .destructive) { [weak self] _ in
            self?.didTapLogout()
        })

        actionSheet.addAction(UIAlertAction(title: "Cancelar", style: .cancel))

        if let popover = actionSheet.popoverPresentationController {
            popover.barButtonItem = navigationItem.rightBarButtonItem
        }

        present(actionSheet, animated: true)
    }

    private func showErrorAlert() {
        let alert = UIAlertController(
            title: "Attention",
            message: "Failed to load doors.",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    // MARK: - Private Selector(s).

    @objc
    private func didTapOptions() {
        presentOptionsSheet()
    }

    @objc
    private func didTapLogout() {
        flowDelegate?.didTapLogout()
    }
}

// MARK: - Extension UITableViewDataSource.
extension DoorsViewController: UITableViewDataSource {
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
extension DoorsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let selectedDoor = doors[indexPath.row]
        let viewController = DoorDetailViewController(door: selectedDoor, service: service)
        navigationController?.pushViewController(viewController, animated: true)
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        loadNextPageIfNeeded(for: indexPath)
    }
}
