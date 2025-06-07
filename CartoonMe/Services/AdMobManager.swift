import Foundation
import SwiftUI
import GoogleMobileAds

// MARK: - AdMob Manager for Real Ad Integration
class AdMobManager: ObservableObject {
    static let shared = AdMobManager()
    
    // Your actual AdMob IDs
    let bannerAdUnitID: String
    
    @Published var isInitialized = false
    
    private init() {
        // IMPORTANT: Your real Ad Unit ID for the banner ad placement
        self.bannerAdUnitID =  "ca-app-pub-3940256099942544/2934735716"
        //"ca-app-pub-9883347063099581/1805417510"
        
        // Initialize the Google Mobile Ads SDK
        MobileAds.shared.start(completionHandler: { [weak self] _ in
            print("🎯 AdMob initialized successfully - ready for real ads!")
            DispatchQueue.main.async {
                self?.isInitialized = true
            }
        })
    }
    
    // Check if ads should be shown based on user settings
    func shouldShowAds() -> Bool {
        return UserSettingsManager.shared.shouldShowAds()
    }
}
