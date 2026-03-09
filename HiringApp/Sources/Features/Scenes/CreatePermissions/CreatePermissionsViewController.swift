import UIKit

final class CreatePermissionsViewController: UIViewController {
    // MARK: - Private Property(ies).
    private let doorId: Int
    private let contentView: CreatePermissionsView
    private let service: AppServiceProtocol
    private let onCreated: (() -> Void)?

    // MARK: - Init(s).
    @MainActor
    init(
        doorId: Int,
        contentView: CreatePermissionsView? = nil,
        service: AppServiceProtocol? = nil,
        onCreated: (() -> Void)? = nil
    ) {
        self.doorId = doorId
        self.contentView = contentView ?? CreatePermissionsView()
        self.service = service ?? Service.shared
        self.onCreated = onCreated
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle.
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }

    // MARK: - Private Function(s).
    private func setup() {
        title = "create_permissions.title".localized
        view.backgroundColor = .systemBackground

        view.addSubview(contentView)
        setupContentViewToBounds(contentView: contentView)

        if let defaultTypeIndex = SimulatedPermissionType.allCases.firstIndex(of: .smartphone) {
            contentView.typeSegmentedControl.selectedSegmentIndex = defaultTypeIndex
        }
        contentView.startDatePicker.date = Date()
        contentView.endDatePicker.date = Date().addingTimeInterval(86_400)

        contentView.createButton.addTarget(self, action: #selector(createPermission), for: .touchUpInside)
    }

    // MARK: - Private Selector(s).
    @objc
    private func createPermission() {
        guard
            SimulatedPermissionType.allCases.indices.contains(contentView.typeSegmentedControl.selectedSegmentIndex),
            let value = contentView.valueTextField.text?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines),
            let weekDaysText = contentView.weekDaysTextField.text?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines),
            let weekDays = Int(weekDaysText),
            !value.isEmpty,
            doorId > 0,
            contentView.endDatePicker.date >= contentView.startDatePicker.date
        else {
            showAlert(title: "common.attention".localized, message: "create_permissions.alert.invalid_fields".localized)
            return
        }

        let selectedType = SimulatedPermissionType.allCases[contentView.typeSegmentedControl.selectedSegmentIndex]
        let startDateTime = Self.iso8601UTCFormatter.string(from: contentView.startDatePicker.date)
        let endDateTime = Self.iso8601UTCFormatter.string(from: contentView.endDatePicker.date)

        let request = CreatePermissionRequest(
            type: selectedType.rawValue,
            value: value,
            startDateTime: startDateTime,
            endDateTime: endDateTime,
            weekDays: weekDays
        )

        contentView.createButton.isEnabled = false

        Task {
            let result = await service.createPermission(doorId: doorId, request: request)

            DispatchQueue.main.async { [weak self] in
                guard let self else { return }
                self.contentView.createButton.isEnabled = true

                switch result {
                case .success:
                    self.showAlert(title: "common.success".localized, message: "create_permissions.alert.success_message".localized) { [weak self] in
                        self?.onCreated?()
                        self?.navigationController?.popViewController(animated: true)
                    }
                case .failure:
                    self.showAlert(title: "common.error".localized, message: "create_permissions.alert.error_message".localized)
                }
            }
        }
    }

    private func showAlert(title: String, message: String, onConfirm: (() -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "common.ok".localized, style: .default) { _ in
            onConfirm?()
        })
        present(alert, animated: true)
    }

    private static let iso8601UTCFormatter: ISO8601DateFormatter = {
        let formatter = ISO8601DateFormatter()
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.formatOptions = [.withInternetDateTime]
        return formatter
    }()
}
