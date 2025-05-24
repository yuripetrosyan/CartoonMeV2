//
//  ThemeSelectionView.swift
//  CartoonMe
//
//  Created by Yuri Petrosyan on 10/04/2025.
//
import SwiftUI

struct ThemeSelectionView: View {
    @State private var showAllThemes = false
    let themes = [
        Theme(name: "Simpsons", color: .yellow, image: "SimpsonsImage", logo: nil),
        Theme(name: "Studio Ghibli", color: .purple, image: "GhibliImage", logo: ""),
        Theme(name: "Classic Cartoon", color: .blue, image: "",logo: ""),
        Theme(name: "Anime Style", color: .pink, image: "AnimeImage", logo: ""),
        Theme(name: "Disney", color: .orange, image: "DisneyImage", logo: "DinseyLogo"),
        Theme(name: "Pixar Style", color: .yellow, image: "PixarImage", logo: nil),
        Theme(name: "Marvel Comic", color: .red, image: "MarvelImage", logo: nil),
        Theme(name: "Pop Art", color: .green, image: "PopArtImage", logo: nil),
        Theme(name: "Chibi", color: .mint, image: "ChibiImage", logo: nil),
        Theme(name: "Noir Comic", color: .gray, image: "NoirImage", logo: nil),
        Theme(name: "Watercolor Illustration", color: .cyan, image: "WatercolorImage", logo: nil),
        Theme(name: "Retro 80s Cartoon", color: .teal, image: "Retro80sImage", logo: nil),
        Theme(name: "Minimalist Flat", color: .indigo, image: "MinimalistImage", logo: nil),
        Theme(name: "Manga", color: .black, image: "MangaImage", logo: nil),
        Theme(name: "Caricature", color: .brown, image: "CaricatureImage", logo: nil),
        
    ]
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Modern gradient background
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color.black,
                        Color.black.opacity(0.95),
                        Color(red: 0.05, green: 0.05, blue: 0.1)
                    ]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea(.all)
                
                ScrollView(showsIndicators: false) {
                    LazyVStack(spacing: 32) {
                        // Hidden NavigationLink for programmatic navigation
                        NavigationLink(destination: AllThemesView(themes: themes), isActive: $showAllThemes) { EmptyView() }
                        
                        // Header Section
                        VStack(spacing: 8) {
                            Text("Transform Your Style")
                                .font(.system(size: 28, weight: .bold, design: .rounded))
                                .foregroundStyle(
                                    LinearGradient(
                                        colors: [.white, .white.opacity(0.8)],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                            
                            Text("Choose from our collection of AI-powered cartoon styles")
                                .font(.system(size: 16, weight: .medium))
                                .foregroundColor(.white.opacity(0.7))
                                .multilineTextAlignment(.center)
                        }
                        .padding(.top, 20)
                        .padding(.horizontal, 24)
                        
                        // Main Themes Carousel with modern styling
                        ModernCarouselSection(
                            title: "✨ Most Popular",
                            subtitle: "Trending styles loved by creators",
                            themes: themes,
                            showSeeAll: true,
                            seeAllAction: { showAllThemes = true }
                        )
                        
                        // Featured Banner with modern design
                        NavigationLink(
                            destination: ContentView(
                                selectedTheme: Theme(name: "Disney", color: .orange, image: "HouseImage", logo: "DisneyLogo")
                            )
                        ) {
                            ModernFeaturedBanner()
                        }
                        .padding(.vertical, 8)
                        
                        // New Styles Carousel
                        ModernCarouselSection(
                            title: "🎨 Fresh Arrivals",
                            subtitle: "Latest AI art styles just added",
                            themes: Array(themes.reversed()),
                            showSeeAll: true,
                            seeAllAction: { showAllThemes = true }
                        )
                        
                        // Browse All Section
                        VStack(spacing: 16) {
                            HStack {
                                Text("Explore All Styles")
                                    .font(.system(size: 22, weight: .bold, design: .rounded))
                                    .foregroundColor(.white)
                                Spacer()
                            }
                            .padding(.horizontal, 24)
                            
                            Button(action: { showAllThemes = true }) {
                                HStack(spacing: 12) {
                                    Image(systemName: "square.grid.2x2")
                                        .font(.system(size: 18, weight: .semibold))
                                    
                                    Text("Browse All \(themes.count) Styles")
                                        .font(.system(size: 16, weight: .semibold))
                                    
                                    Spacer()
                                    
                                    Image(systemName: "arrow.right")
                                        .font(.system(size: 14, weight: .semibold))
                                }
                                .foregroundColor(.white)
                                .padding(.horizontal, 24)
                                .padding(.vertical, 18)
                                .background(
                                    ZStack {
                                        RoundedRectangle(cornerRadius: 16)
                                            .fill(.ultraThinMaterial)
                                        
                                        RoundedRectangle(cornerRadius: 16)
                                            .stroke(
                                                LinearGradient(
                                                    colors: [.white.opacity(0.3), .clear],
                                                    startPoint: .topLeading,
                                                    endPoint: .bottomTrailing
                                                ),
                                                lineWidth: 1
                                            )
                                    }
                                )
                            }
                            .padding(.horizontal, 24)
                        }
                    }
                    .padding(.bottom, 120)
                }
            }
            .navigationTitle("CartoonMe")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(.ultraThinMaterial, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    HStack(spacing: 16) {
                        Button(action: {}) {
                            Image(systemName: "magnifyingglass")
                                .font(.system(size: 18, weight: .medium))
                                .foregroundStyle(
                                    LinearGradient(
                                        colors: [.white, .white.opacity(0.8)],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                        }
                        
                        Button(action: {}) {
                            Image(systemName: "person.circle")
                                .font(.system(size: 20, weight: .medium))
                                .foregroundStyle(
                                    LinearGradient(
                                        colors: [.white, .white.opacity(0.8)],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                        }
                    }
                }
            }
        }
    }
}

// Modern carousel section wrapper
struct ModernCarouselSection: View {
    let title: String
    let subtitle: String
    let themes: [Theme]
    let showSeeAll: Bool
    let seeAllAction: (() -> Void)?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Modern header
            HStack(alignment: .bottom) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.system(size: 22, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                    
                    Text(subtitle)
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.white.opacity(0.7))
                }
                
                Spacer()
                
                if showSeeAll {
                    Button(action: {
                        seeAllAction?()
                    }) {
                        HStack(spacing: 4) {
                            Text("See All")
                                .font(.system(size: 14, weight: .semibold))
                            Image(systemName: "arrow.right")
                                .font(.system(size: 12, weight: .semibold))
                        }
                        .foregroundStyle(
                            LinearGradient(
                                colors: [.white.opacity(0.8), .white.opacity(0.6)],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                    }
                }
            }
            .padding(.horizontal, 24)
            
            // Enhanced carousel
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(themes) { theme in
                        NavigationLink(destination: ContentView(selectedTheme: theme)) {
                            ModernThemeCard(theme: theme)
                        }
                    }
                }
                .padding(.horizontal, 24)
            }
        }
    }
}

// Modern theme card
struct ModernThemeCard: View {
    let theme: Theme
    @State private var isPressed = false
    
    var body: some View {
        ZStack {
            // Card background with glassmorphism
            RoundedRectangle(cornerRadius: 16)
                .fill(.ultraThinMaterial)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(
                            LinearGradient(
                                colors: [.white.opacity(0.2), .clear],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 1
                        )
                )
                .shadow(color: .black.opacity(0.3), radius: isPressed ? 5 : 10, x: 0, y: isPressed ? 2 : 5)
            
            VStack(spacing: 0) {
                // Image with modern styling
                Image(theme.image)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 140, height: 160)
                    .clipShape(
                        RoundedRectangle(cornerRadius: 16)
                    )
                    .overlay(
                        LinearGradient(
                            colors: [.clear, .black.opacity(0.3)],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                    )
                
                // Title overlay with glassmorphism
                ZStack {
                    RoundedRectangle(cornerRadius: 0)
                        .fill(.ultraThinMaterial)
                        .frame(height: 50)
                    
                    Text(theme.name)
                        .font(.system(size: 13, weight: .semibold, design: .rounded))
                        .foregroundColor(.white)
                        .lineLimit(2)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 8)
                }
                .clipShape(
                    RoundedRectangle(cornerRadius: 0)
                )
            }
        }
        .frame(width: 140, height: 210)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .scaleEffect(isPressed ? 0.95 : 1.0)
        .animation(.easeInOut(duration: 0.1), value: isPressed)
        .onLongPressGesture(minimumDuration: 0) { pressing in
            isPressed = pressing
        } perform: {}
    }
}

// Modern featured banner
struct ModernFeaturedBanner: View {
    @State private var isPressed = false
    
    var body: some View {
        ZStack {
            // Background image with overlay
            Image("HouseImage")
                .resizable()
                .scaledToFill()
                .frame(height: 200)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .overlay(
                    LinearGradient(
                        colors: [.clear, .black.opacity(0.7)],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                )
            
            // Content overlay
            VStack {
                HStack {
                    Spacer()
                    Text("NEW")
                        .font(.system(size: 12, weight: .bold))
                        .foregroundColor(.white)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(
                            Capsule()
                                .fill(
                                    LinearGradient(
                                        colors: [.purple, .pink],
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                        )
                        .shadow(color: .purple.opacity(0.5), radius: 8, x: 0, y: 4)
                }
                .padding(.top, 16)
                .padding(.trailing, 20)
                
                Spacer()
                
                HStack(alignment: .bottom) {
                    Image("DisneyLogo")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 40)
                    
                    Spacer()
                    
                    // Modern Try Now button
                    HStack(spacing: 8) {
                        Image(systemName: "play.fill")
                            .font(.system(size: 14, weight: .semibold))
                        Text("Try Now")
                            .font(.system(size: 16, weight: .semibold))
                    }
                    .foregroundColor(.white)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 12)
                    .background(
                        LinearGradient(
                            gradient: Gradient(colors: [.purple, .blue, .purple]),
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                        .clipShape(Capsule())
                    )
                    .shadow(color: .purple.opacity(0.5), radius: 12, x: 0, y: 6)
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 20)
            }
            
            // Modern border
            RoundedRectangle(cornerRadius: 20)
                .stroke(
                    LinearGradient(
                        colors: [.white.opacity(0.3), .clear],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: 1
                )
        }
        .shadow(color: .black.opacity(0.3), radius: isPressed ? 10 : 20, x: 0, y: isPressed ? 5 : 10)
        .scaleEffect(isPressed ? 0.98 : 1.0)
        .animation(.easeInOut(duration: 0.1), value: isPressed)
        .padding(.horizontal, 24)
        .onLongPressGesture(minimumDuration: 0) { pressing in
            isPressed = pressing
        } perform: {}
    }
}

struct AllThemesView: View {
    let themes: [Theme]
    let columns = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Modern gradient background
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color.black,
                        Color.black.opacity(0.95),
                        Color(red: 0.05, green: 0.05, blue: 0.1)
                    ]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea(.all)
                
                ScrollView(showsIndicators: false) {
                    LazyVGrid(columns: columns, spacing: 20) {
                        ForEach(themes) { theme in
                            NavigationLink(destination: ContentView(selectedTheme: theme)) {
                                ModernGridThemeCard(theme: theme)
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                    .padding(.bottom, 100)
                }
            }
            .navigationTitle("All Styles")
            .navigationBarTitleDisplayMode(.large)
            .toolbarBackground(.ultraThinMaterial, for: .navigationBar)
        }
    }
}

// Modern grid theme card for AllThemesView
struct ModernGridThemeCard: View {
    let theme: Theme
    @State private var isPressed = false
    
    var body: some View {
        VStack(spacing: 12) {
            ZStack {
                // Card background with glassmorphism
                RoundedRectangle(cornerRadius: 20)
                    .fill(.ultraThinMaterial)
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(
                                LinearGradient(
                                    colors: [.white.opacity(0.3), .clear],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ),
                                lineWidth: 1
                            )
                    )
                    .shadow(
                        color: theme.color.opacity(0.3),
                        radius: isPressed ? 8 : 15,
                        x: 0,
                        y: isPressed ? 4 : 8
                    )
                
                VStack(spacing: 12) {
                    // Image container
                    ZStack {
                        RoundedRectangle(cornerRadius: 16)
                            .fill(
                                LinearGradient(
                                    colors: [theme.color.opacity(0.3), theme.color.opacity(0.1)],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .frame(height: 120)
                        
                        Image(theme.image)
                            .resizable()
                            .scaledToFit()
                            .frame(height: 100)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                    }
                    
                    // Theme name
                    Text(theme.name)
                        .font(.system(size: 16, weight: .semibold, design: .rounded))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .lineLimit(2)
                }
                .padding(16)
            }
        }
        .scaleEffect(isPressed ? 0.95 : 1.0)
        .animation(.easeInOut(duration: 0.1), value: isPressed)
        .onLongPressGesture(minimumDuration: 0) { pressing in
            isPressed = pressing
        } perform: {}
    }
}

struct Theme: Identifiable {
    let id = UUID()
    let name: String
    let color: Color
    let image: String
    let logo: String?
}

#Preview {
    ThemeSelectionView()
}
