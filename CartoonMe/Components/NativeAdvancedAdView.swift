import SwiftUI
import GoogleMobileAds

// MARK: - Native Advanced Ad View
struct NativeAdvancedAdView: View {
    @StateObject private var adMobManager = AdMobManager.shared
    @StateObject private var settingsManager = UserSettingsManager.shared
    @State private var isVisible = false
    
    var body: some View {
        VStack {
            if isVisible && settingsManager.shouldShowAds() && adMobManager.isNativeAdLoaded {
                NativeAdViewWrapper()
                    .frame(height: 120)
                    .transition(.opacity.combined(with: .scale(scale: 0.95)))
            }
        }
        .onAppear {
            print("🎯 NativeAdvancedAdView appeared")
            print("🎯 Settings allow ads: \(settingsManager.shouldShowAds())")
            print("🎯 AdMob initialized: \(adMobManager.isInitialized)")
            print("🎯 Native ad loaded: \(adMobManager.isNativeAdLoaded)")
        }
        .animation(.easeInOut(duration: 0.5), value: isVisible)
        .onChange(of: settingsManager.adsDisabled) { _, _ in
            if settingsManager.adsDisabled {
                isVisible = false
            } else if adMobManager.isNativeAdLoaded {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    self.isVisible = true
                }
            }
        }
        .onChange(of: adMobManager.isNativeAdLoaded) { _, newValue in
            if newValue && settingsManager.shouldShowAds() {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    self.isVisible = true
                }
            }
        }
        .onAppear {
            if settingsManager.shouldShowAds() && adMobManager.isNativeAdLoaded {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    self.isVisible = true
                }
            } else if settingsManager.shouldShowAds() && adMobManager.isInitialized {
                // Try to reload native ad if not loaded but AdMob is ready
                print("🎯 Attempting to reload native ad...")
                adMobManager.reloadNativeAd()
            }
        }
    }
}

// MARK: - Native Ad UIViewRepresentable Wrapper
struct NativeAdViewWrapper: UIViewRepresentable {
    typealias UIViewType = NativeAdView
    
    func makeUIView(context: Context) -> NativeAdView {
        print("🎯 Creating NativeAdView...")
        let nativeAdView = createNativeAdView()
        
        if let nativeAd = AdMobManager.shared.getNativeAd() {
            print("🎯 Found native ad, populating view...")
            populateNativeAdView(nativeAdView, with: nativeAd)
        } else {
            print("🚫 No native ad available to display")
        }
        
        return nativeAdView
    }
    
    func updateUIView(_ uiView: NativeAdView, context: Context) {
        // Update the view when a new native ad becomes available
        if let nativeAd = AdMobManager.shared.getNativeAd(), uiView.nativeAd == nil {
            print("🎯 Updating view with newly loaded native ad")
            populateNativeAdView(uiView, with: nativeAd)
        }
    }
    
    private func createNativeAdView() -> NativeAdView {
        let nativeAdView = NativeAdView()
        
        // Create the container
        let containerView = UIView()
        containerView.backgroundColor = UIColor.systemBackground.withAlphaComponent(0.1)
        containerView.layer.cornerRadius = 16
        containerView.layer.borderWidth = 1
        containerView.layer.borderColor = UIColor.white.withAlphaComponent(0.1).cgColor
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        // Create elements
        let iconImageView = UIImageView()
        iconImageView.contentMode = .scaleAspectFit
        iconImageView.layer.cornerRadius = 8
        iconImageView.clipsToBounds = true
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        
        let headlineLabel = UILabel()
        headlineLabel.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        headlineLabel.textColor = .white
        headlineLabel.numberOfLines = 2
        headlineLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let bodyLabel = UILabel()
        bodyLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        bodyLabel.textColor = UIColor.white.withAlphaComponent(0.8)
        bodyLabel.numberOfLines = 2
        bodyLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let callToActionButton = UIButton(type: .system)
        callToActionButton.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        callToActionButton.setTitleColor(.white, for: .normal)
        callToActionButton.backgroundColor = UIColor.systemBlue
        callToActionButton.layer.cornerRadius = 8
        callToActionButton.translatesAutoresizingMaskIntoConstraints = false
        
        let adLabel = UILabel()
        adLabel.text = "Ad"
        adLabel.font = UIFont.systemFont(ofSize: 10, weight: .medium)
        adLabel.textColor = UIColor.white.withAlphaComponent(0.6)
        adLabel.backgroundColor = UIColor.white.withAlphaComponent(0.1)
        adLabel.textAlignment = .center
        adLabel.layer.cornerRadius = 4
        adLabel.clipsToBounds = true
        adLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // Add to container
        containerView.addSubview(iconImageView)
        containerView.addSubview(headlineLabel)
        containerView.addSubview(bodyLabel)
        containerView.addSubview(callToActionButton)
        containerView.addSubview(adLabel)
        
        nativeAdView.addSubview(containerView)
        
        // Set up constraints
        NSLayoutConstraint.activate([
            // Container
            containerView.topAnchor.constraint(equalTo: nativeAdView.topAnchor),
            containerView.leadingAnchor.constraint(equalTo: nativeAdView.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: nativeAdView.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: nativeAdView.bottomAnchor),
            
            // Icon
            iconImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            iconImageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            iconImageView.widthAnchor.constraint(equalToConstant: 50),
            iconImageView.heightAnchor.constraint(equalToConstant: 50),
            
            // Headline
            headlineLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 16),
            headlineLabel.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 12),
            headlineLabel.trailingAnchor.constraint(equalTo: callToActionButton.leadingAnchor, constant: -12),
            
            // Body
            bodyLabel.topAnchor.constraint(equalTo: headlineLabel.bottomAnchor, constant: 4),
            bodyLabel.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 12),
            bodyLabel.trailingAnchor.constraint(equalTo: callToActionButton.leadingAnchor, constant: -12),
            
            // Call to Action Button
            callToActionButton.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            callToActionButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            callToActionButton.widthAnchor.constraint(equalToConstant: 80),
            callToActionButton.heightAnchor.constraint(equalToConstant: 32),
            
            // Ad Label
            adLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 8),
            adLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -8),
            adLabel.widthAnchor.constraint(equalToConstant: 24),
            adLabel.heightAnchor.constraint(equalToConstant: 16),
        ])
        
        // Map views to native ad view
        nativeAdView.iconView = iconImageView
        nativeAdView.headlineView = headlineLabel
        nativeAdView.bodyView = bodyLabel
        nativeAdView.callToActionView = callToActionButton
        
        return nativeAdView
    }
    
    private func populateNativeAdView(_ nativeAdView: NativeAdView, with nativeAd: NativeAd) {
        nativeAdView.nativeAd = nativeAd
        
        // Populate icon
        if let iconView = nativeAdView.iconView as? UIImageView {
            iconView.image = nativeAd.icon?.image
        }
        
        // Populate headline
        if let headlineView = nativeAdView.headlineView as? UILabel {
            headlineView.text = nativeAd.headline
        }
        
        // Populate body
        if let bodyView = nativeAdView.bodyView as? UILabel {
            bodyView.text = nativeAd.body
        }
        
        // Populate call to action
        if let callToActionView = nativeAdView.callToActionView as? UIButton {
            callToActionView.setTitle(nativeAd.callToAction, for: .normal)
        }
    }
}

// MARK: - Elegant Native Ad Container
struct ElegantNativeAdvancedAd: View {
    @StateObject private var adMobManager = AdMobManager.shared
    
    var body: some View {
        VStack {
            NativeAdvancedAdView()
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 8)
        .onTapGesture(count: 2) {
            // Double tap to reload native ad for testing
            print("🎯 Double tap detected - reloading native ad")
            adMobManager.reloadNativeAd()
        }
    }
}

// MARK: - Preview
struct NativeAdvancedAdView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            VStack(spacing: 20) {
                Text("Native Advanced Ad Preview")
                    .foregroundColor(.white)
                    .font(.headline)
                
                ElegantNativeAdvancedAd()
                
                Spacer()
            }
        }
        .preferredColorScheme(.dark)
    }
} 