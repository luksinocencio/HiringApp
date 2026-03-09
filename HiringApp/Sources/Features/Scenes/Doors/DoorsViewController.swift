import UIKit

final class DoorsViewController: UIViewController {
    private enum Constants {
        static let doorCellIdentifier = "DoorCell"
        static let pageSize = 20
    }

    private let contentView: DoorsView
    private weak var flowDelegate: DoorsFlowDelegate?
    private let service = HiringService.shared

    private var doors: [Door] = []
    private var currentPage = 0
    private var hasMorePages = true
    private var isLoadingPage = false

    init(contentView: DoorsView = DoorsView(), flowDelegate: DoorsFlowDelegate? = nil) {
        self.contentView = contentView
        self.flowDelegate = flowDelegate
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
        title = "Doors"

        view.addSubview(contentView)
        setupContentViewToBounds(contentView: contentView)

        contentView.tableView.dataSource = self
        contentView.tableView.delegate = self
        contentView.tableView.register(UITableViewCell.self, forCellReuseIdentifier: Constants.doorCellIdentifier)
        contentView.tableView.tableFooterView = UIView()

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
        let request = HiringRequest.doorsRequest(page: pageToLoad, size: Constants.pageSize)

        service.execute(request, expecting: Doors.self) { [weak self] result in
            DispatchQueue.main.async {
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
            let searchViewController = DoorSearchViewController()
            self?.navigationController?.pushViewController(searchViewController, animated: true)
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

    @objc
    private func didTapOptions() {
        presentOptionsSheet()
    }

    @objc
    private func didTapLogout() {
        flowDelegate?.didTapLogout()
    }
}

extension DoorsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        doors.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.doorCellIdentifier, for: indexPath)
        var content = cell.defaultContentConfiguration()
        content.text = doors[indexPath.row].name
        cell.contentConfiguration = content
        cell.accessoryType = .disclosureIndicator
        return cell
    }
}

extension DoorsViewController: UITableViewDelegate {
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
