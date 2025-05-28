//
//  ContentView.swift
//  CartoonMe
//
//  Created by Yuri Petrosyan on 10/04/2025.
//

// ContentView.swift
import SwiftUI
import PhotosUI
import UIKit // Re-adding UIKit import
// If needed, add @testable import CartoonMe for test targets


struct ContentView: View {
    let selectedTheme: Theme
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
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            // Enlarged image view - shows directly in the main view
            if isImageExpanded, let imageToShow = processedImage {
                ZStack {
                    Color.black.opacity(0.9).edgesIgnoringSafeArea(.all)
                    
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
                                Image(systemName: "xmark.circle.fill")
                                    .font(.system(size: 28))
                                    .foregroundColor(.white)
                                    .padding()
                            }
                        }
                        Spacer()
                        
                        // Share button at bottom
                        Button(action: { 
                            self.imageToShare = imageToShow
                            self.showingShareSheet = true
                        }) {
                            HStack {
                                Image(systemName: "square.and.arrow.up")
                                Text("Share")
                            }
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding(.vertical, 12)
                            .padding(.horizontal, 24)
                            .background(Capsule().fill(Color.blue.opacity(0.7)))
                        }
                        .padding(.bottom, 60)
                    }
                }
                .transition(.opacity)
                .zIndex(2)
            } else {
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 0) {
                        // Title Section
                        HStack(spacing: 14) {
                            if let logo = selectedTheme.logo, !logo.isEmpty {
                                Image(logo)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 36, height: 36)
                            }
                            Text(selectedTheme.name)
                                .font(.system(size: 28, weight: .heavy, design: .rounded))
                                .foregroundStyle(
                                    LinearGradient(
                                        colors: [.white, .white.opacity(0.9)],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .onTapGesture {
                                    startTestAnimation()
                                }
                        }
                        .padding(.top, 12)
                        .padding(.bottom, 24)
                        
                        // Enhanced Image Preview
                        ZStack {
                            // Glassmorphism background
                            RoundedRectangle(cornerRadius: 28, style: .continuous)
                                .fill(.ultraThinMaterial)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 28, style: .continuous)
                                        .stroke(
                                            LinearGradient(
                                                colors: [.white.opacity(0.3), .clear],
                                                startPoint: .topLeading,
                                                endPoint: .bottomTrailing
                                            ),
                                            lineWidth: 1
                                        )
                                )
                                .frame(height: 300)
                                .shadow(color: .black.opacity(0.25), radius: 20, x: 0, y: 10)
                                .shadow(color: selectedTheme.color.opacity(0.2), radius: 30, x: 0, y: 15)
                            
                            if let selectedImage = selectedImage {
                                Image(uiImage: selectedImage)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: 260)
                                    .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
                            } else {
                                VStack(spacing: 14) {
                                    ZStack {
                                        Circle()
                                            .fill(selectedTheme.color.opacity(0.1))
                                            .frame(width: 70, height: 70)
                                        
                                        Image(systemName: "photo.badge.plus")
                                            .font(.system(size: 32, weight: .light))
                                            .foregroundStyle(
                                                LinearGradient(
                                                    colors: [selectedTheme.color, selectedTheme.color.opacity(0.7)],
                                                    startPoint: .topLeading,
                                                    endPoint: .bottomTrailing
                                                )
                                            )
                                    }
                                    
                                    VStack(spacing: 4) {
                                        Text("Choose Your Photo")
                                            .font(.system(size: 20, weight: .semibold, design: .rounded))
                                            .foregroundColor(.white)
                                        
                                        Text("Select an image to transform")
                                            .font(.system(size: 14, weight: .medium))
                                            .foregroundColor(.white.opacity(0.6))
                                    }
                                }
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                    
                    // Fixed spacing between image and buttons
                    Spacer()
                        .frame(height: 24)
                    
                    // Enhanced Action Buttons with Progress Animation
                        ZStack {
                            // Animated progress stroke around buttons
                            if isProcessing {
                                RoundedRectangle(cornerRadius: 30, style: .continuous)
                                    .trim(from: 0, to: CGFloat(progressValue))
                                    .stroke(
                                        selectedTheme.color,
                                        style: StrokeStyle(lineWidth: 5, lineCap: .round)
                                    )
                                    .frame(height: 70)
                                    .padding(.horizontal, 30)
                                    .animation(.easeInOut(duration: 0.3), value: progressValue)
                                    .shadow(color: selectedTheme.color.opacity(0.9), radius: 6, x: 0, y: 0)
                            }
                            
                            HStack(spacing: 14) {
                            Button(action: { showingImagePicker = true }) {
                                HStack(spacing: 10) {
                                    Image(systemName: "plus.circle.fill")
                                        .font(.system(size: 18, weight: .semibold))
                                    Text("Choose Photo")
                                        .font(.system(size: 17, weight: .semibold, design: .rounded))
                                }
                                .foregroundColor(.white)
                                .padding(.vertical, 14)
                                .padding(.horizontal, 20)
                                .background(
                                    Capsule()
                                        .fill(
                                            LinearGradient(
                                                colors: [selectedTheme.color, selectedTheme.color.opacity(0.8)],
                                                startPoint: .topLeading,
                                                endPoint: .bottomTrailing
                                            )
                                        )
                                        .shadow(color: selectedTheme.color.opacity(0.4), radius: 10, x: 0, y: 5)
                                )
                            }
                    .onChange(of: selectedImage) { _ in // Reset processedImage when a new image is selected
                        if processedImage != nil {
                            processedImage = nil
                            progressImage = nil
                            progressValue = 0
                        }
                    }
                    
                    if processedImage == nil {
                        if isProcessing {
                                                                // Cancel button when processing
                                Button(action: { 
                                    cancelProcessing = true
                                    isProcessing = false
                                    progressImage = nil
                                    progressValue = 0
                                    
                                    // Cancel the Dynamic Island activity
                                    CartoonProcessingManager.shared.cancelActivity()
                                }) {
                                    HStack(spacing: 10) {
                                        Image(systemName: "xmark.circle.fill")
                                            .font(.system(size: 18, weight: .semibold))
                                        Text("Cancel")
                                            .font(.system(size: 17, weight: .semibold, design: .rounded))
                                    }
                                    .foregroundColor(.white)
                                    .padding(.vertical, 14)
                                    .padding(.horizontal, 20)
                                    .background(
                                        Capsule()
                                            .fill(
                                                LinearGradient(
                                                    colors: [.red, .red.opacity(0.8)],
                                                    startPoint: .topLeading,
                                                    endPoint: .bottomTrailing
                                                )
                                            )
                                            .shadow(color: .red.opacity(0.4), radius: 10, x: 0, y: 5)
                                    )
                                }
                        } else {
                                                                // Cartoon It button
                                Button(action: { processImage() }) {
                                    HStack(spacing: 10) {
                                        Image(systemName: "wand.and.stars.inverse")
                                            .font(.system(size: 18, weight: .semibold))
                                        Text("Cartoon It!")
                                            .font(.system(size: 17, weight: .semibold, design: .rounded))
                                    }
                                    .foregroundColor(.white)
                                    .padding(.vertical, 14)
                                    .padding(.horizontal, 20)
                                    .background(
                                        Capsule()
                                            .fill(
                                                LinearGradient(
                                                    colors: selectedImage == nil ? 
                                                        [.green.opacity(0.3), .green.opacity(0.2)] :
                                                        [.green, .green.opacity(0.8)],
                                                    startPoint: .topLeading,
                                                    endPoint: .bottomTrailing
                                                )
                                            )
                                            .shadow(color: selectedImage == nil ? .clear : .green.opacity(0.4), radius: 10, x: 0, y: 5)
                                    )
                                }
                                .disabled(selectedImage == nil)
                        }
                    } else {
                        // Share/Export button when image processed
                        Button(action: { 
                            if let image = processedImage {
                                self.imageToShare = image
                                self.showingShareSheet = true
                            }
                        }) { 
                            HStack(spacing: 10) {
                                Image(systemName: "square.and.arrow.up.fill")
                                    .font(.system(size: 18, weight: .semibold))
                                Text("Share")
                                    .font(.system(size: 17, weight: .semibold, design: .rounded))
                            }
                            .foregroundColor(.white)
                            .padding(.vertical, 14)
                            .padding(.horizontal, 20)
                            .background(
                                Capsule()
                                    .fill(
                                        LinearGradient(
                                            colors: [.blue, .blue.opacity(0.8)],
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        )
                                    )
                                    .shadow(color: .blue.opacity(0.4), radius: 10, x: 0, y: 5)
                            )
                        }
                    }
                                                                }
                        .padding(.horizontal, 24)
                        
                        // Progress and Result Section
                    VStack(spacing: 28) {
                        
                        // Enhanced Processed Image Preview
                        if let processedImage = processedImage, !isProcessing {
                            VStack(spacing: 16) {
                                Text("✨ Transformation Complete!")
                                    .font(.system(size: 20, weight: .semibold, design: .rounded))
                                    .foregroundStyle(
                                        LinearGradient(
                                            colors: [.white, .white.opacity(0.9)],
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        )
                                    )
                                
                                ZStack {
                                    RoundedRectangle(cornerRadius: 32, style: .continuous)
                                        .fill(.ultraThinMaterial)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 32, style: .continuous)
                                                .stroke(
                                                    LinearGradient(
                                                        colors: [selectedTheme.color.opacity(0.4), .clear],
                                                        startPoint: .topLeading,
                                                        endPoint: .bottomTrailing
                                                    ),
                                                    lineWidth: 2
                                                )
                                        )
                                        .frame(height: 300)
                                        .shadow(color: .black.opacity(0.25), radius: 20, x: 0, y: 10)
                                        .shadow(color: selectedTheme.color.opacity(0.4), radius: 30, x: 0, y: 15)
                                    
                                    Image(uiImage: processedImage)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(height: 260)
                                        .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
                                        .onTapGesture {
                                            withAnimation(.easeInOut(duration: 0.3)) {
                                                self.isImageExpanded = true
                                            }
                                        }
                                    
                                    // Tap to expand indicator
                                    VStack {
                                        Spacer()
                                        HStack {
                                            Spacer()
                                            VStack(spacing: 4) {
                                                Image(systemName: "arrow.up.left.and.arrow.down.right")
                                                    .font(.system(size: 16, weight: .semibold))
                                        
                                            }
                                            .foregroundColor(.white)
                                            .padding(12)
                                            .background(
                                                Circle()
                                                    .fill(.black.opacity(0.6))
                                                    .background(.ultraThinMaterial, in: Circle())
                                            )
                                            .onTapGesture {
                                                withAnimation(.easeInOut(duration: 0.3)) {
                                                    self.isImageExpanded = true
                                                }
                                            }
                                            .padding(.trailing, 16)
                                            .padding(.bottom, 16)
                                        }
                                    }
                                }
                                .padding(.horizontal, 20)
                            }
                        }
                    }
                    .padding(.top, 24)
                    
                    // Processing Status Text (positioned at bottom, separate from buttons)
//                    if isProcessing {
//                        VStack(spacing: 12) {
//                            Text("✨ Creating your transformation...")
//                                .font(.system(size: 18, weight: .semibold, design: .rounded))
//                                .foregroundStyle(
//                                    LinearGradient(
//                                        colors: [.white, .white.opacity(0.9)],
//                                        startPoint: .topLeading,
//                                        endPoint: .bottomTrailing
//                                    )
//                                )
//                                .multilineTextAlignment(.center)
//                            
//                            Text("\(Int(progressValue * 100))% Complete")
//                                .font(.system(size: 16, weight: .medium))
//                                .foregroundStyle(
//                                    LinearGradient(
//                                        colors: [selectedTheme.color, selectedTheme.color.opacity(0.8)],
//                                        startPoint: .leading,
//                                        endPoint: .trailing
//                                    )
//                                )
//                              
//                        }
//                        .padding(.horizontal, 30)
//                        .padding(.vertical, 20)
//                        .background(
//                            RoundedRectangle(cornerRadius: 16, style: .continuous)
//                                .fill(.ultraThinMaterial)
//                                .opacity(0.8)
//                        )
//                        .padding(.horizontal, 24)
//                        .padding(.top, 40)
//                    }
                    
                    // Bottom spacer for ScrollView
                    Spacer()
                        .frame(height: 100)
                }
                .padding(.bottom, 20)
            }
                
                .sheet(isPresented: $showingImagePicker) {
                    ImagePicker(image: $selectedImage)
                }
            }
        }
      
        .sheet(isPresented: $showingShareSheet) {
            if let imageToShare = imageToShare {
                ShareSheet(activityItems: [imageToShare])
                    .presentationDetents([.medium, .large])
            }
        }
        .alert(isPresented: $showError) {
            Alert(title: Text("Error"), message: Text(errorMessage), dismissButton: .default(Text("OK")))
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Test") {
                    startTestAnimation()
                }
                .foregroundColor(.white)
                .font(.system(size: 16, weight: .semibold))
            }
        }
    }
    
    private func processImage() {
        guard let image = selectedImage else { return }
        isProcessing = true
        cancelProcessing = false
        progressValue = 0
        
        // Start the live activity for Dynamic Island
        CartoonProcessingManager.shared.startActivity(themeName: selectedTheme.name)
        
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
                        
                        // Complete the Dynamic Island activity
                        CartoonProcessingManager.shared.completeActivity()
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
