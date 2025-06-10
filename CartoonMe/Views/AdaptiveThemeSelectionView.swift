import SwiftUI

struct AdaptiveThemeSelectionView: View {
    @Binding var hideTabBar: Bool
    @State private var selectedTheme: String? = nil
    @State private var showImagePicker = false
    @State private var scrollPosition: CGPoint = .zero
    
    private let deviceType = DeviceType.current
    private let layout = AdaptiveLayout()
    
    var body: some View {
        if deviceType == .iPhone {
            // iPhone: Use existing ThemeSelectionView
            CartoonView(hideTabBar: $hideTabBar)
        } else {
            // iPad & visionOS: Enhanced adaptive UI
            adaptiveThemeView
        }
    }
    
    private var adaptiveThemeView: some View {
        GeometryReader { geometry in
            ScrollView {
                LazyVStack(spacing: layout.largeSpacing) {
                    // Hero Header
                    heroHeader(geometry: geometry)
                    
                    // Popular Themes Section
                    popularThemesSection
                    
                    // Trending Styles Section  
                    trendingStylesSection
                    
                    // Footer Spacing
                    Spacer()
                        .frame(height: layout.largeSpacing)
                }
                .padding(.horizontal, layout.mediumSpacing)
            }
            .background(
                // Dynamic background with parallax effect
                adaptiveBackground
            )
        }
        .sheet(isPresented: $showImagePicker) {
            // TODO: Present ImagePicker for selected theme
            Text("Image Picker")
        }
    }
    
    private func heroHeader(geometry: GeometryProxy) -> some View {
        VStack(spacing: layout.mediumSpacing) {
            // Main Title
            VStack(spacing: layout.smallSpacing) {
                Text("Transform Yourself")
                    .font(.system(
                        size: deviceType == .visionOS ? 48 : 36,
                        weight: .bold,
                        design: .rounded
                    ))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [.white, .white.opacity(0.9)],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .multilineTextAlignment(.center)
                
                Text("Choose your artistic style")
                    .font(.system(
                        size: deviceType == .visionOS ? 22 : 18,
                        weight: .medium,
                        design: .rounded
                    ))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [.white.opacity(0.8), .white.opacity(0.6)],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .multilineTextAlignment(.center)
            }
            
            // Quick Upload Button
            Button(action: {
                showImagePicker = true
            }) {
                HStack(spacing: layout.mediumSpacing) {
                    Image(systemName: "camera.fill")
                        .font(.system(size: deviceType == .visionOS ? 20 : 18, weight: .semibold))
                    
                    Text("Quick Upload")
                        .font(.system(
                            size: deviceType == .visionOS ? 18 : 16,
                            weight: .semibold,
                            design: .rounded
                        ))
                }
                .foregroundColor(.white)
                .padding(.horizontal, layout.largeSpacing)
                .padding(.vertical, layout.mediumSpacing)
                .background(
                    ZStack {
                        AdaptiveMaterial(.regular, for: deviceType)
                        
                        LinearGradient(
                            colors: [.purple, .blue],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                        .opacity(0.8)
                    }
                )
                .clipShape(RoundedRectangle(cornerRadius: layout.cornerRadius, style: .continuous))
                .shadow(color: .purple.opacity(0.3), radius: 15, x: 0, y: 8)
            }
            .adaptiveHover(for: deviceType)
        }
        .padding(.top, layout.largeSpacing)
        .frame(width: geometry.size.width * 0.8)
        .frame(maxWidth: deviceType == .visionOS ? 800 : 600)
    }
    
    private var popularThemesSection: some View {
        VStack(alignment: .leading, spacing: layout.mediumSpacing) {
            sectionHeader(title: "Popular Styles", subtitle: "Most loved transformations")
            
            adaptiveThemeGrid(themes: popularThemes)
        }
    }
    
    private var trendingStylesSection: some View {
        VStack(alignment: .leading, spacing: layout.mediumSpacing) {
            sectionHeader(title: "Trending Now", subtitle: "Hot new artistic styles")
            
            adaptiveThemeGrid(themes: trendingThemes)
        }
    }
    
    private func sectionHeader(title: String, subtitle: String) -> some View {
        VStack(alignment: .leading, spacing: layout.smallSpacing) {
            Text(title)
                .font(.system(
                    size: deviceType == .visionOS ? 32 : 28,
                    weight: .bold,
                    design: .rounded
                ))
                .foregroundStyle(
                    LinearGradient(
                        colors: [.white, .white.opacity(0.9)],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
            
            Text(subtitle)
                .font(.system(
                    size: deviceType == .visionOS ? 18 : 16,
                    weight: .medium,
                    design: .rounded
                ))
                .foregroundStyle(
                    LinearGradient(
                        colors: [.white.opacity(0.7), .white.opacity(0.5)],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private func adaptiveThemeGrid(themes: [ThemeItem]) -> some View {
        LazyVGrid(
            columns: Array(repeating: GridItem(.flexible(), spacing: layout.mediumSpacing), count: layout.themeGridColumns),
            spacing: layout.mediumSpacing
        ) {
            ForEach(themes, id: \.id) { theme in
                AdaptiveThemeCard(
                    theme: theme,
                    isSelected: selectedTheme == theme.id,
                    deviceType: deviceType
                ) {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        selectedTheme = theme.id
                        showImagePicker = true
                    }
                }
            }
        }
    }
    
    private var adaptiveBackground: some View {
        ZStack {
            // Base gradient
            LinearGradient(
                colors: [
                    Color.black,
                    Color(red: 0.02, green: 0.02, blue: 0.08),
                    Color(red: 0.05, green: 0.03, blue: 0.12),
                    Color.black
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            
            // Animated particles for visionOS
            if deviceType == .visionOS {
                ForEach(0..<20) { index in
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: [.purple.opacity(0.1), .blue.opacity(0.05)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: CGFloat.random(in: 40...80))
                        .position(
                            x: CGFloat.random(in: 0...UIScreen.main.bounds.width),
                            y: CGFloat.random(in: 0...UIScreen.main.bounds.height)
                        )
                        .blur(radius: 20)
                        .animation(
                            .easeInOut(duration: Double.random(in: 3...8))
                            .repeatForever(autoreverses: true),
                            value: UUID()
                        )
                }
            }
        }
        .ignoresSafeArea()
    }
    
    // Sample data
    private var popularThemes: [ThemeItem] {
        [
            ThemeItem(id: "simpsons", name: "Simpsons", imageName: "SimpsonsImage"),
            ThemeItem(id: "pixar", name: "Pixar", imageName: "PixarImage"),
            ThemeItem(id: "marvel", name: "Marvel", imageName: "MarvelImage"),
            ThemeItem(id: "disney", name: "Disney", imageName: "DisneyImage"),
            ThemeItem(id: "anime", name: "Anime", imageName: "AnimeImage"),
            ThemeItem(id: "manga", name: "Manga", imageName: "MangaImage")
        ]
    }
    
    private var trendingThemes: [ThemeItem] {
        [
            ThemeItem(id: "ghibli", name: "Studio Ghibli", imageName: "GhibliImage"),
            ThemeItem(id: "cyberpunk", name: "Cyberpunk", imageName: "CyberpunkImage"),
            ThemeItem(id: "barbie", name: "Barbie", imageName: "BarbieBoxImage"),
            ThemeItem(id: "pokemon", name: "Pokemon Card", imageName: "PokemonCardImage")
        ]
    }
}

struct ThemeItem {
    let id: String
    let name: String
    let imageName: String
}

struct AdaptiveThemeCard: View {
    let theme: ThemeItem
    let isSelected: Bool
    let deviceType: DeviceType
    let action: () -> Void
    
    @State private var isPressed = false
    @State private var isHovered = false
    
    private let layout = AdaptiveLayout()
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: layout.smallSpacing) {
                // Theme Image
                Image(theme.imageName)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(
                        width: layout.themeCardSize.width,
                        height: layout.themeCardSize.height * 0.75
                    )
                    .clipShape(RoundedRectangle(cornerRadius: layout.cornerRadius, style: .continuous))
                    .overlay(
                        RoundedRectangle(cornerRadius: layout.cornerRadius, style: .continuous)
                            .stroke(
                                LinearGradient(
                                    colors: [.white.opacity(0.2), .clear],
                                    startPoint: .top,
                                    endPoint: .bottom
                                ),
                                lineWidth: 1
                            )
                    )
                
                // Theme Name
                Text(theme.name)
                    .font(.system(
                        size: deviceType == .visionOS ? 18 : 16,
                        weight: .semibold,
                        design: .rounded
                    ))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [.white, .white.opacity(0.8)],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .multilineTextAlignment(.center)
            }
            .frame(
                width: layout.themeCardSize.width,
                height: layout.themeCardSize.height
            )
            .background(
                ZStack {
                    AdaptiveMaterial(.regular, for: deviceType)
                    
                    if isSelected {
                        LinearGradient(
                            colors: [.purple.opacity(0.3), .blue.opacity(0.2)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    }
                }
            )
            .clipShape(RoundedRectangle(cornerRadius: layout.cornerRadius, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: layout.cornerRadius, style: .continuous)
                    .stroke(
                        isSelected
                        ? LinearGradient(
                            colors: [.purple, .blue],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                        : LinearGradient(
                            colors: [.white.opacity(0.1), .clear],
                            startPoint: .top,
                            endPoint: .bottom
                        ),
                        lineWidth: isSelected ? 2 : 1
                    )
            )
        }
        .buttonStyle(PlainButtonStyle())
        .scaleEffect(isPressed ? 0.95 : (isHovered ? 1.05 : 1.0))
        .shadow(
            color: isSelected ? .purple.opacity(0.3) : .black.opacity(0.2),
            radius: isHovered ? 20 : 10,
            x: 0,
            y: isHovered ? 15 : 5
        )
        .animation(.easeInOut(duration: 0.2), value: isSelected)
        .animation(.easeInOut(duration: 0.1), value: isPressed)
        .animation(.easeInOut(duration: 0.2), value: isHovered)
        .onHover { hovering in
            if deviceType.isLargeScreen {
                isHovered = hovering
            }
        }
        .onLongPressGesture(minimumDuration: 0, maximumDistance: .infinity) { pressing in
            isPressed = pressing
        } perform: {}
        .sensoryFeedback(.impact(flexibility: .soft, intensity: 0.3), trigger: isSelected)
    }
} 
