import SwiftUI

struct MainTabBarView: View {
    enum Tab: Int, CaseIterable {
        case explore, account, aiHeadshots, settings
        
        var title: String {
            switch self {
            case .explore: return "tab.cartoon".localized
            case .account: return "tab.trends".localized
            case .settings: return "tab.settings".localized
            case .aiHeadshots: return "tab.headshot".localized
            }
        }
        
        var icon: String {
            switch self {
            case .explore: return "sparkles"
            case .account: return "person.circle"
            case .settings: return "gearshape"
            case .aiHeadshots: return "person.crop.square.filled.and.at.rectangle"
            }
        }
        
        var selectedIcon: String {
            switch self {
            case .explore: return "sparkles"
            case .account: return "person.circle.fill"
            case .settings: return "gearshape.fill"
            case .aiHeadshots: return "person.crop.square.filled.and.at.rectangle.fill"
            }
        }
        
        var accentColor: Color {
            switch self {
            case .explore: return .purple
            case .account: return .blue
            case .settings: return .green
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
                    NavigationStack {
                        TrendsView(hideTabBar: $hideTabBar)
                    }
                case .aiHeadshots:
                    HeadshotView(hideTabBar: $hideTabBar)
                    
                case .settings:
                    SettingsView(hideTabBar: $hideTabBar)
                }
            }
            .edgesIgnoringSafeArea(.all)
            
          
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
    @State private var highlightOffset: CGFloat = 0
    @State private var tabWidth: CGFloat = 0
    
    // Computed property for tab-specific offset adjustments
    private var offsetAdjustment: CGFloat {
        switch selectedTab {
        case .explore: return -12
        case .account: return -8
        case .aiHeadshots: return -2
        case .settings: return 3
        }
    }
    
    var body: some View {
        GeometryReader { geometry in
            let totalWidth = geometry.size.width - 20 // Account for horizontal padding
            let tabCount = CGFloat(MainTabBarView.Tab.allCases.count)
            let calculatedTabWidth = totalWidth / tabCount
            
            ZStack {
                // Single sliding highlight that looks like the actual tab highlight
                RoundedRectangle(cornerRadius: 25, style: .continuous)
                    .fill(
                        LinearGradient(
                            colors: [
                                selectedTab.accentColor.opacity(0.3),
                                selectedTab.accentColor.opacity(0.1)
                            ],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 25, style: .continuous)
                            .stroke(selectedTab.accentColor.opacity(0.4), lineWidth: 1)
                    )
                    .shadow(
                        color: selectedTab.accentColor.opacity(0.3),
                        radius: 8,
                        x: 0,
                        y: 4
                    )
                    .frame(width: 70, height: 56)
                    .offset(x: highlightOffset + offsetAdjustment, y: -2)
                    .animation(.spring(response: 0.5, dampingFraction: 0.7), value: highlightOffset)
                    .animation(.easeInOut(duration: 0.3), value: selectedTab.accentColor)
                
                // Tab items (without individual highlights)
                HStack(spacing: 0) {
                    ForEach(MainTabBarView.Tab.allCases, id: \.self) { tab in
                        ModernTabBarItem(
                            tab: tab,
                            isSelected: selectedTab == tab,
                            isPressed: isPressed[tab] ?? false
                        ) {
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                selectedTab = tab
                                updateHighlightPosition(for: tab, tabWidth: calculatedTabWidth)
                            }
                        } onPressChange: { pressing in
                            withAnimation(.easeInOut(duration: 0.1)) {
                                isPressed[tab] = pressing
                            }
                        }
                    }
                }
            }
            .onAppear {
                tabWidth = calculatedTabWidth
                updateHighlightPosition(for: selectedTab, tabWidth: calculatedTabWidth)
            }
            .onChange(of: selectedTab) { _, newTab in
                updateHighlightPosition(for: newTab, tabWidth: calculatedTabWidth)
            }
        }
        //change
        .frame(height: 50)
        .padding(.horizontal, 10)
        .padding(.vertical, 11)
        .background(
            // Advanced Glassmorphism Background
            ZStack {
                // Base material
                RoundedRectangle(cornerRadius: 50, style: .continuous)
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
        .padding(.horizontal, 40)
        .padding(.bottom, -20) // Adjusted for home indicator
    }
    
    private func updateHighlightPosition(for tab: MainTabBarView.Tab, tabWidth: CGFloat) {
        let tabIndex = CGFloat(MainTabBarView.Tab.allCases.firstIndex(of: tab) ?? 0)
        let newOffset = (tabIndex * tabWidth) - ((CGFloat(MainTabBarView.Tab.allCases.count - 1) * tabWidth) / 2) + (tabWidth / 2) - (tabWidth - 10) / 2
        highlightOffset = newOffset
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
            .frame(maxWidth: .infinity)
            .scaleEffect(isPressed ? 0.9 : 1.0)
            .animation(.spring(response: 0.2, dampingFraction: 0.8), value: isPressed)
        }
        .onLongPressGesture(minimumDuration: 0, maximumDistance: .infinity) { pressing in
            onPressChange(pressing)
        } perform: {}
        .sensoryFeedback(.impact(flexibility: .soft, intensity: 0.5), trigger: isSelected)
        .accessibilityLabel(tab.title)
    }
}



struct MainTabBarView_Previews: PreviewProvider {
    static var previews: some View {
        MainTabBarView()
            .preferredColorScheme(.dark)
    }
}

#Preview {
    MainTabBarView()
} 
