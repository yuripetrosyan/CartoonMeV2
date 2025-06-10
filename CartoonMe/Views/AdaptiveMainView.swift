import SwiftUI

struct AdaptiveMainView: View {
    @State private var selectedTab: MainTabBarView.Tab = .explore
    @State private var hideTabBar: Bool = false
    private let deviceType = DeviceType.current
    private let layout = AdaptiveLayout()
    
    var body: some View {
        Group {
            if layout.usesSidebarNavigation {
                // iPad & visionOS: Sidebar Navigation
                AdaptiveSidebarView(selectedTab: $selectedTab, hideTabBar: $hideTabBar)
            } else {
                // iPhone: Keep existing MainTabBarView
                MainTabBarView()
            }
        }
    }
}

struct AdaptiveSidebarView: View {
    @Binding var selectedTab: MainTabBarView.Tab
    @Binding var hideTabBar: Bool
    private let deviceType = DeviceType.current
    private let layout = AdaptiveLayout()
    
    var body: some View {
        NavigationSplitView {
            // Sidebar
            AdaptiveSidebar(selectedTab: $selectedTab)
        } detail: {
            // Main content
            AdaptiveContentView(selectedTab: selectedTab, hideTabBar: $hideTabBar)
        }
        .navigationSplitViewStyle(.balanced)
    }
}

struct AdaptiveSidebar: View {
    @Binding var selectedTab: MainTabBarView.Tab
    private let deviceType = DeviceType.current
    private let layout = AdaptiveLayout()
    
    var body: some View {
        VStack(spacing: 0) {
            // App Header
            VStack(spacing: layout.smallSpacing) {
                Image(systemName: "sparkles")
                    .font(.system(size: deviceType == .visionOS ? 40 : 32, weight: .bold))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [.purple, .blue, .pink],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .shadow(color: .purple.opacity(0.3), radius: 8, x: 0, y: 4)
                
                Text("CartoonMe")
                    .font(.system(size: deviceType == .visionOS ? 28 : 24, weight: .bold, design: .rounded))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [.white, .white.opacity(0.9)],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
            }
            .padding(.top, layout.largeSpacing)
            .padding(.bottom, layout.mediumSpacing)
            
            // Navigation Items
            LazyVStack(spacing: layout.smallSpacing) {
                ForEach(MainTabBarView.Tab.allCases, id: \.self) { tab in
                    AdaptiveSidebarItem(
                        tab: tab,
                        isSelected: selectedTab == tab,
                        deviceType: deviceType
                    ) {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            selectedTab = tab
                        }
                    }
                }
            }
            .padding(.horizontal, layout.mediumSpacing)
            
            Spacer()
            
            // Footer
            VStack(spacing: layout.smallSpacing) {
                Divider()
                    .background(.white.opacity(0.2))
                
                Text("Version 1.0")
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.6))
            }
            .padding(.horizontal, layout.mediumSpacing)
            .padding(.bottom, layout.mediumSpacing)
        }
        .frame(minWidth: deviceType == .visionOS ? 280 : 240)
        .background(
            // Enhanced sidebar background
            LinearGradient(
                colors: [
                    Color.black.opacity(0.95),
                    Color(red: 0.05, green: 0.05, blue: 0.1),
                    Color(red: 0.1, green: 0.08, blue: 0.15)
                ],
                startPoint: .top,
                endPoint: .bottom
            )
        )
    }
}

struct AdaptiveSidebarItem: View {
    let tab: MainTabBarView.Tab
    let isSelected: Bool
    let deviceType: DeviceType
    let action: () -> Void
    
    @State private var isPressed = false
    @State private var isHovered = false
    
    private let layout = AdaptiveLayout()
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: layout.mediumSpacing) {
                // Icon
                Image(systemName: isSelected ? tab.selectedIcon : tab.icon)
                    .font(.system(
                        size: deviceType == .visionOS ? 22 : 20,
                        weight: .semibold
                    ))
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
                    .frame(width: deviceType == .visionOS ? 28 : 24)
                
                // Title
                Text(tab.title)
                    .font(.system(
                        size: deviceType == .visionOS ? 18 : 16,
                        weight: .semibold,
                        design: .rounded
                    ))
                    .foregroundStyle(
                        isSelected
                        ? LinearGradient(
                            colors: [.white, .white.opacity(0.9)],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                        : LinearGradient(
                            colors: [.white.opacity(0.8), .white.opacity(0.6)],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                
                Spacer()
                
                // Selection indicator
                if isSelected {
                    Circle()
                        .fill(tab.accentColor)
                        .frame(width: 6, height: 6)
                        .shadow(color: tab.accentColor.opacity(0.6), radius: 4, x: 0, y: 2)
                }
            }
            .padding(.horizontal, layout.mediumSpacing)
            .padding(.vertical, layout.mediumSpacing)
            .background(
                RoundedRectangle(cornerRadius: layout.cornerRadius, style: .continuous)
                    .fill(
                        isSelected
                        ? LinearGradient(
                            colors: [
                                tab.accentColor.opacity(0.2),
                                tab.accentColor.opacity(0.1)
                            ],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                        : (isHovered
                           ? LinearGradient(
                            colors: [.white.opacity(0.08), .white.opacity(0.04)],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                           : LinearGradient(colors: [.clear], startPoint: .top, endPoint: .bottom))
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: layout.cornerRadius, style: .continuous)
                            .stroke(
                                isSelected
                                ? tab.accentColor.opacity(0.3)
                                : .clear,
                                lineWidth: 1
                            )
                    )
            )
        }
        .buttonStyle(PlainButtonStyle())
        .scaleEffect(isPressed ? 0.95 : 1.0)
        .shadow(
            color: isSelected ? tab.accentColor.opacity(0.2) : .clear,
            radius: 8,
            x: 0,
            y: 4
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
        .sensoryFeedback(.impact(flexibility: .soft, intensity: 0.5), trigger: isSelected)
    }
}

struct AdaptiveContentView: View {
    let selectedTab: MainTabBarView.Tab
    @Binding var hideTabBar: Bool
    
    var body: some View {
        Group {
            switch selectedTab {
            case .explore:
                AdaptiveThemeSelectionView(hideTabBar: $hideTabBar)
            case .account:
                AdaptiveTrendsView(hideTabBar: $hideTabBar)
            case .aiHeadshots:
                AdaptiveHeadshotView(hideTabBar: $hideTabBar)
            case .settings:
                AdaptiveSettingsView(hideTabBar: $hideTabBar)
            }
        }
        .background(
            // Enhanced main content background
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
            .ignoresSafeArea()
        )
    }
} 