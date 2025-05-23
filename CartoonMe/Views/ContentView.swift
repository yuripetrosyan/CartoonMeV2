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
                ScrollView {
                    VStack(spacing: 28) {
                        // Title
                        HStack(spacing: 12) {
                            if let logo = selectedTheme.logo, !logo.isEmpty {
                                Image(logo)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 36, height: 36)
                            }
                            Text(selectedTheme.name)
                                .font(.title.bold())
                                .foregroundColor(.white)
                        }
                        .padding(.top, 16)
                        // Image Preview Card
                        ZStack {
                            RoundedRectangle(cornerRadius: 24, style: .continuous)
                                .fill(.ultraThinMaterial)
                                .frame(height: 260)
                                .shadow(color: .black.opacity(0.18), radius: 16, x: 0, y: 8)
                            if let selectedImage = selectedImage {
                                Image(uiImage: selectedImage)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: 220)
                                    .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
                            } else {
                                VStack(spacing: 8) {
                                    Image(systemName: "photo")
                                        .font(.system(size: 44, weight: .light))
                                        .foregroundColor(.white.opacity(0.7))
                                    Text("Pick a photo")
                                        .foregroundColor(.white.opacity(0.7))
                                        .font(.headline)
                                }
                            }
                        }
                        .padding(.horizontal, 24)
                        // Action Buttons Card
                        ZStack {
                            RoundedRectangle(cornerRadius: 24, style: .continuous)
                                .fill(.ultraThinMaterial)
                                .shadow(color: .black.opacity(0.10), radius: 10, x: 0, y: 4)
                            HStack(spacing: 18) {
                                Button(action: { showingImagePicker = true }) {
                                    HStack {
                                        Image(systemName: "plus.circle")
                                        Text("Choose Photo")
                                    }
                                    .font(.headline)
                                    .foregroundColor(.white)
                                    .padding(.vertical, 10)
                                    .padding(.horizontal, 18)
                                    .background(
                                        Capsule().fill(selectedTheme.color.opacity(0.7))
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
                                            HStack {
                                                Image(systemName: "xmark.circle")
                                                Text("Cancel")
                                            }
                                            .font(.headline)
                                            .foregroundColor(.white)
                                            .padding(.vertical, 10)
                                            .padding(.horizontal, 18)
                                            .background(
                                                Capsule().fill(Color.red.opacity(0.7))
                                            )
                                        }
                                    } else {
                                        // Cartoon It button
                                        Button(action: { processImage() }) {
                                            HStack {
                                                Image(systemName: "wand.and.stars")
                                                Text("Cartoon It!")
                                            }
                                            .font(.headline)
                                            .foregroundColor(.white)
                                            .padding(.vertical, 10)
                                            .padding(.horizontal, 18)
                                            .background(
                                                Capsule().fill(Color.green.opacity(selectedImage == nil ? 0.3 : 0.7))
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
                                        HStack {
                                            Image(systemName: "square.and.arrow.up")
                                            Text("Share")
                                        }
                                        .font(.headline)
                                        .foregroundColor(.white)
                                        .padding(.vertical, 10)
                                        .padding(.horizontal, 18)
                                        
                                        .background(
                                            Capsule().fill(Color.blue.opacity(0.7))
                                        )
                                    }
                                }
                            }
                            .padding(.vertical, 8)
                        }
                        .padding(.horizontal, 24)
                        
                        // Progress Visualization
                        if isProcessing {
                            VStack(spacing: 12) {
                                // Progress Image Preview
                                if let progressImage = progressImage {
                                    ZStack {
                                        RoundedRectangle(cornerRadius: 24, style: .continuous)
                                            .fill(.ultraThinMaterial)
                                            .frame(height: 220)
                                            .shadow(color: .black.opacity(0.18), radius: 16, x: 0, y: 8)
                                        
                                        Image(uiImage: progressImage)
                                            .resizable()
                                            .scaledToFit()
                                            .frame(height: 180)
                                            .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
                                    }
                                    .padding(.horizontal, 24)
                                }
                                
                                // Progress Bar
                                VStack(spacing: 2) {
                                    ProgressView(value: progressValue, total: 1.0)
                                        .progressViewStyle(LinearProgressViewStyle())
                                        .tint(selectedTheme.color)
                                        .scaleEffect(x: 1, y: 2, anchor: .center)
                                        .padding(.horizontal, 40)
                                    
                                    Text("\(Int(progressValue * 100))% Complete")
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                }
                                .padding(.bottom, 10)
                            }
                        }
                        
                        // Processed Image Preview
                        if let processedImage = processedImage, !isProcessing {
                            ZStack {
                                RoundedRectangle(cornerRadius: 24, style: .continuous)
                                    .fill(.ultraThinMaterial)
                                    .frame(height: 220)
                                    .shadow(color: .black.opacity(0.18), radius: 16, x: 0, y: 8)
                                Image(uiImage: processedImage)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: 180)
                                    .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
                                    .onTapGesture {
                                        withAnimation(.easeInOut(duration: 0.2)) {
                                            self.isImageExpanded = true
                                        }
                                    }
                            }
                            .padding(.horizontal, 24)
                        }
                        Spacer()
                    }.padding(.bottom, 100)
                    
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
}

#Preview {
    ContentView(selectedTheme: Theme(name: "Studio Ghibli", color: .purple, image: "ghibli_sample", logo: ""))
}
