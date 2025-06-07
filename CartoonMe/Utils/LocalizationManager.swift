import Foundation
import SwiftUI

// MARK: - Localization Manager
class LocalizationManager: ObservableObject {
    static let shared = LocalizationManager()
    
    @Published var currentLanguageCode: String
    private var bundle: Bundle
    
    private init() {
        // Get saved language or default to system language
        let savedLanguageCode = UserDefaults.standard.string(forKey: "app_language") ?? Locale.current.language.languageCode?.identifier ?? "en"
        
        self.currentLanguageCode = savedLanguageCode
        
        // Set up the bundle for the current language
        if let path = Bundle.main.path(forResource: savedLanguageCode, ofType: "lproj"),
           let bundle = Bundle(path: path) {
            self.bundle = bundle
        } else {
            self.bundle = Bundle.main
        }
    }
    
    // MARK: - Public Methods
    func setLanguage(_ languageCode: String) {
        currentLanguageCode = languageCode
        
        // Save to UserDefaults
        UserDefaults.standard.set(languageCode, forKey: "app_language")
        
        // Update bundle
        if let path = Bundle.main.path(forResource: languageCode, ofType: "lproj"),
           let bundle = Bundle(path: path) {
            self.bundle = bundle
        } else {
            self.bundle = Bundle.main
        }
        
        // Notify observers
        objectWillChange.send()
    }
    
    func localizedString(for key: String, comment: String = "") -> String {
        return NSLocalizedString(key, bundle: bundle, comment: comment)
    }
}

// MARK: - String Extension for Easy Localization
extension String {
    var localized: String {
        return LocalizationManager.shared.localizedString(for: self)
    }
    
    func localized(with arguments: CVarArg...) -> String {
        return String(format: self.localized, arguments: arguments)
    }
}

// MARK: - SwiftUI Environment
struct LocalizationEnvironmentKey: EnvironmentKey {
    static let defaultValue = LocalizationManager.shared
}

extension EnvironmentValues {
    var localization: LocalizationManager {
        get { self[LocalizationEnvironmentKey.self] }
        set { self[LocalizationEnvironmentKey.self] = newValue }
    }
} 