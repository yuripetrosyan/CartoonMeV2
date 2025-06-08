import SwiftUI
import GoogleMobileAds

// MARK: - Banner Ad View (Now Using Native Advanced)
struct BannerAdView: UIViewRepresentable {
    func makeUIView(context: Context) -> BannerView {
        let bannerView = BannerView(adSize: AdSizeBanner)
        bannerView.adUnitID = AdMobManager.shared.bannerAdUnitID
        bannerView.rootViewController = UIApplication.shared.connectedScenes
            .compactMap { ($0 as? UIWindowScene)?.windows.first?.rootViewController }
            .first
        bannerView.load(Request())
        return bannerView
    }
    func updateUIView(_ uiView: BannerView, context: Context) {}
}

// MARK: - Elegant Banner Ad Container (Now Native Advanced)
struct ElegantBannerAd: View {
    var body: some View {
        BannerAdView()
            .frame(height: 60)
            .padding(.horizontal, 20)
            .padding(.vertical, 8)
    }
}
