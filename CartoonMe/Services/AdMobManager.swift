import Foundation
import SwiftUI
import GoogleMobileAds

// MARK: - AdMob Manager for Real Ad Integration
class AdMobManager: NSObject, ObservableObject {
    static let shared = AdMobManager()
    
    // Your actual AdMob IDs
    let bannerAdUnitID: String
    let rewardedAdUnitID: String
    let nativeAdvancedAdUnitID: String
    
    @Published var isInitialized = false
    @Published var isRewardedAdLoaded = false
    @Published var isRewardedAdPresented = false
    @Published var isNativeAdLoaded = false
    
    private var rewardedAd: RewardedAd?
    private var nativeAd: NativeAd?
    
    private override init() {
        // Using Test IDs for All Ad Types
        self.bannerAdUnitID = "ca-app-pub-3940256099942544/2934735716" // Test ID
        self.rewardedAdUnitID = "ca-app-pub-3940256099942544/5224354917" // Test ID for Rewarded
        self.nativeAdvancedAdUnitID = "ca-app-pub-3940256099942544/3986624511" // Test ID for Native Advanced
        
        // Note: Using test IDs to avoid format mismatch errors
        
        super.init()
        
        // Initialize the Google Mobile Ads SDK
        MobileAds.shared.start(completionHandler: { [weak self] _ in
            print("🎯 AdMob initialized successfully - ready for real ads!")
            DispatchQueue.main.async {
                self?.isInitialized = true
                self?.loadRewardedAd()
                self?.loadNativeAd()
            }
        })
    }
    
    // Check if ads should be shown based on user settings
    func shouldShowAds() -> Bool {
        return UserSettingsManager.shared.shouldShowAds()
    }
    
    // MARK: - Rewarded Ad Methods
    func loadRewardedAd() {
        guard shouldShowAds() else { return }
        
        let request = Request()
        RewardedAd.load(with: rewardedAdUnitID, request: request) { [weak self] ad, error in
            DispatchQueue.main.async {
                if let error = error {
                    print("🚫 Failed to load rewarded ad: \(error.localizedDescription)")
                    self?.isRewardedAdLoaded = false
                } else {
                    print("🎯 Rewarded ad loaded successfully")
                    self?.rewardedAd = ad
                    self?.isRewardedAdLoaded = true
                    self?.rewardedAd?.fullScreenContentDelegate = self
                }
            }
        }
    }
    
    func showRewardedAd(from rootViewController: UIViewController, completion: @escaping (Bool) -> Void) {
        guard let rewardedAd = rewardedAd, shouldShowAds() else {
            completion(false)
            return
        }
        
        isRewardedAdPresented = true
        
        rewardedAd.present(from: rootViewController) { [weak self] in
            print("🎯 User earned reward from rewarded ad")
            DispatchQueue.main.async {
                self?.isRewardedAdPresented = false
                self?.loadRewardedAd() // Load next ad
                completion(true)
            }
        }
    }
    
    func getCurrentRootViewController() -> UIViewController? {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first else {
            return nil
        }
        return window.rootViewController
    }
    
    // MARK: - Native Ad Methods
    func loadNativeAd() {
        guard shouldShowAds() else { 
            print("🚫 Native ad loading skipped - ads disabled")
            return 
        }
        
        print("🎯 Loading native ad with test ID: \(nativeAdvancedAdUnitID)")
        
        let adLoader = AdLoader(adUnitID: nativeAdvancedAdUnitID,
                               rootViewController: getCurrentRootViewController(),
                               adTypes: [.native],
                               options: nil)
        adLoader.delegate = self
        adLoader.load(Request())
    }
    
    func reloadNativeAd() {
        isNativeAdLoaded = false
        nativeAd = nil
        loadNativeAd()
    }
    
    func getNativeAd() -> NativeAd? {
        return nativeAd
    }
}

// MARK: - FullScreenContentDelegate
extension AdMobManager: FullScreenContentDelegate {
    func adWillPresentFullScreenContent(_ ad: FullScreenPresentingAd) {
        print("🎯 Rewarded ad will present")
        isRewardedAdPresented = true
    }
    
    func adDidDismissFullScreenContent(_ ad: FullScreenPresentingAd) {
        print("🎯 Rewarded ad did dismiss")
        isRewardedAdPresented = false
        loadRewardedAd() // Load next ad
    }
    
    func ad(_ ad: FullScreenPresentingAd, didFailToPresentFullScreenContentWithError error: Error) {
        print("🚫 Rewarded ad failed to present: \(error.localizedDescription)")
        isRewardedAdPresented = false
        loadRewardedAd() // Try to load again
    }
}

// MARK: - AdLoaderDelegate & NativeAdLoaderDelegate
extension AdMobManager: AdLoaderDelegate, NativeAdLoaderDelegate {
    // MARK: NativeAdLoaderDelegate methods
    func adLoader(_ adLoader: AdLoader, didReceive nativeAd: NativeAd) {
        print("🎯 Native ad loaded successfully")
        DispatchQueue.main.async {
            self.nativeAd = nativeAd
            // Set delegate for native ad events as per documentation
            nativeAd.delegate = self
            self.isNativeAdLoaded = true
        }
    }
    
    // MARK: AdLoaderDelegate methods (required base protocol)
    func adLoader(_ adLoader: AdLoader, didFailToReceiveAdWithError error: Error) {
        print("🚫 Failed to load native ad: \(error.localizedDescription)")
        DispatchQueue.main.async {
            self.isNativeAdLoaded = false
        }
    }
    
    func adLoaderDidFinishLoading(_ adLoader: AdLoader) {
        print("🎯 Ad loader finished loading")
        // The adLoader has finished loading ads, and a new request can be sent
    }
}

// MARK: - NativeAdDelegate (for tracking native ad events)
extension AdMobManager: NativeAdDelegate {
    func nativeAdDidRecordImpression(_ nativeAd: NativeAd) {
        print("🎯 Native ad impression recorded")
    }
    
    func nativeAdDidRecordClick(_ nativeAd: NativeAd) {
        print("🎯 Native ad clicked")
    }
    
    func nativeAdWillPresentScreen(_ nativeAd: NativeAd) {
        print("🎯 Native ad will present screen")
    }
    
    func nativeAdDidDismissScreen(_ nativeAd: NativeAd) {
        print("🎯 Native ad did dismiss screen")
    }
    
    func nativeAdWillLeaveApplication(_ nativeAd: NativeAd) {
        print("🎯 Native ad will leave application")
    }
}
