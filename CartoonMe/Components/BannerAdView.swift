import SwiftUI
import GoogleMobileAds
import UIKit

// MARK: - Banner Ad View (Now Using Native Advanced)
struct BannerAdView: View {
    var body: some View {
        NativeAdvancedAdView()
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

// MARK: - Elegant Banner Ad Container (Now Native Advanced)
struct ElegantBannerAd: View {
    var body: some View {
        ElegantNativeAdvancedAd()
    }
}
