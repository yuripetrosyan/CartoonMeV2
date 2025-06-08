import Foundation
import SwiftUI
import GoogleMobileAds

// MARK: - AdMob Manager for Real Ad Integration
class AdMobManager: NSObject, ObservableObject, BannerViewDelegate, FullScreenContentDelegate, AdLoaderDelegate, NativeAdLoaderDelegate, NativeAdDelegate {
    static let shared = AdMobManager()
    
    let bannerAdUnitID: String
    let rewardedAdUnitID: String
    let nativeAdvancedAdUnitID: String
    @Published var isInitialized = false
    @Published var isBannerAdLoaded = false
    @Published var isRewardedAdLoaded = false
    @Published var isRewardedAdPresented = false
    @Published var isNativeAdLoaded = false
    private var bannerView: BannerView?
    private var rewardedAd: RewardedAd?
    private var nativeAd: NativeAd?
    private var adLoader: AdLoader?
    
    private override init() {
        self.bannerAdUnitID = "ca-app-pub-3940256099942544/2934735716" // Test ID
        self.rewardedAdUnitID = "ca-app-pub-3940256099942544/5224354917" // Test ID
        self.nativeAdvancedAdUnitID = "ca-app-pub-3940256099942544/3986624511" // Test ID
        super.init()
        MobileAds.shared.start(completionHandler: { [weak self] _ in
            print("🎯 AdMob initialized successfully - ready for real ads!")
            DispatchQueue.main.async {
                self?.isInitialized = true
                self?.loadBannerAd()
                self?.loadRewardedAd()
                self?.loadNativeAd()
            }
        })
    }
    
    func shouldShowAds() -> Bool {
        return UserSettingsManager.shared.shouldShowAds()
    }
    
    // MARK: - Banner Ad Methods
    func loadBannerAd() {
        guard shouldShowAds() else {
            print("🚫 Banner ad loading skipped - ads disabled")
            return
        }
        print("🎯 Loading banner ad with test ID: \(bannerAdUnitID)")
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.bannerView = BannerView(adSize: AdSizeBanner)
            self.bannerView?.adUnitID = self.bannerAdUnitID
            self.bannerView?.rootViewController = self.getCurrentRootViewController()
            self.bannerView?.delegate = self
            let request = Request()
            self.bannerView?.load(request)
        }
    }
    
    func getBannerView() -> BannerView? {
        return bannerView
    }
    
    // MARK: - Native Ad Methods
    func loadNativeAd() {
        guard shouldShowAds() else {
            print("🚫 Native ad loading skipped - ads disabled")
            return
        }
        print("🎯 Loading native ad with test ID: \(nativeAdvancedAdUnitID)")
        adLoader = AdLoader(adUnitID: nativeAdvancedAdUnitID,
                           rootViewController: getCurrentRootViewController(),
                           adTypes: [.native],
                           options: nil)
        adLoader?.delegate = self
        adLoader?.load(Request())
    }
    
    func reloadNativeAd() {
        isNativeAdLoaded = false
        nativeAd = nil
        loadNativeAd()
    }
    
    func getNativeAd() -> NativeAd? {
        return nativeAd
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
    
    // MARK: - BannerViewDelegate
    func bannerViewDidReceiveAd(_ bannerView: BannerView) {
        print("🎯 Banner ad loaded successfully")
        DispatchQueue.main.async {
            self.isBannerAdLoaded = true
        }
    }
    func bannerView(_ bannerView: BannerView, didFailToReceiveAdWithError error: Error) {
        print("🚫 Failed to load banner ad: \(error.localizedDescription)")
        DispatchQueue.main.async {
            self.isBannerAdLoaded = false
        }
    }
    
    // MARK: - NativeAdLoaderDelegate
    func adLoader(_ adLoader: AdLoader, didReceive nativeAd: NativeAd) {
        print("🎯 Native ad loaded successfully")
        DispatchQueue.main.async {
            self.nativeAd = nativeAd
            nativeAd.delegate = self
            self.isNativeAdLoaded = true
        }
    }
    func adLoader(_ adLoader: AdLoader, didFailToReceiveAdWithError error: Error) {
        print("🚫 Failed to load native ad: \(error.localizedDescription)")
        DispatchQueue.main.async {
            self.isNativeAdLoaded = false
        }
    }
    func adLoaderDidFinishLoading(_ adLoader: AdLoader) {
        print("🎯 Ad loader finished loading")
    }
    
    // MARK: - NativeAdDelegate
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
    
    // MARK: - FullScreenContentDelegate
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
