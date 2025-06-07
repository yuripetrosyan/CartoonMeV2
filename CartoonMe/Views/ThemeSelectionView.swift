//
//  ThemeSelectionView.swift
//  CartoonMe
//
//  Created by Yuri Petrosyan on 10/04/2025.
//

//do the next one for manga style, use a photo of a different person, and use other background colors
import SwiftUI

struct ThemeSelectionView: View {
    @State private var showAllThemes = false
    @Binding var hideTabBar: Bool
    let themes = [
        Theme(name: "Simpsons", color: .yellow, image: "SimpsonsImage", logo: nil),
        Theme(name: "Pixar Style", color: .yellow, image: "PixarImage", logo: nil),
        Theme(name: "Marvel Comic", color: .red, image: "MarvelImage", logo: nil),
        Theme(name: "Manga", color: .black, image: "MangaImage", logo: nil),
        Theme(name: "Studio Ghibli", color: .purple, image: "GhibliImage", logo: ""),
        Theme(name: "Anime Style", color: .pink, image: "AnimeImage", logo: ""),
        Theme(name: "Disney", color: .orange, image: "DisneyImage", logo: "DisneyLogo")
      
    ]
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Enhanced multi-layer gradient background
                LinearGradient(
                    colors: [
                        Color.black,
                        Color(red: 0.02, green: 0.02, blue: 0.08),
                        Color(red: 0.05, green: 0.03, blue: 0.12),
                        Color(red: 0.08, green: 0.05, blue: 0.15),
                        Color.black
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea(.all)
                
                // Dynamic ambient effects
                Circle()
                    .fill(
                        RadialGradient(
                            colors: [
                                .purple.opacity(0.15),
                                .purple.opacity(0.05),
                                .clear
                            ],
                            center: .center,
                            startRadius: 50,
                            endRadius: 200
                        )
                    )
                    .frame(width: 400, height: 400)
                    .offset(x: -100, y: -150)
                    .blur(radius: 50)
                
                Circle()
                    .fill(
                        RadialGradient(
                            colors: [
                                .blue.opacity(0.12),
                                .cyan.opacity(0.06),
                                .clear
                            ],
                            center: .center,
                            startRadius: 30,
                            endRadius: 150
                        )
                    )
                    .frame(width: 300, height: 300)
                    .offset(x: 150, y: 250)
                    .blur(radius: 40)
                
                Circle()
                    .fill(
                        RadialGradient(
                            colors: [
                                .pink.opacity(0.08),
                                .clear
                            ],
                            center: .center,
                            startRadius: 20,
                            endRadius: 100
                        )
                    )
                    .frame(width: 200, height: 200)
                    .offset(x: -120, y: 180)
                    .blur(radius: 35)
                
                ScrollView(showsIndicators: false) {
                    LazyVStack(spacing: 40) {
                        // Hidden NavigationLink for programmatic navigation
                        NavigationLink(destination: AllThemesView(themes: themes, hideTabBar: $hideTabBar), isActive: $showAllThemes) { EmptyView() }
                        
                        // Enhanced Header Section
                        VStack(spacing: 24) {
                            // Main title with sophisticated styling
                            VStack(spacing: 12) {
                                Text("Transform Your Style")
                                    .font(.system(size: 34, weight: .heavy, design: .rounded))
                                    .foregroundStyle(
                                        LinearGradient(
                                            colors: [
                                                .white,
                                                .white.opacity(0.95),
                                                .white.opacity(0.85)
                                            ],
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        )
                                    )
                                    .shadow(color: .black.opacity(0.4), radius: 8, x: 0, y: 4)
                                    .shadow(color: .purple.opacity(0.3), radius: 20, x: 0, y: 8)
                                
                                // Enhanced accent line with gradient
                                RoundedRectangle(cornerRadius: 3)
                                    .fill(
                                        LinearGradient(
                                            colors: [
                                                .purple.opacity(0.9),
                                                .blue.opacity(0.7),
                                                .pink.opacity(0.5),
                                                .cyan.opacity(0.3)
                                            ],
                                            startPoint: .leading,
                                            endPoint: .trailing
                                        )
                                    )
                                    .frame(width: 80, height: 4)
                                    .shadow(color: .purple.opacity(0.6), radius: 8, x: 0, y: 4)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 3)
                                            .fill(
                                                LinearGradient(
                                                    colors: [.white.opacity(0.3), .clear],
                                                    startPoint: .top,
                                                    endPoint: .bottom
                                                )
                                            )
                                            .frame(height: 2)
                                            .offset(y: -1)
                                    )
                            }
                            
                            // Enhanced subtitle
//                            Text("Choose from the collection of AI-powered cartoon styles")
//                                .font(.system(size: 17, weight: .medium, design: .rounded))
//                                .foregroundStyle(
//                                    LinearGradient(
//                                        colors: [
//                                            .white.opacity(0.8),
//                                            .white.opacity(0.6)
//                                        ],
//                                        startPoint: .top,
//                                        endPoint: .bottom
//                                    )
//                                )
//                                .multilineTextAlignment(.center)
//                                .lineLimit(2)
//                                .shadow(color: .black.opacity(0.3), radius: 4, x: 0, y: 2)
                        }
                        .padding(.horizontal, 28)
                 
                        // 🎯 Elegant Banner Ad Section
                        ElegantBannerAd()
                            .padding(.horizontal, 10)
                            .padding(.vertical, 5)
                        
                        // Enhanced Main Themes Carousel
                        CarouselSection(
                            title: "Most Popular",
                            subtitle: "Trending styles loved by creators",
                            themes: themes,
                            showSeeAll: true,
                            seeAllAction: { showAllThemes = true },
                            hideTabBar: $hideTabBar
                        )
                        
                        // Enhanced Featured Banner Carousel
                        VStack(spacing: 20) {
                            // Section header
                            HStack {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("Featured Collections")
                                        .font(.system(size: 22, weight: .bold, design: .rounded))
                                        .foregroundColor(.white)
                                    
                                    Text("Premium styles with special features")
                                        .font(.system(size: 14, weight: .medium))
                                        .foregroundColor(.white.opacity(0.6))
                                }
                                Spacer()
                            }
                            .padding(.horizontal, 24)
                            
                            // Enhanced banner carousel
                            FeaturedBannerCarousel(
                                featuredThemes: [
                                    Theme(name: "Disney", color: .orange, image: "DisneyImage", logo: "DisneyLogo"),
                                    Theme(name: "Studio Ghibli", color: .purple, image: "GhibliImage", logo: "")
                                ],
                                hideTabBar: $hideTabBar
                            )
                        }
                        
                        // Enhanced New Styles Carousel
                        CarouselSection(
                            title: "Fresh Arrivals",
                            subtitle: "Latest AI art styles just added",
                            themes: Array(themes.reversed()),
                            showSeeAll: true,
                            seeAllAction: { showAllThemes = true },
                            hideTabBar: $hideTabBar
                        )
                        
                        // Enhanced Browse All Section
                        VStack(spacing: 20) {
                            HStack {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("Explore All Styles")
                                        .font(.system(size: 24, weight: .bold, design: .rounded))
                                        .foregroundColor(.white)
                                    
                                    Text("Discover every transformation available")
                                        .font(.system(size: 14, weight: .medium))
                                        .foregroundColor(.white.opacity(0.6))
                                }
                                Spacer()
                            }
                            .padding(.horizontal, 24)
                            
                            // Enhanced browse all button
                            Button(action: { showAllThemes = true }) {
                                HStack(spacing: 16) {
                                    ZStack {
                                        Circle()
                                            .fill(
                                                LinearGradient(
                                                    colors: [
                                                        .purple.opacity(0.3),
                                                        .blue.opacity(0.2)
                                                    ],
                                                    startPoint: .topLeading,
                                                    endPoint: .bottomTrailing
                                                )
                                            )
                                            .frame(width: 44, height: 44)
                                        
                                        Image(systemName: "square.grid.2x2")
                                            .font(.system(size: 20, weight: .semibold))
                                            .foregroundColor(.white)
                                    }
                                    
                                    VStack(alignment: .leading, spacing: 2) {
                                        Text("Browse All \(themes.count) Styles")
                                            .font(.system(size: 18, weight: .semibold, design: .rounded))
                                            .foregroundColor(.white)
                                        
                                        Text("View complete collection")
                                            .font(.system(size: 14, weight: .medium))
                                            .foregroundColor(.white.opacity(0.7))
                                    }
                                    
                                    Spacer()
                                    
                                    Image(systemName: "arrow.right")
                                        .font(.system(size: 16, weight: .semibold))
                                        .foregroundColor(.white.opacity(0.8))
                                }
                                .padding(.horizontal, 24)
                                .padding(.vertical, 20)
                                .background(
                                    RoundedRectangle(cornerRadius: 20, style: .continuous)
                                        .fill(.ultraThinMaterial)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 20, style: .continuous)
                                                .stroke(
                                                    LinearGradient(
                                                        colors: [
                                                            .white.opacity(0.2),
                                                            .clear,
                                                            .purple.opacity(0.1)
                                                        ],
                                                        startPoint: .topLeading,
                                                        endPoint: .bottomTrailing
                                                    ),
                                                    lineWidth: 1
                                                )
                                        )
                                        .shadow(color: .black.opacity(0.08), radius: 10, x: 0, y: 4)
                                        .shadow(color: .purple.opacity(0.03), radius: 15, x: 0, y: 6)
                                )
                            }
                            .padding(.horizontal, 24)
                        }
                        
                        // Bottom spacer
                        Spacer()
                            .frame(height: 60)
                    }
                    .padding(.top, 12)
                }
            }
            .navigationBarHidden(true)
        }
        .onAppear {
            hideTabBar = false
        }
    }
}

// Enhanced CarouselSection with modern styling
struct CarouselSection: View {
    let title: String
    let subtitle: String
    let themes: [Theme]
    let showSeeAll: Bool
    let seeAllAction: () -> Void
    @Binding var hideTabBar: Bool
    
    var body: some View {
        VStack(spacing: 20) {
            // Enhanced section header
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.system(size: 22, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                    
                    Text(subtitle)
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.white.opacity(0.6))
                }
                
                Spacer()
                
                if showSeeAll {
                    Button(action: seeAllAction) {
                        HStack(spacing: 6) {
                            Text("See All")
                                .font(.system(size: 15, weight: .semibold))
                            Image(systemName: "arrow.right")
                                .font(.system(size: 12, weight: .semibold))
                        }
                        .foregroundColor(.white.opacity(0.8))
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .background(
                            Capsule()
                                .fill(.ultraThinMaterial)
                                .overlay(
                                    Capsule()
                                        .stroke(.white.opacity(0.15), lineWidth: 1)
                                )
                        )
                        .shadow(color: .black.opacity(0.08), radius: 4, x: 0, y: 2)
                    }
                }
            }
            .padding(.horizontal, 24)
            
            // Enhanced theme cards carousel
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(themes, id: \.name) { theme in
                        NavigationLink(destination: ContentView(selectedTheme: theme)
                            .onAppear { hideTabBar = true }
                            .onDisappear { hideTabBar = false }
                        ) {
                            EnhancedThemeCard(theme: theme)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
                .padding(.horizontal, 24)
            }
        }
    }
}

// Enhanced Theme Card with sophisticated styling
struct EnhancedThemeCard: View {
    let theme: Theme
    
    var body: some View {
        VStack(spacing: 0) {
            // Enhanced image container
            ZStack {
//                // Multi-layer background
//                RoundedRectangle(cornerRadius: 20, style: .continuous)
//                    .fill(.ultraThinMaterial)
//                    .frame(width: 160, height: 200)
//                    .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 4)
//                    .shadow(color: theme.color.opacity(0.05), radius: 12, x: 0, y: 6)
                
                // Theme image
                Image(theme.image)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 150, height: 200)
                    .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                
                // Gradient overlay for text readability
                LinearGradient(
                    colors: [
                        .clear,
                        .clear,
                        .black.opacity(0.1),
                        .black.opacity(0.5)
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .frame(width: 150, height: 200)
                .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                
                // Theme label
                VStack {
                    Spacer()
                    HStack {
                        VStack(alignment: .leading, spacing: 2) {
                            Text(theme.name)
                                .font(.system(size: 14, weight: .bold, design: .rounded))
                                .foregroundColor(.white)
                                .shadow(color: .black.opacity(0.5), radius: 2, x: 0, y: 1)
                        }
                      //  Spacer()
                    }
                    .padding(.horizontal, 12)
                    .padding(.bottom, 5)
                }
                .frame(width: 140, height: 180)
            }
        }
        .scaleEffect(1.0)
        .animation(.easeInOut(duration: 0.2), value: theme.name)
    }
}

// Featured Banner Carousel
struct FeaturedBannerCarousel: View {
    let featuredThemes: [Theme]
    @Binding var hideTabBar: Bool
    @State private var currentIndex = 0
    
    var body: some View {
        VStack(spacing: 12) {
            // Carousel
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(Array(featuredThemes.enumerated()), id: \.element.id) { index, theme in
                        NavigationLink(destination: ContentView(selectedTheme: theme)
                            .onAppear { hideTabBar = true }
                            .onDisappear { hideTabBar = false }) {
                            FeaturedBannerCard(theme: theme, isFirst: index == 0)
                        }
                        .frame(width: UIScreen.main.bounds.width - 48)
                    }
                }
                .padding(.horizontal, 24)
                .scrollTargetLayout()
            }
            .scrollTargetBehavior(.viewAligned)
            .scrollIndicators(.hidden)
            .animation(.easeInOut(duration: 0.3), value: currentIndex)
            
            // Page indicator
            HStack(spacing: 8) {
                ForEach(0..<featuredThemes.count, id: \.self) { index in
                    Circle()
                        .fill(index == currentIndex ? Color.white : Color.white.opacity(0.4))
                        .frame(width: 8, height: 8)
                        .scaleEffect(index == currentIndex ? 1.2 : 1.0)
                        .animation(.easeInOut(duration: 0.2), value: currentIndex)
                }
            }
            .padding(.bottom, 8)
        }
    }
}

// Individual Featured Banner Card
struct FeaturedBannerCard: View {
    let theme: Theme
    let isFirst: Bool
    @State private var isPressed = false
    
    var body: some View {
        ZStack {
            // Background image with overlay
            Image(theme.image)
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
                    if isFirst {
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
                    } else {
                        Text("FEATURED")
                            .font(.system(size: 12, weight: .bold))
                            .foregroundColor(.white)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(
                                Capsule()
                                    .fill(
                                        LinearGradient(
                                            colors: [theme.color.opacity(0.8), theme.color],
                                            startPoint: .leading,
                                            endPoint: .trailing
                                        )
                                    )
                            )
                            .shadow(color: theme.color.opacity(0.5), radius: 8, x: 0, y: 4)
                    }
                }
                .padding(.top, 16)
                .padding(.trailing, 20)
                
                Spacer()
                
                HStack(alignment: .bottom) {
                    VStack(alignment: .leading, spacing: 4) {
                        if let logo = theme.logo, !logo.isEmpty {
                            Image(logo)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(height: 40)
                        } else {
                            Text(theme.name)
                                .font(.system(size: 22, weight: .bold, design: .rounded))
                                .foregroundColor(.white)
                                .shadow(color: .black.opacity(0.3), radius: 4, x: 0, y: 2)
                        }
                    }
                    
                    Spacer()
                    
                    // Modern Try Now button
                    HStack(spacing: 6) {
                        Image(systemName: "play.fill")
                            .font(.system(size: 12, weight: .semibold))
                        Text("Try Now")
                            .font(.system(size: 14, weight: .semibold))
                    }
                    .foregroundColor(.white)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 10)
                    .background(
                        LinearGradient(
                            gradient: Gradient(colors: [.purple, .blue, .purple]),
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                        .clipShape(Capsule())
                    )
                    .shadow(color: .purple.opacity(0.5), radius: 10, x: 0, y: 5)
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
    }
}

struct AllThemesView: View {
    let themes: [Theme]
    @Binding var hideTabBar: Bool
    let columns = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]
    
    var body: some View {
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
                        NavigationLink(destination: ContentView(selectedTheme: theme)
                            .onAppear { hideTabBar = true }
                            .onDisappear { hideTabBar = false }) {
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

    }
}



// Enhanced background components for visual interest
struct MeshGradientBackground: View {
    @State private var animationPhase = 0.0
    
    var body: some View {
        ZStack {
            // Animated mesh gradients
            ForEach(0..<3, id: \.self) { index in
                Circle()
                    .fill(
                        RadialGradient(
                            colors: gradientColors(for: index),
                            center: .center,
                            startRadius: 50,
                            endRadius: 200
                        )
                    )
                    .frame(width: 300, height: 300)
                    .offset(
                        x: offsetX(for: index),
                        y: offsetY(for: index)
                    )
                    .blur(radius: 60)
                    .animation(
                        .easeInOut(duration: Double.random(in: 8...12))
                        .repeatForever(autoreverses: true)
                        .delay(Double(index) * 2),
                        value: animationPhase
                    )
            }
        }
        .onAppear {
            animationPhase = 1.0
        }
    }
    
    private func gradientColors(for index: Int) -> [Color] {
        switch index {
        case 0: return [.purple.opacity(0.6), .blue.opacity(0.4), .clear]
        case 1: return [.pink.opacity(0.5), .purple.opacity(0.3), .clear]
        case 2: return [.blue.opacity(0.4), .cyan.opacity(0.3), .clear]
        default: return [.purple.opacity(0.3), .clear]
        }
    }
    
    private func offsetX(for index: Int) -> CGFloat {
        let baseOffset: CGFloat = index == 0 ? -100 : index == 1 ? 100 : 0
        return baseOffset + (animationPhase * CGFloat.random(in: -50...50))
    }
    
    private func offsetY(for index: Int) -> CGFloat {
        let baseOffset: CGFloat = index == 0 ? -150 : index == 1 ? 200 : 100
        return baseOffset + (animationPhase * CGFloat.random(in: -30...30))
    }
}

struct FloatingElements: View {
    @State private var rotationAngle: Double = 0
    @State private var floatingOffset: CGFloat = 0
    
    var body: some View {
        ZStack {
            // Floating geometric shapes
            ForEach(0..<8, id: \.self) { index in
                GeometricShape(index: index)
                    .offset(
                        x: shapeOffsetX(for: index),
                        y: shapeOffsetY(for: index) + floatingOffset
                    )
                    .rotationEffect(.degrees(rotationAngle + Double(index * 45)))
                    .animation(
                        .easeInOut(duration: Double.random(in: 6...10))
                        .repeatForever(autoreverses: true)
                        .delay(Double(index) * 0.5),
                        value: floatingOffset
                    )
                    .animation(
                        .linear(duration: Double.random(in: 20...30))
                        .repeatForever(autoreverses: false),
                        value: rotationAngle
                    )
            }
        }
        .onAppear {
            floatingOffset = 20
            rotationAngle = 360
        }
    }
    
    private func shapeOffsetX(for index: Int) -> CGFloat {
        let positions: [CGFloat] = [-120, 150, -80, 100, -150, 120, -100, 80]
        return positions[index % positions.count]
    }
    
    private func shapeOffsetY(for index: Int) -> CGFloat {
        let positions: [CGFloat] = [-200, -100, 50, 150, -150, 250, 300, -50]
        return positions[index % positions.count]
    }
}

struct GeometricShape: View {
    let index: Int
    
    var body: some View {
        Group {
            switch index % 4 {
            case 0:
                Circle()
                    .stroke(shapeColor, lineWidth: 2)
                    .frame(width: shapeSize, height: shapeSize)
            case 1:
                RoundedRectangle(cornerRadius: 8)
                    .stroke(shapeColor, lineWidth: 2)
                    .frame(width: shapeSize, height: shapeSize)
            case 2:
                Diamond()
                    .stroke(shapeColor, lineWidth: 2)
                    .frame(width: shapeSize, height: shapeSize)
            default:
                Triangle()
                    .stroke(shapeColor, lineWidth: 2)
                    .frame(width: shapeSize, height: shapeSize)
            }
        }
    }
    
    private var shapeColor: Color {
        let colors: [Color] = [
            .white.opacity(0.3),
            .purple.opacity(0.4),
            .blue.opacity(0.3),
            .pink.opacity(0.3),
            .cyan.opacity(0.3)
        ]
        return colors[index % colors.count]
    }
    
    private var shapeSize: CGFloat {
        CGFloat.random(in: 20...40)
    }
}

// Custom shapes for floating elements
struct Diamond: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.midX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.midY))
        path.addLine(to: CGPoint(x: rect.midX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.midY))
        path.closeSubpath()
        return path
    }
}

struct Triangle: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.midX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        path.closeSubpath()
        return path
    }
}

#Preview {
    @State var hideTabBar = false
    return ThemeSelectionView(hideTabBar: $hideTabBar)
}
