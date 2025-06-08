import SwiftUI
import GoogleMobileAds

// MARK: - Rewarded Ad View for Photo Generation
struct RewardedAdView: View {
    @StateObject private var adMobManager = AdMobManager.shared
    @StateObject private var settingsManager = UserSettingsManager.shared
    @Binding var isPresented: Bool
    let onRewardEarned: () -> Void
    let onDismissed: () -> Void
    
    var body: some View {
        ZStack {
            // Semi-transparent background
            Color.black.opacity(0.6)
                .ignoresSafeArea()
            
            VStack(spacing: 24) {
                // Header
                VStack(spacing: 8) {
                   
                    
                    Text("Watch & Earn")
                       // .font(.system(size: 22, weight: .bold, design: .rounded))
                        .font(.title)
                        .fontWeight(.bold)
                        .fontDesign(.rounded)
                        .foregroundColor(.white)
                    
                    Text("Get a free generation!")
                        //.font(.system(size: 18, weight: .semibold))
                        .font(.callout)
                        .foregroundColor(.white)
                       
                }
                
                // Description
                VStack(spacing: 12) {
                   
                    
                    Text("To make the generation free, watch this short ad and get one generation credit.")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.white.opacity(0.8))
                        .multilineTextAlignment(.center)
                        .lineLimit(3)
                }.padding(.top)
                
                // Benefits
                VStack(spacing: 8) {
                    HStack(spacing: 12) {
                        Image(systemName: "gift.fill")
                            .foregroundColor(.green)
                        Text("Earn 1 free generation credit")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.white.opacity(0.9))
                        Spacer()
                    }
                    
                    HStack(spacing: 12) {
                        Image(systemName: "sparkles")
                            .foregroundColor(.cyan)
                        Text("Transform your photo for free")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.white.opacity(0.9))
                        Spacer()
                    }
                    
                    HStack(spacing: 12) {
                        Image(systemName: "heart.fill")
                            .foregroundColor(.pink)
                        Text("Support the app development")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.white.opacity(0.9))
                        Spacer()
                    }
                }
                .padding(.horizontal, 20)
                
                // Action buttons
                VStack(spacing: 12) {
                    // Watch Ad button
                    Button(action: showRewardedAd) {
                        HStack(spacing: 12) {
                            Image(systemName: "play.circle.fill")
                                .font(.system(size: 18, weight: .semibold))
                            Text("Watch Ad for Free Credit")
                                .font(.system(size: 16, weight: .semibold))
                        }
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(
                            LinearGradient(
                                colors: adMobManager.isRewardedAdLoaded ? 
                                    [.orange, .red] : [.gray.opacity(0.6), .gray.opacity(0.4)],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .cornerRadius(16)
                        .shadow(
                            color: adMobManager.isRewardedAdLoaded ? .orange.opacity(0.3) : .clear, 
                            radius: 8, x: 0, y: 4
                        )
                    }
                    .disabled(!adMobManager.isRewardedAdLoaded || !settingsManager.shouldShowAds())
                }
                .padding(.horizontal, 20)
                
                if !adMobManager.isRewardedAdLoaded {
                    HStack(spacing: 8) {
                        ProgressView()
                            .scaleEffect(0.8)
                        Text("Loading ad...")
                            .font(.caption)
                            .foregroundColor(.white.opacity(0.6))
                    }
                    .padding(.top, 8)
                }
            }
            .padding(32)
            .background(
                RoundedRectangle(cornerRadius: 24, style: .continuous)
                    .fill(.ultraThinMaterial)
                    .overlay(
                        RoundedRectangle(cornerRadius: 24, style: .continuous)
                            .stroke(
                                LinearGradient(
                                    colors: [.white.opacity(0.2), .clear],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ),
                                lineWidth: 1
                            )
                    )
            )
            .shadow(color: .black.opacity(0.3), radius: 20, x: 0, y: 10)
            .padding(.horizontal, 24)
        }
        .transition(.opacity.combined(with: .scale(scale: 0.9)))
        .onAppear {
            if !adMobManager.isRewardedAdLoaded {
                adMobManager.loadRewardedAd()
            }
        }
    }
    
    private func showRewardedAd() {
        guard let rootViewController = adMobManager.getCurrentRootViewController() else {
            print("🚫 Could not get root view controller for rewarded ad")
            return
        }
        
        adMobManager.showRewardedAd(from: rootViewController) { success in
            DispatchQueue.main.async {
                if success {
                    onRewardEarned()
                } else {
                    onDismissed()
                }
                isPresented = false
            }
        }
    }
}

// MARK: - Reward Processing Banner
struct RewardProcessingBanner: View {
    let isVisible: Bool
    
    var body: some View {
        if isVisible {
            HStack(spacing: 12) {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundColor(.green)
                    .font(.system(size: 16, weight: .semibold))
                
                VStack(alignment: .leading, spacing: 2) {
                    Text("🎯 Free Generation Active")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.white)
                    
                    Text("Thanks for watching the ad!")
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.7))
                }
                
                Spacer()
                
                // Animated coins
                HStack(spacing: 4) {
                    ForEach(0..<3, id: \.self) { index in
                        Image(systemName: "dollarsign.circle.fill")
                            .foregroundColor(.yellow)
                            .font(.caption)
                            .opacity(0.8)
                            .scaleEffect(0.8)
                            .animation(
                                .easeInOut(duration: 1.0)
                                .repeatForever(autoreverses: true)
                                .delay(Double(index) * 0.2),
                                value: isVisible
                            )
                    }
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .fill(
                        LinearGradient(
                            colors: [.green.opacity(0.2), .blue.opacity(0.1)],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 12, style: .continuous)
                            .stroke(
                                LinearGradient(
                                    colors: [.green.opacity(0.3), .blue.opacity(0.2)],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                ),
                                lineWidth: 1
                            )
                    )
            )
            .shadow(color: .green.opacity(0.2), radius: 8, x: 0, y: 4)
            .transition(.opacity.combined(with: .scale(scale: 0.9)))
        }
    }
}

// MARK: - Preview
struct RewardedAdView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            RewardedAdView(
                isPresented: .constant(true),
                onRewardEarned: {
                    print("Preview: Reward earned")
                },
                onDismissed: {
                    print("Preview: Dismissed")
                }
            )
        }
        .preferredColorScheme(.dark)
    }
} 
