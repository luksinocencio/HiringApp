import Foundation

extension String {
    // MARK: - Public Property(ies).
    var localized: String {
        let languageCode = AppSettingsManager.shared.currentLanguage().rawValue
        let bundle: Bundle

        if let path = Bundle.main.path(forResource: languageCode, ofType: "lproj"),
           let languageBundle = Bundle(path: path) {
            bundle = languageBundle
        } else {
            bundle = Bundle.main
        }

        return bundle.localizedString(forKey: self, value: self, table: nil)
    }
}
