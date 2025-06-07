import SwiftUI
import GoogleMobileAds
import UIKit

// MARK: - Banner Ad View (Working Implementation)
struct BannerAdView: View {
    var body: some View {
        AdBannerView()
            .frame(width: 320, height: 50)
    }
}

// MARK: - Working UIViewRepresentable
struct AdBannerView: UIViewRepresentable {
    typealias UIViewType = GoogleMobileAds.BannerView
    func makeUIView(context: Context) -> GoogleMobileAds.BannerView {
        let banner = GoogleMobileAds.BannerView(adSize: GoogleMobileAds.AdSizeBanner)
        banner.adUnitID = AdMobManager.shared.bannerAdUnitID
        
        // Set root view controller
        DispatchQueue.main.async {
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
               let rootViewController = windowScene.windows.first?.rootViewController {
                banner.rootViewController = rootViewController
            }
            banner.load(GoogleMobileAds.Request())
        }
        
        return banner
    }
    
    func updateUIView(_ uiView: GoogleMobileAds.BannerView, context: Context) {}
}

// MARK: - Elegant Banner Ad Container
struct ElegantBannerAd: View {
    @StateObject private var adMobManager = AdMobManager.shared
    @StateObject private var settingsManager = UserSettingsManager.shared
    @State private var isVisible = false

    var body: some View {
        VStack {
            if isVisible && settingsManager.shouldShowAds() {
                BannerAdView()
                    .transition(.opacity.combined(with: .scale(scale: 0.95)))
            }
        }
        .animation(.easeInOut(duration: 0.5), value: isVisible)
        .onChange(of: settingsManager.adsDisabled) { _, _ in
            // When ads are disabled, hide immediately
            if settingsManager.adsDisabled {
                isVisible = false
            } else if adMobManager.isInitialized {
                // When ads are re-enabled, show with delay
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    self.isVisible = true
                }
            }
        }
        .onAppear {
            // Only show ads if they're not disabled
            if settingsManager.shouldShowAds() && adMobManager.isInitialized {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    self.isVisible = true
                }
            }
        }
    }
}
