import Foundation
import SwiftUI

// MARK: - Language Model
struct Language: Identifiable, Hashable {
    let id = UUID()
    let code: String
    let name: String
    let localizedName: String
    
    static let supportedLanguages: [Language] = [
        Language(code: "en", name: "English", localizedName: "English"),
        Language(code: "es", name: "Spanish", localizedName: "Español"),
        Language(code: "fr", name: "French", localizedName: "Français"),
        Language(code: "de", name: "German", localizedName: "Deutsch"),
        Language(code: "it", name: "Italian", localizedName: "Italiano"),
        Language(code: "pt", name: "Portuguese", localizedName: "Português"),
        Language(code: "ru", name: "Russian", localizedName: "Русский"),
        Language(code: "zh", name: "Chinese", localizedName: "中文"),
        Language(code: "ja", name: "Japanese", localizedName: "日本語"),
        Language(code: "ko", name: "Korean", localizedName: "한국어")
    ]
}

class UserSettingsManager: ObservableObject {
    static let shared = UserSettingsManager()
    
    private let userDefaults = UserDefaults.standard
    
    // Keys for UserDefaults
    private let adsDisabledKey = "ads_disabled"
    private let selectedLanguageKey = "app_language"
    
    @Published var adsDisabled: Bool {
        didSet {
            userDefaults.set(adsDisabled, forKey: adsDisabledKey)
        }
    }
    
    @Published var selectedLanguage: Language {
        didSet {
            userDefaults.set(selectedLanguage.code, forKey: selectedLanguageKey)
        }
    }
    
    private init() {
        // Load existing settings or set defaults
        self.adsDisabled = userDefaults.bool(forKey: adsDisabledKey)
        
        // Load saved language or default to system language
        let savedLanguageCode = userDefaults.string(forKey: selectedLanguageKey) ?? Locale.current.language.languageCode?.identifier ?? "en"
        self.selectedLanguage = Language.supportedLanguages.first { $0.code == savedLanguageCode } ?? Language.supportedLanguages[0]
    }
    
    // Helper method to check if ads should be shown
    func shouldShowAds() -> Bool {
        return !adsDisabled
    }
    
    // Method to disable all ads
    func disableAds() {
        adsDisabled = true
    }
    
    // Method to enable ads
    func enableAds() {
        adsDisabled = false
    }
    
    // Method to reset all settings
    func resetAllSettings() {
        adsDisabled = false
        selectedLanguage = Language.supportedLanguages[0] // English
    }
} 