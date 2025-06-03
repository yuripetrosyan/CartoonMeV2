import SwiftUI

struct MainTabBarView: View {
    enum Tab: Int, CaseIterable {
        case explore, account, aiVideo, aiHeadshots
        
        var title: String {
            switch self {
            case .explore: return "Cartoon"
            case .account: return "Trends"
            case .aiVideo: return "Video"
            case .aiHeadshots: return "Headshot"
            }
        }
        
        var icon: String {
            switch self {
            case .explore: return "sparkles"
            case .account: return "person.circle"
            case .aiVideo: return "video.fill"
            case .aiHeadshots: return "person.crop.square.filled.and.at.rectangle"
            }
        }
        
        var selectedIcon: String {
            switch self {
            case .explore: return "sparkles"
            case .account: return "person.circle.fill"
            case .aiVideo: return "video.fill"
            case .aiHeadshots: return "person.crop.square.filled.and.at.rectangle.fill"
            }
        }
        
        var accentColor: Color {
            switch self {
            case .explore: return .purple
            case .account: return .blue
            case .aiVideo: return .pink
            case .aiHeadshots: return .orange
            }
        }
    }
    
    @State private var selectedTab: Tab = .explore
    @State private var tabBarOffset: CGFloat = 0
    @State private var isPressed: [Tab: Bool] = [:]
    @State private var hideTabBar: Bool = false
    
    var body: some View {
        ZStack(alignment: .bottom) {
            // Main content area
            Group {
                switch selectedTab {
                case .explore:
                    NavigationStack {
                        ThemeSelectionView(hideTabBar: $hideTabBar)
                    }
                case .account:
                    TrendsView()
                case .aiVideo:
                    AIVideoPlaceholderView()
                case .aiHeadshots:
                    AIHeadshotsPlaceholderView()
                }
            }
            .edgesIgnoringSafeArea(.all)
            
            // Modern iOS 19 Style Tab Bar
            if !hideTabBar {
                ModernTabBar(selectedTab: $selectedTab, isPressed: $isPressed)
                    .offset(y: tabBarOffset)
                    .animation(.spring(response: 0.5, dampingFraction: 0.8), value: tabBarOffset)
                    .transition(.move(edge: .bottom).combined(with: .opacity))
            }
        }
        .onAppear {
            // Initialize pressed states
            for tab in Tab.allCases {
                isPressed[tab] = false
            }
        }
    }
}

struct ModernTabBar: View {
    @Binding var selectedTab: MainTabBarView.Tab
    @Binding var isPressed: [MainTabBarView.Tab: Bool]
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(MainTabBarView.Tab.allCases, id: \.self) { tab in
                ModernTabBarItem(
                    tab: tab,
                    isSelected: selectedTab == tab,
                    isPressed: isPressed[tab] ?? false
                ) {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                        selectedTab = tab
                    }
                } onPressChange: { pressing in
                    withAnimation(.easeInOut(duration: 0.1)) {
                        isPressed[tab] = pressing
                    }
                }
            }
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 11)
        .background(
            // Advanced Glassmorphism Background
            ZStack {
                // Base material
                RoundedRectangle(cornerRadius: 30, style: .continuous)
                    .fill(.ultraThinMaterial)
                 
                  
                
                // Gradient overlay for depth
                RoundedRectangle(cornerRadius: 50, style: .continuous)
                    .fill(
                        LinearGradient(
                            colors: [
                                .white.opacity(0.15),
                                .white.opacity(0.05),
                                .clear
                            ],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                
                // Subtle border
                RoundedRectangle(cornerRadius: 50, style: .continuous)
                    .stroke(
                        LinearGradient(
                            colors: [
                                .white.opacity(0.4),
                                .white.opacity(0.1),
                                .clear
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 0.5
                    )
            }
        )
        .shadow(
            color: .black.opacity(0.15),
            radius: 20,
            x: 0,
            y: 10
        )
        .shadow(
            color: .black.opacity(0.1),
            radius: 1,
            x: 0,
            y: 1
        )
        .padding(.horizontal, 37)
        .padding(.bottom, -15) // Adjusted for home indicator
    }
}

// Individual Tab Bar Item
struct ModernTabBarItem: View {
    let tab: MainTabBarView.Tab
    let isSelected: Bool
    let isPressed: Bool
    let action: () -> Void
    let onPressChange: (Bool) -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 6) {
                // Icon
                Image(systemName: isSelected ? tab.selectedIcon : tab.icon)
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundStyle(
                        isSelected
                        ? LinearGradient(
                            colors: [tab.accentColor, tab.accentColor.opacity(0.8)],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                        : LinearGradient(
                            colors: [.white.opacity(0.8), .white.opacity(0.6)],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .symbolEffect(.bounce, value: isSelected)
                
                // Label
                Text(tab.title)
                    .font(.system(size: 10, weight: .semibold, design: .rounded))
                    .foregroundStyle(
                        isSelected
                        ? LinearGradient(
                            colors: [.white, .white.opacity(0.9)],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                        : LinearGradient(
                            colors: [.white.opacity(0.7), .white.opacity(0.5)],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .animation(.easeInOut(duration: 0.2), value: isSelected)
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 0)
            .background(
                // Selection indicator background - sized to content
                Group {
                    if isSelected {
                    RoundedRectangle(cornerRadius: 25, style: .continuous)
                            .fill(
                                LinearGradient(
                                    colors: [
                                        tab.accentColor.opacity(0.3),
                                        tab.accentColor.opacity(0.1)
                                    ],
                                    startPoint: .top,
                                    endPoint: .bottom
                                )
                            )
                            .overlay(
                                RoundedRectangle(cornerRadius:35, style: .continuous)
                                    .stroke(tab.accentColor.opacity(0.4), lineWidth: 1)
                            )
                            .shadow(
                                color: tab.accentColor.opacity(0.3),
                                radius: 8,
                                x: 0,
                                y: 4
                            )
                            .padding(-5)
                    }
                }
            )
            .frame(maxWidth: .infinity)
            .scaleEffect(isPressed ? 0.9 : 1.0)
            .animation(.spring(response: 0.2, dampingFraction: 0.8), value: isPressed)
        }
        .onLongPressGesture(minimumDuration: 0, maximumDistance: .infinity) { pressing in
            onPressChange(pressing)
        } perform: {}
        .sensoryFeedback(.impact(flexibility: .soft, intensity: 0.5), trigger: isSelected)
    }
}

// Placeholder Views with modern styling
struct AccountPlaceholderView: View {
    var body: some View {
        ZStack {
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
            
            VStack(spacing: 20) {
                Image(systemName: "person.circle.fill")
                    .font(.system(size: 80))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [.blue, .blue.opacity(0.7)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                
                VStack(spacing: 8) {
                    Text("Account")
                        .font(.system(size: 28, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                    
                    Text("Manage your profile and settings")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.white.opacity(0.7))
                        .multilineTextAlignment(.center)
                }
            }
        }
    }
}

struct AIVideoPlaceholderView: View {
    var body: some View {
        ZStack {
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
            
            VStack(spacing: 20) {
                Image(systemName: "video.fill")
                    .font(.system(size: 80))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [.pink, .pink.opacity(0.7)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                
                VStack(spacing: 8) {
                    Text("AI Video")
                        .font(.system(size: 28, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                    
                    Text("Create amazing AI-powered videos")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.white.opacity(0.7))
                        .multilineTextAlignment(.center)
                }
            }
        }
    }
}

struct AIHeadshotsPlaceholderView: View {
    var body: some View {
        ZStack {
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
            
            VStack(spacing: 20) {
                Image(systemName: "person.crop.square.filled.and.at.rectangle.fill")
                    .font(.system(size: 80))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [.orange, .orange.opacity(0.7)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                
                VStack(spacing: 8) {
                    Text("Headshots")
                        .font(.system(size: 28, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                    
                    Text("Generate professional AI headshots")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.white.opacity(0.7))
                        .multilineTextAlignment(.center)
                }
            }
        }
    }
}

#Preview {
    MainTabBarView()
} 
