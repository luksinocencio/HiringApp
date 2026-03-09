import UIKit

enum AppLanguage: String, CaseIterable {
    case english = "en"
    case portugueseBrazil = "pt-BR"

    var displayKey: String {
        switch self {
        case .english:
            return "settings.language.english"
        case .portugueseBrazil:
            return "settings.language.portuguese"
        }
    }
}

enum AppTheme: String, CaseIterable {
    case light
    case dark

    var displayKey: String {
        switch self {
        case .light:
            return "settings.theme.light"
        case .dark:
            return "settings.theme.dark"
        }
    }

    var interfaceStyle: UIUserInterfaceStyle {
        switch self {
        case .light:
            return .light
        case .dark:
            return .dark
        }
    }
}

final class AppSettingsManager {
    // MARK: - Private Enum(s).
    private enum Keys {
        static let language = "app.preferences.language"
        static let theme = "app.preferences.theme"
    }

    // MARK: - Property(ies).
    static let shared = AppSettingsManager()

    private let keychain = AppPreferencesKeychainManager.shared

    // MARK: - Init(s).
    private init() {}

    // MARK: - Function(s).
    func currentLanguage() -> AppLanguage {
        guard
            let rawValue = keychain.value(forKey: Keys.language),
            let language = AppLanguage(rawValue: rawValue)
        else {
            return .portugueseBrazil
        }

        return language
    }

    @discardableResult
    func saveLanguage(_ language: AppLanguage) -> Bool {
        keychain.save(value: language.rawValue, forKey: Keys.language)
    }

    func applySavedLanguage() {
        // Intentionally empty. Language is resolved dynamically by String.localized.
    }

    func currentTheme() -> AppTheme {
        guard
            let rawValue = keychain.value(forKey: Keys.theme),
            let theme = AppTheme(rawValue: rawValue)
        else {
            return .dark
        }

        return theme
    }

    @discardableResult
    func saveTheme(_ theme: AppTheme) -> Bool {
        keychain.save(value: theme.rawValue, forKey: Keys.theme)
    }

    func applySavedTheme(to window: UIWindow?) {
        window?.overrideUserInterfaceStyle = currentTheme().interfaceStyle
    }

}
