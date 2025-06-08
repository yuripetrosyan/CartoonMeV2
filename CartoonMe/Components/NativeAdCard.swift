import SwiftUI
import GoogleMobileAds
import FirebaseAnalytics

struct NativeAdCard: UIViewRepresentable {
    @ObservedObject var adMobManager = AdMobManager.shared
    
    func makeUIView(context: Context) -> NativeAdView {
        let nativeAdView = NativeAdView()
        nativeAdView.backgroundColor = .clear
        nativeAdView.layer.cornerRadius = 16
        nativeAdView.clipsToBounds = true
        
        // Add glassmorphic background
        let backgroundView = UIView()
        backgroundView.backgroundColor = .clear
        backgroundView.layer.cornerRadius = 16
        backgroundView.clipsToBounds = true
        
        // Add blur effect
        let blurEffect = UIBlurEffect(style: .systemUltraThinMaterialDark)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.frame = nativeAdView.bounds
        blurView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        backgroundView.addSubview(blurView)
        
        // Add gradient overlay
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [
            UIColor.white.withAlphaComponent(0.1).cgColor,
            UIColor.clear.cgColor
        ]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1.0)
        gradientLayer.frame = nativeAdView.bounds
        backgroundView.layer.addSublayer(gradientLayer)
        
        // Add border
        let borderLayer = CALayer()
        borderLayer.frame = nativeAdView.bounds
        borderLayer.cornerRadius = 16
        borderLayer.borderWidth = 1
        borderLayer.borderColor = UIColor.white.withAlphaComponent(0.15).cgColor
        backgroundView.layer.addSublayer(borderLayer)
        
        nativeAdView.insertSubview(backgroundView, at: 0)
        backgroundView.frame = nativeAdView.bounds
        backgroundView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        return nativeAdView
    }
    
    func updateUIView(_ nativeAdView: NativeAdView, context: Context) {
        guard let nativeAd = adMobManager.getNativeAd() else {
            // Show placeholder
            nativeAdView.subviews.forEach { $0.removeFromSuperview() }
            let placeholder = UIHostingController(rootView: NativeAdPlaceholderCard())
            placeholder.view.frame = nativeAdView.bounds
            placeholder.view.backgroundColor = .clear
            nativeAdView.addSubview(placeholder.view)
            return
        }
        
        // Remove previous content except background
        nativeAdView.subviews.dropFirst().forEach { $0.removeFromSuperview() }
        
        // Create content container
        let contentContainer = UIView()
        contentContainer.backgroundColor = .clear
        contentContainer.translatesAutoresizingMaskIntoConstraints = false
        nativeAdView.addSubview(contentContainer)
        
        // Headline
        let headlineLabel = UILabel()
        headlineLabel.text = nativeAd.headline
        headlineLabel.font = UIFont.boldSystemFont(ofSize: 18)
        headlineLabel.textColor = .white
        headlineLabel.numberOfLines = 2
        
        // Media
        let mediaView = MediaView()
        mediaView.mediaContent = nativeAd.mediaContent
        mediaView.layer.cornerRadius = 12
        mediaView.clipsToBounds = true
        mediaView.translatesAutoresizingMaskIntoConstraints = false
        // AdMob compliance: ensure at least 120x120 and fill width
        NSLayoutConstraint.activate([
            mediaView.heightAnchor.constraint(greaterThanOrEqualToConstant: 120),
            mediaView.widthAnchor.constraint(greaterThanOrEqualToConstant: 120),
            mediaView.heightAnchor.constraint(equalToConstant: 140)
        ])
        
        // Call to Action
        let ctaButton = UIButton(type: .system)
        ctaButton.setTitle(nativeAd.callToAction, for: .normal)
        ctaButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        ctaButton.backgroundColor = UIColor.systemBlue.withAlphaComponent(0.85)
        ctaButton.setTitleColor(.white, for: .normal)
        ctaButton.layer.cornerRadius = 10
        ctaButton.isUserInteractionEnabled = false // AdMob handles clicks
        
        // Icon
        let iconView = UIImageView()
        if let icon = nativeAd.icon?.image {
            iconView.image = icon
            iconView.contentMode = .scaleAspectFit
            iconView.layer.cornerRadius = 8
            iconView.clipsToBounds = true
            iconView.widthAnchor.constraint(equalToConstant: 48).isActive = true
            iconView.heightAnchor.constraint(equalToConstant: 48).isActive = true
        }
        
        // Stack layout: mediaView at top, then headline, then icon+cta
        let iconAndCTA = UIStackView(arrangedSubviews: [iconView, ctaButton])
        iconAndCTA.axis = .horizontal
        iconAndCTA.spacing = 8
        iconAndCTA.alignment = .center
        
        let stack = UIStackView(arrangedSubviews: [mediaView, headlineLabel, iconAndCTA])
        stack.axis = .vertical
        stack.spacing = 10
        stack.alignment = .fill
        stack.translatesAutoresizingMaskIntoConstraints = false
        contentContainer.addSubview(stack)
        
        NSLayoutConstraint.activate([
            contentContainer.leadingAnchor.constraint(equalTo: nativeAdView.leadingAnchor),
            contentContainer.trailingAnchor.constraint(equalTo: nativeAdView.trailingAnchor),
            contentContainer.topAnchor.constraint(equalTo: nativeAdView.topAnchor),
            contentContainer.bottomAnchor.constraint(equalTo: nativeAdView.bottomAnchor),
            
            stack.leadingAnchor.constraint(equalTo: contentContainer.leadingAnchor, constant: 8),
            stack.trailingAnchor.constraint(equalTo: contentContainer.trailingAnchor, constant: -8),
            stack.topAnchor.constraint(equalTo: contentContainer.topAnchor, constant: 8),
            stack.bottomAnchor.constraint(lessThanOrEqualTo: contentContainer.bottomAnchor, constant: -8),
        ])
        nativeAdView.heightAnchor.constraint(greaterThanOrEqualToConstant: 200).isActive = true;
        
        // Register asset views
        nativeAdView.mediaView = mediaView
        nativeAdView.headlineView = headlineLabel
        nativeAdView.iconView = iconView
        nativeAdView.callToActionView = ctaButton
        nativeAdView.nativeAd = nativeAd
        
        // Log ad impression
        Analytics.logEvent("ad_impression", parameters: [
            "ad_type": "native",
            "placement": "featured_collections"
        ])
    }
}

struct NativeAdPlaceholderCard: View {
    var body: some View {
        RoundedRectangle(cornerRadius: 16)
            .fill(.ultraThinMaterial)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(
                        LinearGradient(
                            colors: [.white.opacity(0.2), .clear],
                            startPoint: .top,
                            endPoint: .bottom
                        ),
                        lineWidth: 1
                    )
            )
            .frame(height: 230)
            .overlay(
                VStack(spacing: 16) {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                    Text("Loading Ad...")
                        .foregroundColor(.white.opacity(0.7))
                        .font(.callout)
                }
            )
            .padding(4)
    }
}

#Preview {
    NativeAdCard()
}
