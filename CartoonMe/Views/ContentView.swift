//
//  ContentView.swift
//  CartoonMe
//
//  Created by Yuri Petrosyan on 10/04/2025.
//

// ContentView.swift
import SwiftUI
import PhotosUI
import Photos
import FirebaseAnalytics

struct ContentView: View {
    let selectedTheme: Theme
    let selectedTrend: Trend?
    let selectedHeadshotStyle: HeadshotStyle?
    @State private var selectedImage: UIImage?
    @State private var processedImage: UIImage?
    @State private var progressImage: UIImage?
    @State private var progressValue: Float = 0
    @State private var showingImagePicker = false
    @State private var isProcessing = false
    private let imageProcessor = ImageProcessor.shared
    
    @State private var showError = false
    @State private var errorMessage = ""
    
    @State private var isImageExpanded = false
    @State private var showingShareSheet = false
    @State private var imageToShare: UIImage? = nil
    @State private var cancelProcessing: Bool = false
    @State private var testMode: Bool = false
    
    @State private var selectedImages: [UIImage] = []
    @State private var showHeadshotPhotoReminder = false
    
    // Rewarded Ad Integration
    @StateObject private var adMobManager = AdMobManager.shared
    @State private var showingRewardedAd = false
    @State private var hasWatchedRewardAd = false
    @State private var showRewardBanner = false
    
    // 🧪 AD INTEGRATION - COMMENTED OUT FOR LATER USE
    // @StateObject private var adManager = AdManager.shared
    // @State private var showingInterstitialAd = false
    // @State private var showingRewardedAdOption = false
    
    // Save to Photos states

    
    // Convenience initializer for theme-only navigation
    init(selectedTheme: Theme) {
        self.selectedTheme = selectedTheme
        self.selectedTrend = nil
        self.selectedHeadshotStyle = nil
    }
    
    // Initializer for trend navigation
    init(selectedTrend: Trend) {
        // Create a temporary theme from trend data
        self.selectedTheme = Theme(
            name: selectedTrend.name,
            color: selectedTrend.color,
            image: "",
            logo: nil
        )
        self.selectedTrend = selectedTrend
        self.selectedHeadshotStyle = nil
    }
    
    // Initializer for headshot style navigation
    init(selectedHeadshotStyle: HeadshotStyle) {
        // Create a temporary theme from headshot style data
        self.selectedTheme = Theme(
            name: selectedHeadshotStyle.rawValue,
            color: selectedHeadshotStyle.color,
            image: "",
            logo: nil
        )
        self.selectedTrend = nil
        self.selectedHeadshotStyle = selectedHeadshotStyle
    }
    
    var body: some View {
        ZStack {
            // Transparent background
            Color.clear
                .ignoresSafeArea()
            
            // Ambient background effects (keeping these for visual interest)
            Circle()
                .fill(selectedTheme.color.opacity(0.05))
                .frame(width: 300, height: 300)
                .offset(x: -150, y: -200)
                .blur(radius: 60)
            
            Circle()
                .fill(selectedTheme.color.opacity(0.03))
                .frame(width: 400, height: 400)
                .offset(x: 200, y: 300)
                .blur(radius: 80)
            
            // Enlarged image view - shows directly in the main view
            if isImageExpanded, let imageToShow = processedImage {
                ZStack {
                    Color.black.opacity(0.95).edgesIgnoringSafeArea(.all)
                    
                    Image(uiImage: imageToShow)
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .padding()
                        
                    // Close button
                    VStack {
                        HStack {
                            Spacer()
                            Button(action: {
                                withAnimation(.easeInOut(duration: 0.2)) {
                                    self.isImageExpanded = false
                                }
                            }) {
                                ZStack {
                                    Circle()
                                        .fill(.ultraThinMaterial)
                                        .frame(width: 44, height: 44)
                                    
                                    Image(systemName: "xmark")
                                        .font(.system(size: 18, weight: .semibold))
                                        .foregroundColor(.white)
                                }
                                .padding()
                            }
                        }
                        Spacer()
                        
                        // Share button at bottom
                        Button(action: { 
                            self.imageToShare = processedImage
                            self.showingShareSheet = true
                        }) {
                            HStack(spacing: 10) {
                                Image(systemName: "square.and.arrow.up")
                                    .font(.system(size: 16, weight: .semibold))
                                Text("Share")
                                    .font(.system(size: 16, weight: .semibold))
                            }
                            .foregroundColor(.white)
                            .padding(.vertical, 16)
                            .padding(.horizontal, 32)
                            .background(
                                Capsule()
                                    .fill(.ultraThinMaterial)
                                    .overlay(
                                        Capsule()
                                            .stroke(.white.opacity(0.2), lineWidth: 1)
                                    )
                            )
                            .shadow(color: .black.opacity(0.3), radius: 10, x: 0, y: 5)
                        }
                        .padding(.bottom, 60)
                    }
                }
                .transition(.opacity)
                .zIndex(2)
            } else {
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 0) {
                        // Style Description Section
                        VStack(spacing: 8) {
                            Text(selectedTrend?.description ?? selectedHeadshotStyle?.description ?? "Transform your photos with AI magic")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(.white.opacity(0.6))
                                .multilineTextAlignment(.center)
                                .lineLimit(2)
                                .padding(.horizontal, 24)
                                .padding(.top, 16)
                                .padding(.bottom, 24)
                        }
                        
                        // Image Upload Section with modern card design
                        VStack(spacing: 20) {
                            // Upload area with sophisticated design
                            ZStack {
                                // Card background with multiple layers
                                RoundedRectangle(cornerRadius: 24, style: .continuous)
                                    .fill(.ultraThinMaterial)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 24, style: .continuous)
                                            .stroke(
                                                LinearGradient(
                                                    colors: [.white.opacity(0.2), .clear, selectedTheme.color.opacity(0.1)],
                                                    startPoint: .topLeading,
                                                    endPoint: .bottomTrailing
                                                ),
                                                lineWidth: 1
                                            )
                                    )
                                    .frame(height: 320)
                                    .shadow(color: .black.opacity(0.2), radius: 20, x: 0, y: 10)
                                    .shadow(color: selectedTheme.color.opacity(0.1), radius: 30, x: 0, y: 15)
                                
                                if let selectedImage = selectedImage {
                                    Image(uiImage: selectedImage)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(height: 280)
                                        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                                } else {
                                    VStack(spacing: 16) {
                                        ZStack {
                                            Circle()
                                                .fill(
                                                    LinearGradient(
                                                        colors: [
                                                            selectedTheme.color.opacity(0.2),
                                                            selectedTheme.color.opacity(0.05)
                                                        ],
                                                        startPoint: .topLeading,
                                                        endPoint: .bottomTrailing
                                                    )
                                                )
                                                .frame(width: 80, height: 80)
                                            
                                            Image(systemName: "photo.badge.plus")
                                                .font(.system(size: 36, weight: .light))
                                                .foregroundStyle(
                                                    LinearGradient(
                                                        colors: [selectedTheme.color, selectedTheme.color.opacity(0.7)],
                                                        startPoint: .topLeading,
                                                        endPoint: .bottomTrailing
                                                    )
                                                )
                                        }
                                        
                                        VStack(spacing: 6) {
                                            Text("Choose Your Photo")
                                                .font(.system(size: 18, weight: .semibold, design: .rounded))
                                                .foregroundColor(.white)
                                            
                                            Text("Select an image to transform with AI")
                                                .font(.system(size: 13, weight: .medium))
                                                .foregroundColor(.white.opacity(0.5))
                                                .multilineTextAlignment(.center)
                                        }
                                    }
                                }
                            }
                            .padding(.horizontal, 20)
                            
                            // Enhanced Action Buttons Section
                            VStack(spacing: 16) {
                                
                                
                                // 🧪 AD INTEGRATION - Rewarded Video Ad Option (COMMENTED OUT)
                                // if selectedImage != nil && !isProcessing && processedImage == nil {
                                //     VStack(spacing: 12) {
                                //         Button(action: {
                                //             showingRewardedAdOption = true
                                //         }) {
                                //             HStack(spacing: 12) {
                                //                 Image(systemName: "play.circle.fill")
                                //                     .foregroundColor(.green)
                                //                 
                                //                 VStack(alignment: .leading, spacing: 2) {
                                //                     Text("🧪 Watch Ad for Faster Processing")
                                //                         .font(.system(size: 14, weight: .semibold))
                                //                         .foregroundColor(.white)
                                //                     
                                //                     Text("Earn $0.25 • Skip processing queue")
                                //                         .font(.caption)
                                //                         .foregroundColor(.white.opacity(0.7))
                                //                 }
                                //                 
                                //                 Spacer()
                                //                 
                                //                 Text("TEST")
                                //                     .font(.caption2)
                                //                     .padding(.horizontal, 8)
                                //                     .padding(.vertical, 4)
                                //                     .background(.green.opacity(0.2))
                                //                     .foregroundColor(.green)
                                //                     .cornerRadius(6)
                                //             }
                                //             .padding(16)
                                //             .background(.ultraThinMaterial)
                                //             .cornerRadius(12)
                                //             .overlay(
                                //                 RoundedRectangle(cornerRadius: 12)
                                //                     .stroke(.white.opacity(0.1), lineWidth: 1)
                                //             )
                                //         }
                                //         .padding(.horizontal, 20)
                                //     }
                                // }
                                
                                // Progress indicator
                                if isProcessing {
                                    VStack(spacing: 12) {
                                        ZStack {
                                            Circle()
                                                .stroke(selectedTheme.color.opacity(0.2), lineWidth: 4)
                                                .frame(width: 60, height: 60)
                                            
                                            Circle()
                                                .trim(from: 0, to: CGFloat(progressValue))
                                                .stroke(
                                                    selectedTheme.color,
                                                    style: StrokeStyle(lineWidth: 4, lineCap: .round)
                                                )
                                                .frame(width: 60, height: 60)
                                                .rotationEffect(.degrees(-90))
                                                .animation(.easeInOut(duration: 0.3), value: progressValue)
                                            
                                            Text("\(Int(progressValue * 100))%")
                                                .font(.system(size: 12, weight: .bold))
                                                .foregroundColor(.white)
                                        }
                                        
                                        Text("Creating your transformation...")
                                            .font(.system(size: 14, weight: .medium))
                                            .foregroundColor(.white.opacity(0.7))
                                    }
                                    .padding(.vertical, 20)
                                }
                                                            
                            // Reward Banner (if user watched ad)
                            // RewardProcessingBanner(isVisible: showRewardBanner && isProcessing)
                            //     .padding(.horizontal, 20)
                            
                            // Action buttons
                            HStack(spacing: 12) {
                                    // Choose Photo Button
                                    Button(action: { 
                                        if selectedHeadshotStyle != nil {
                                            showHeadshotPhotoReminder = true
                                        } else {
                                            showingImagePicker = true
                                        }
                                    }) {
                                        HStack(spacing: 8) {
                                            Image(systemName: "plus.circle.fill")
                                                .font(.system(size: 16, weight: .semibold))
                                            Text("Choose")
                                                .font(.system(size: 15, weight: .semibold, design: .rounded))
                                        }
                                        .foregroundColor(.white)
                                        .padding(.vertical, 16)
                                        .padding(.horizontal, 20)
                                        .background(
                                            RoundedRectangle(cornerRadius: 16, style: .continuous)
                                                .fill(.ultraThinMaterial)
                                                .overlay(
                                                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                                                        .stroke(selectedTheme.color.opacity(0.3), lineWidth: 1)
                                                )
                                        )
                                        .shadow(color: .black.opacity(0.2), radius: 8, x: 0, y: 4)
                                    }
                                    
                                    if processedImage == nil {
                                        if isProcessing {
                                            // Cancel button
                                            Button(action: { 
                                                cancelProcessing = true
                                                isProcessing = false
                                                progressImage = nil
                                                progressValue = 0
                                                CartoonProcessingManager.shared.cancelActivity()
                                            }) {
                                                HStack(spacing: 8) {
                                                    Image(systemName: "xmark.circle.fill")
                                                        .font(.system(size: 16, weight: .semibold))
                                                    Text("Cancel")
                                                        .font(.system(size: 15, weight: .semibold, design: .rounded))
                                                }
                                                .foregroundColor(.white)
                                                .padding(.vertical, 16)
                                                .padding(.horizontal, 24)
                                                .background(
                                                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                                                        .fill(
                                                            LinearGradient(
                                                                colors: [.red.opacity(0.8), .red.opacity(0.6)],
                                                                startPoint: .topLeading,
                                                                endPoint: .bottomTrailing
                                                            )
                                                        )
                                                        .overlay(
                                                            RoundedRectangle(cornerRadius: 16, style: .continuous)
                                                                .stroke(.white.opacity(0.1), lineWidth: 1)
                                                        )
                                                )
                                                .shadow(color: .red.opacity(0.3), radius: 8, x: 0, y: 4)
                                            }
                                        } else {
                                            // Transform button
                                            Button(action: { 
                                                if adMobManager.shouldShowAds() && !hasWatchedRewardAd {
                                                    showingRewardedAd = true
                                                } else {
                                                    processImage()
                                                }
                                            }) {
                                                HStack(spacing: 8) {
                                                    Image(systemName: "wand.and.stars.inverse")
                                                        .font(.system(size: 16, weight: .semibold))
                                                    Text("Transform")
                                                        .font(.system(size: 15, weight: .semibold, design: .rounded))
                                                }
                                                .foregroundColor(.white)
                                                .padding(.vertical, 16)
                                                .padding(.horizontal, 24)
                                                .background(
                                                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                                                        .fill(
                                                            selectedImage == nil ? 
                                                                LinearGradient(
                                                                    colors: [.gray.opacity(0.3), .gray.opacity(0.2)],
                                                                    startPoint: .topLeading,
                                                                    endPoint: .bottomTrailing
                                                                ) :
                                                                LinearGradient(
                                                                    colors: [selectedTheme.color, selectedTheme.color.opacity(0.8)],
                                                                    startPoint: .topLeading,
                                                                    endPoint: .bottomTrailing
                                                                )
                                                        )
                                                        .overlay(
                                                            RoundedRectangle(cornerRadius: 16, style: .continuous)
                                                                .stroke(.white.opacity(selectedImage == nil ? 0.05 : 0.1), lineWidth: 1)
                                                        )
                                                )
                                                .shadow(color: selectedImage == nil ? .clear : selectedTheme.color.opacity(0.3), radius: 8, x: 0, y: 4)
                                            }
                                            .disabled(selectedImage == nil)
                                        }
                                    } else {
                                        // Share button
                                        Button(action: { 
                                            if let image = processedImage {
                                                self.imageToShare = image
                                                self.showingShareSheet = true
                                            }
                                        }) { 
                                            HStack(spacing: 8) {
                                                Image(systemName: "square.and.arrow.up.fill")
                                                    .font(.system(size: 16, weight: .semibold))
                                                Text("Share")
                                                    .font(.system(size: 15, weight: .semibold, design: .rounded))
                                            }
                                            .foregroundColor(.white)
                                            .padding(.vertical, 16)
                                            .padding(.horizontal, 24)
                                            .background(
                                                RoundedRectangle(cornerRadius: 16, style: .continuous)
                                                    .fill(
                                                        LinearGradient(
                                                            colors: [selectedTheme.color, selectedTheme.color.opacity(0.8)],
                                                            startPoint: .topLeading,
                                                            endPoint: .bottomTrailing
                                                        )
                                                    )
                                                    .overlay(
                                                        RoundedRectangle(cornerRadius: 16, style: .continuous)
                                                            .stroke(.white.opacity(0.1), lineWidth: 1)
                                                    )
                                            )
                                            .shadow(color: selectedTheme.color.opacity(0.3), radius: 8, x: 0, y: 4)
                                        }
                                    }
                                }
                            }
                            .padding(.horizontal, 20)
                            .padding(.top, 32)
                            
                            // Enhanced Processed Image Result
                            if let processedImage = processedImage, !isProcessing {
                                VStack(spacing: 20) {
                                    HStack(spacing: 8) {
                                        Image(systemName: "checkmark.circle.fill")
                                            .font(.system(size: 20))
                                            .foregroundColor(selectedTheme.color)
                                        
                                        Text("Transformation Complete!")
                                            .font(.system(size: 18, weight: .semibold, design: .rounded))
                                            .foregroundColor(.white)
                                    }
                                    
                                    ZStack {
                                        RoundedRectangle(cornerRadius: 24, style: .continuous)
                                            .fill(.ultraThinMaterial)
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 24, style: .continuous)
                                                    .stroke(
                                                        LinearGradient(
                                                            colors: [selectedTheme.color.opacity(0.3), .clear],
                                                            startPoint: .topLeading,
                                                            endPoint: .bottomTrailing
                                                        ),
                                                        lineWidth: 2
                                                    )
                                            )
                                            .frame(height: 320)
                                            .shadow(color: .black.opacity(0.2), radius: 20, x: 0, y: 10)
                                            .shadow(color: selectedTheme.color.opacity(0.2), radius: 30, x: 0, y: 15)
                                        
                                        Image(uiImage: processedImage)
                                            .resizable()
                                            .scaledToFit()
                                            .frame(height: 280)
                                            .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                                            .onTapGesture {
                                                withAnimation(.easeInOut(duration: 0.3)) {
                                                    self.isImageExpanded = true
                                                }
                                            }
                                        
                                        // Expand indicator
                                        VStack {
                                            Spacer()
                                            HStack {
                                                Spacer()
                                                Button(action: {
                                                    withAnimation(.easeInOut(duration: 0.3)) {
                                                        self.isImageExpanded = true
                                                    }
                                                }) {
                                                    ZStack {
                                                        Circle()
                                                            .fill(.ultraThinMaterial)
                                                            .frame(width: 40, height: 40)
                                                        
                                                        Image(systemName: "arrow.up.left.and.arrow.down.right")
                                                            .font(.system(size: 14, weight: .semibold))
                                                            .foregroundColor(.white)
                                                    }
                                                }
                                                .padding(.trailing, 16)
                                                .padding(.bottom, 16)
                                            }
                                        }
                                    }
                                    .padding(.horizontal, 20)
                                }
                                .padding(.top, 32)
                            }
                        }
                    }
                    
                    // Bottom spacer
                    Spacer()
                        .frame(height: 100)
                }
                .onChange(of: selectedImage) { _ in
                    if processedImage != nil {
                        processedImage = nil
                        progressImage = nil
                        progressValue = 0
                    }
                    // Reset reward ad states
                    hasWatchedRewardAd = false
                    showRewardBanner = false
                }
            }
        }
        .sheet(isPresented: $showingImagePicker, onDismiss: {
            if let firstImage = selectedImages.first {
                selectedImage = firstImage
            }
        }) {
            ImagePicker(images: $selectedImages, selectionLimit: 1)
        }
        .sheet(isPresented: $showingShareSheet) {
            if let imageToShare = imageToShare {
                ShareSheet(activityItems: [imageToShare])
                    .presentationDetents([.medium, .large])
            } else {
                // Fallback - this should not happen, but prevents empty sheets
                Text("No image to share")
                    .presentationDetents([.medium])
            }
        }
        .alert(isPresented: $showError) {
            Alert(title: Text("Error"), message: Text(errorMessage), dismissButton: .default(Text("OK")))
        }
        .alert("📸 Photo Tips for Best Results", isPresented: $showHeadshotPhotoReminder) {
            Button("Got it, Choose Photo") { 
                showingImagePicker = true 
            }
            Button("Cancel", role: .cancel) { }
        } message: {
            Text("For the best headshot results, please use:\n\n• A clear, well-lit selfie or portrait\n• Face clearly visible and not too far away\n• Good lighting on your face\n• Avoid sunglasses or face coverings\n• Look directly at the camera\n\nThis will help the AI create a more accurate professional headshot that looks like you!")
               
        }
        .multilineTextAlignment(.leading)
        .navigationTitle(selectedTrend?.name ?? selectedHeadshotStyle?.rawValue ?? selectedTheme.name)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar(.hidden, for: .tabBar)
        .overlay(
            // Rewarded Ad Overlay
            Group {
                if showingRewardedAd {
                    RewardedAdView(
                        isPresented: $showingRewardedAd,
                        onRewardEarned: {
                            hasWatchedRewardAd = true
                            processImage()
                        },
                        onDismissed: {
                            // User dismissed without watching ad - don't process
                            // They need to watch the ad to get free generation
                        }
                    )
                }
            }
        )
        // Test Ad Overlays
        // .overlay(
        //     TestInterstitialAdView(isShowing: $showingInterstitialAd) {
        //         showingInterstitialAd = false
        //     }
        // )
        // Test Ad Revenue Display
        // .overlay(alignment: .topTrailing) {
        //     if adManager.adEarnings > 0 {
        //         VStack(alignment: .trailing, spacing: 4) {
        //             Text("💰 Test Revenue")
        //                 .font(.caption2)
        //                 .foregroundColor(.white.opacity(0.7))
        //             
        //             Text("$\(String(format: "%.2f", adManager.adEarnings))")
        //                 .font(.system(size: 16, weight: .bold))
        //                 .foregroundColor(.green)
        //                 .padding(.horizontal, 12)
        //                 .padding(.vertical, 6)
        //                 .background(.ultraThinMaterial)
        //                 .cornerRadius(20)
        //             
        //             Button("Reset") {
        //                 adManager.resetEarnings()
        //             }
        //             .font(.caption2)
        //             .foregroundColor(.white.opacity(0.7))
        //         }
        //         .padding(.top, 60)
        //         .padding(.trailing, 20)
        //     }
        // }
        // 🧪 AD INTEGRATION - Test Rewarded Video Alert (COMMENTED OUT)
        // .alert("🧪 Test Rewarded Video", isPresented: $showingRewardedAdOption) {
        //     Button("Watch Ad (+$0.25)") {
        //         // adManager.showRewardedAd { success in
        //         //     if success {
        //         //         // Simulate faster processing or premium feature
        //         //         processImage()
        //         //     }
        //         // }
        //     }
        //     Button("Skip", role: .cancel) {}
        // } message: {
        //     Text("Watch a test ad to simulate earning revenue and unlocking faster processing!")
        // }
        .onAppear {
            Analytics.logEvent(AnalyticsEventScreenView, parameters: [
                AnalyticsParameterScreenName: "ContentView",
                AnalyticsParameterScreenClass: "ContentView"
            ])
        }
    }
    
    private func processImage() {
        guard let image = selectedImage else { return }
        isProcessing = true
        cancelProcessing = false
        progressValue = 0
        
        // Start the live activity for Dynamic Island
        CartoonProcessingManager.shared.startActivity(themeName: selectedTheme.name)
        
        // Choose processing method based on whether we have a trend, headshot style, or theme
        if let headshotStyle = selectedHeadshotStyle {
            // Use headshot-specific generation
            imageProcessor.generateHeadshot(
                image: image,
                style: headshotStyle.apiPrompt,
                progressCallback: { (updatedImage, progress) in
                    // Only update if not cancelled
                    if !cancelProcessing {
                        self.progressImage = updatedImage
                        self.progressValue = progress
                        
                        // Update Dynamic Island activity progress
                        CartoonProcessingManager.shared.updateProgress(Double(progress))
                    }
                }
            ) { result in
                DispatchQueue.main.async {
                    // Only update if not cancelled
                    if !self.cancelProcessing {
                        if let result = result {
                            self.processedImage = result
                            
                            // 🧪 TEST: Show interstitial ad after successful generation
                            // DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            //     if adManager.isAdLoaded {
                            //         adManager.showInterstitialAd()
                            //         showingInterstitialAd = true
                            //     }
                            // }
                            
                            // Complete the Dynamic Island activity
                            CartoonProcessingManager.shared.completeActivity()
                            
                            // Log a custom event to Firebase Analytics
                            Analytics.logEvent("applied_style", parameters: [
                                "style_name": selectedTheme.name,
                                "category": selectedTrend?.name ?? selectedHeadshotStyle?.rawValue ?? "Theme"
                            ])
                        } else {
                            self.errorMessage = "Failed to generate headshot. Please try again."
                            self.showError = true
                            
                            // Cancel the Dynamic Island activity
                            CartoonProcessingManager.shared.cancelActivity()
                        }
                        self.isProcessing = false
                    }
                }
            }
        } else if let trend = selectedTrend {
            // Use trend-specific transformation
            imageProcessor.transformWithTrend(
                image: image,
                trend: trend,
                progressCallback: { (updatedImage, progress) in
                    // Only update if not cancelled
                    if !cancelProcessing {
                        self.progressImage = updatedImage
                        self.progressValue = progress
                        
                        // Update Dynamic Island activity progress
                        CartoonProcessingManager.shared.updateProgress(Double(progress))
                    }
                }
            ) { result in
                DispatchQueue.main.async {
                    // Only update if not cancelled
                    if !self.cancelProcessing {
                        if let result = result {
                            self.processedImage = result
                            
                            // 🧪 TEST: Show interstitial ad after successful generation
                            // DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            //     if adManager.isAdLoaded {
                            //         adManager.showInterstitialAd()
                            //         showingInterstitialAd = true
                            //     }
                            // }
                            
                            // Complete the Dynamic Island activity
                            CartoonProcessingManager.shared.completeActivity()
                            
                            // Log a custom event to Firebase Analytics
                            Analytics.logEvent("applied_style", parameters: [
                                "style_name": selectedTheme.name,
                                "category": selectedTrend?.name ?? selectedHeadshotStyle?.rawValue ?? "Theme"
                            ])
                        } else {
                            self.errorMessage = "Failed to process the image. Please try again."
                            self.showError = true
                            
                            // Cancel the Dynamic Island activity
                            CartoonProcessingManager.shared.cancelActivity()
                        }
                        self.isProcessing = false
                    }
                }
            }
        } else {
            // Use traditional cartoon transformation
            imageProcessor.cartoonify(
                image: image,
                theme: selectedTheme.name,
                progressCallback: { (updatedImage, progress) in
                    // Only update if not cancelled
                    if !cancelProcessing {
                        self.progressImage = updatedImage
                        self.progressValue = progress
                        
                        // Update Dynamic Island activity progress
                        CartoonProcessingManager.shared.updateProgress(Double(progress))
                    }
                }
            ) { result in
                DispatchQueue.main.async {
                    // Only update if not cancelled
                    if !self.cancelProcessing {
                        if let result = result {
                            self.processedImage = result
                            
                            // 🧪 TEST: Show interstitial ad after successful generation
                            // DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            //     if adManager.isAdLoaded {
                            //         adManager.showInterstitialAd()
                            //         showingInterstitialAd = true
                            //     }
                            // }
                            
                            // Complete the Dynamic Island activity
                            CartoonProcessingManager.shared.completeActivity()
                            
                            // Log a custom event to Firebase Analytics
                            Analytics.logEvent("applied_style", parameters: [
                                "style_name": selectedTheme.name,
                                "category": selectedTrend?.name ?? selectedHeadshotStyle?.rawValue ?? "Theme"
                            ])
                        } else {
                            self.errorMessage = "Failed to process the image. Please try again."
                            self.showError = true
                            
                            // Cancel the Dynamic Island activity
                            CartoonProcessingManager.shared.cancelActivity()
                        }
                        self.isProcessing = false
                    }
                }
            }
        }
    }
    
    private func startTestAnimation() {
        // Reset state
        isProcessing = true
        cancelProcessing = false
        progressValue = 0
        testMode = true
        
        // Create a sample image for testing
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 300, height: 300))
        let sampleImage = renderer.image { context in
            // Convert SwiftUI Color to UIColor
            UIColor(selectedTheme.color).setFill()
            context.fill(CGRect(x: 0, y: 0, width: 300, height: 300))
            
            UIColor.white.setFill()
            let rect = CGRect(x: 50, y: 125, width: 200, height: 50)
            context.fill(rect)
        }
        
        selectedImage = sampleImage
        
        // Simulate progress animation
        Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { timer in
            if cancelProcessing || !isProcessing {
                timer.invalidate()
                return
            }
            
            progressValue += 0.02 // Increase by 2% each update
            
            if progressValue >= 1.0 {
                progressValue = 1.0
                
                // Simulate completion after a brief delay
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    if !cancelProcessing {
                        // Create a test result image
                        let resultRenderer = UIGraphicsImageRenderer(size: CGSize(width: 300, height: 300))
                        let resultImage = resultRenderer.image { context in
                            // Convert SwiftUI Color to UIColor with opacity
                            UIColor(selectedTheme.color.opacity(0.7)).setFill()
                            context.fill(CGRect(x: 0, y: 0, width: 300, height: 300))
                            
                            UIColor.white.setFill()
                            let rect = CGRect(x: 75, y: 125, width: 150, height: 50)
                            context.fill(rect)
                        }
                        
                        processedImage = resultImage
                        isProcessing = false
                        testMode = false
                    }
                }
                timer.invalidate()
            }
        }
    }
    

}

#Preview {
    ContentView(selectedTheme: Theme(name: "Studio Ghibli", color: .purple, image: "ghibli_sample", logo: ""))
}
