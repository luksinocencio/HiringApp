import UIKit

final class CreatePermissionsViewController: UIViewController {
    private let contentView: CreatePermissionsView
    private let service: AppServiceProtocol
    private let onCreated: (() -> Void)?

    init(
        contentView: CreatePermissionsView = CreatePermissionsView(),
        service: AppServiceProtocol = Service.shared,
        onCreated: (() -> Void)? = nil
    ) {
        self.contentView = contentView
        self.service = service
        self.onCreated = onCreated
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }

    private func setup() {
        title = "Create Permission"
        view.backgroundColor = .systemBackground

        view.addSubview(contentView)
        setupContentViewToBounds(contentView: contentView)

        if let defaultTypeIndex = SimulatedPermissionType.allCases.firstIndex(of: .smartphone) {
            contentView.typeSegmentedControl.selectedSegmentIndex = defaultTypeIndex
        }

        contentView.createButton.addTarget(self, action: #selector(createPermission), for: .touchUpInside)
    }

    @objc
    private func createPermission() {
        guard
            SimulatedPermissionType.allCases.indices.contains(contentView.typeSegmentedControl.selectedSegmentIndex),
            let value = contentView.valueTextField.text?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines),
            let startDateTime = contentView.startDateTextField.text?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines),
            let endDateTime = contentView.endDateTextField.text?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines),
            let weekDaysText = contentView.weekDaysTextField.text?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines),
            let weekDays = Int(weekDaysText),
            !value.isEmpty,
            !startDateTime.isEmpty,
            !endDateTime.isEmpty
        else {
            showAlert(title: "Attention", message: "Please fill all fields with valid values.")
            return
        }

        let selectedType = SimulatedPermissionType.allCases[contentView.typeSegmentedControl.selectedSegmentIndex]

        let request = CreatePermissionRequest(
            type: selectedType.rawValue,
            value: value,
            startDateTime: startDateTime,
            endDateTime: endDateTime,
            weekDays: weekDays
        )

        contentView.createButton.isEnabled = false

        Task {
            let result = await service.createPermission(request: request)

            DispatchQueue.main.async { [weak self] in
                guard let self else { return }
                self.contentView.createButton.isEnabled = true

                switch result {
                case .success:
                    self.showAlert(title: "Success", message: "Permission created successfully.") { [weak self] in
                        self?.onCreated?()
                        self?.navigationController?.popViewController(animated: true)
                    }
                case .failure:
                    self.showAlert(title: "Error", message: "Failed to create permission.")
                }
            }
        }
    }

    private func showAlert(title: String, message: String, onConfirm: (() -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in
            onConfirm?()
        })
        present(alert, animated: true)
    }
}
