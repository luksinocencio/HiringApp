import UIKit

final class SettingsViewController: UIViewController {
    // MARK: - Private Property(ies).
    private let contentView: SettingsView

    // MARK: - Init(s).
    init(contentView: SettingsView = SettingsView()) {
        self.contentView = contentView
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle.
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        loadCurrentSettings()
    }

    // MARK: - Private Function(s).
    private func setup() {
        title = "settings.title".localized
        view.backgroundColor = .systemBackground

        view.addSubview(contentView)
        setupContentViewToBounds(contentView: contentView)

        contentView.saveButton.addTarget(self, action: #selector(saveSettings), for: .touchUpInside)
    }

    private func loadCurrentSettings() {
        let currentLanguage = AppSettingsManager.shared.currentLanguage()
        let currentTheme = AppSettingsManager.shared.currentTheme()

        if let languageIndex = AppLanguage.allCases.firstIndex(of: currentLanguage) {
            contentView.languageSegmentedControl.selectedSegmentIndex = languageIndex
        }

        if let themeIndex = AppTheme.allCases.firstIndex(of: currentTheme) {
            contentView.themeSegmentedControl.selectedSegmentIndex = themeIndex
        }
    }

    private func applyThemeToCurrentWindow(_ theme: AppTheme) {
        guard let windowScene = view.window?.windowScene else { return }
        let window = windowScene.windows.first
        window?.overrideUserInterfaceStyle = theme.interfaceStyle
    }

    private func reloadAppRoot() {
        guard
            let windowScene = view.window?.windowScene,
            let sceneDelegate = windowScene.delegate as? SceneDelegate
        else {
            return
        }

        sceneDelegate.reloadRootController()
    }

    private func showSuccessAlert(reloadAfterDismiss: Bool) {
        let alert = UIAlertController(
            title: "common.success".localized,
            message: "settings.alert.saved".localized,
            preferredStyle: .alert
        )

        alert.addAction(UIAlertAction(title: "common.ok".localized, style: .default) { [weak self] _ in
            guard let self else { return }
            if reloadAfterDismiss {
                self.reloadAppRoot()
            }
        })

        present(alert, animated: true)
    }

    // MARK: - Private Selector(s).
    @objc
    private func saveSettings() {
        let selectedLanguageIndex = contentView.languageSegmentedControl.selectedSegmentIndex
        let selectedThemeIndex = contentView.themeSegmentedControl.selectedSegmentIndex

        guard
            AppLanguage.allCases.indices.contains(selectedLanguageIndex),
            AppTheme.allCases.indices.contains(selectedThemeIndex)
        else {
            return
        }

        let selectedLanguage = AppLanguage.allCases[selectedLanguageIndex]
        let selectedTheme = AppTheme.allCases[selectedThemeIndex]

        let previousLanguage = AppSettingsManager.shared.currentLanguage()

        _ = AppSettingsManager.shared.saveTheme(selectedTheme)
        applyThemeToCurrentWindow(selectedTheme)
        _ = AppSettingsManager.shared.saveLanguage(selectedLanguage)

        let shouldReload = previousLanguage != selectedLanguage
        showSuccessAlert(reloadAfterDismiss: shouldReload)
    }
}
