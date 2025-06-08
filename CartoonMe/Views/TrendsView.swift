import SwiftUI
import Foundation

struct TrendsView: View {
    @Binding var hideTabBar: Bool
    @State private var selectedCategory: TrendCategory? = nil
    private let trendsData = TrendsData.shared
    
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
                                .blue.opacity(0.15),
                                .blue.opacity(0.05),
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
                                .purple.opacity(0.12),
                                .pink.opacity(0.06),
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
                
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 32) {
                        // Enhanced Header
                        VStack(spacing: 16) {
                            Text("AI Trends")
                                .font(.system(size: 28, weight: .bold, design: .rounded))
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
                                .shadow(color: .blue.opacity(0.3), radius: 20, x: 0, y: 8)
                            
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
                        
                            
//                            Text("Transform your photos with trending AI styles")
//                                .font(.system(size: 16, weight: .medium))
//                                .foregroundColor(.white.opacity(0.7))
//                                .multilineTextAlignment(.center)
                        }
                        .padding(.horizontal, 24)
                        .padding(.top, 16)
                        
                        
                        // 🎯 Native Ad Section
                        ElegantNativeAdvancedAd()
                            .padding(.horizontal, 10)
                            .padding(.vertical, 5)
                        
                        // Hero Section - Featured/Most Popular Trends
                        if selectedCategory == nil {
                            VStack(spacing: 20) {
                                HStack {
                                    Text("🔥 Most Popular")
                                        .font(.system(size: 20, weight: .bold, design: .rounded))
                                        .foregroundStyle(
                                            LinearGradient(
                                                colors: [.white, .white.opacity(0.9)],
                                                startPoint: .topLeading,
                                                endPoint: .bottomTrailing
                                            )
                                        )
                                        .shadow(color: .black.opacity(0.3), radius: 4, x: 0, y: 2)
                                    Spacer()
                                }
                                .padding(.horizontal, 24)
                                
                                // Grid layout for better use of space
                                LazyVGrid(columns: [
                                    GridItem(.flexible(minimum: 150), spacing: 12),
                                    GridItem(.flexible(minimum: 150), spacing: 12)
                                ], spacing: 16) {
                                    ForEach(trendsData.trendingNow, id: \.name) { trend in
                                        SimpleTrendCard(trend: trend, hideTabBar: $hideTabBar)
                                    }
                                }
                                .padding(.horizontal, 24)
                            }
                        }
                        
                        // Category Selection
                        VStack(spacing: 20) {
                            HStack {
                                Text(selectedCategory == nil ? "Browse by Style" : "Categories")
                                    .font(.system(size: 20, weight: .bold, design: .rounded))
                                    .foregroundStyle(
                                        LinearGradient(
                                            colors: [.white, .white.opacity(0.9)],
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        )
                                    )
                                    .shadow(color: .black.opacity(0.3), radius: 4, x: 0, y: 2)
                                Spacer()
                                
                                if selectedCategory != nil {
                                    Button("Show All") {
                                        withAnimation(.easeInOut(duration: 0.3)) {
                                            selectedCategory = nil
                                        }
                                    }
                                    .font(.system(size: 14, weight: .semibold))
                                    .foregroundStyle(
                                        LinearGradient(
                                            colors: [.blue, .cyan],
                                            startPoint: .leading,
                                            endPoint: .trailing
                                        )
                                    )
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 6)
                                    .background(
                                        Capsule()
                                            .fill(.ultraThinMaterial)
                                            .overlay(
                                                Capsule()
                                                    .stroke(.white.opacity(0.15), lineWidth: 1)
                                            )
                                    )
                                    .shadow(color: .blue.opacity(0.3), radius: 4, x: 0, y: 2)
                                }
                            }
                            .padding(.horizontal, 24)
                            
                            // Category pills  
                            VStack(spacing: 8) {
                                ForEach(TrendCategory.allCases, id: \.self) { category in
                                    CategoryCard(
                                        category: category,
                                        isSelected: selectedCategory == category,
                                        trendsCount: trendsData.trends(for: category).count
                                    ) {
                                        withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                                            selectedCategory = selectedCategory == category ? nil : category
                                        }
                                    }
                                }
                            }
                            .padding(.horizontal, 24)
                        }
                        
                        // Selected Category Content
                        if let selectedCategory = selectedCategory {
                            VStack(spacing: 20) {
                                HStack {
                                    Text("\(selectedCategory.emoji) \(selectedCategory.rawValue) Styles")
                                        .font(.system(size: 20, weight: .bold, design: .rounded))
                                        .foregroundStyle(
                                            LinearGradient(
                                                colors: [.white, .white.opacity(0.9)],
                                                startPoint: .topLeading,
                                                endPoint: .bottomTrailing
                                            )
                                        )
                                        .shadow(color: .black.opacity(0.3), radius: 4, x: 0, y: 2)
                                    Spacer()
                                }
                                .padding(.horizontal, 24)
                                
                                LazyVGrid(columns: [
                                    GridItem(.flexible(minimum: 150), spacing: 12),
                                    GridItem(.flexible(minimum: 150), spacing: 12)
                                ], spacing: 16) {
                                    ForEach(trendsData.trends(for: selectedCategory), id: \.name) { trend in
                                        SimpleTrendCard(trend: trend, hideTabBar: $hideTabBar)
                                    }
                                }
                                .padding(.horizontal, 24)
                            }
                        }
                        
                        // Bottom spacer
                        Spacer()
                            .frame(height: 40)
                    }
                    .padding(.top, 12)
                }
            }
            .navigationBarHidden(true)
        }
    }
}

// Sleek Category Card
struct CategoryCard: View {
    let category: TrendCategory
    let isSelected: Bool
    let trendsCount: Int
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 12) {
                // Compact icon
                ZStack {
                    Circle()
                        .fill(
                            isSelected 
                            ? category.color.opacity(0.2)
                            : Color.white.opacity(0.1)
                        )
                        .frame(width: 36, height: 36)
                    
                    Image(systemName: category.icon)
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(
                            isSelected ? category.color : .white.opacity(0.8)
                        )
                }
                
                // Text content
                VStack(alignment: .leading, spacing: 2) {
                    Text(category.rawValue)
                        .font(.system(size: 14, weight: .semibold, design: .rounded))
                        .foregroundColor(.white)
                    
                    Text("\(trendsCount) styles")
                        .font(.system(size: 11, weight: .medium))
                        .foregroundColor(.white.opacity(0.6))
                }
                
                Spacer()
                
                // Selection indicator
                if isSelected {
                    Circle()
                        .fill(category.color)
                        .frame(width: 6, height: 6)
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .fill(
                        isSelected 
                        ? .ultraThinMaterial
                        : .thickMaterial
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 12, style: .continuous)
                            .stroke(
                                isSelected 
                                ? category.color.opacity(0.3)
                                : Color.white.opacity(0.1),
                                lineWidth: isSelected ? 1.5 : 0.5
                            )
                    )
            )
            .scaleEffect(isSelected ? 1.01 : 1.0)
            .shadow(
                color: isSelected ? category.color.opacity(0.15) : .black.opacity(0.05),
                radius: isSelected ? 8 : 2,
                x: 0, y: isSelected ? 4 : 1
            )
        }
        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isSelected)
    }
}

// Enhanced Trend Card  
struct SimpleTrendCard: View {
    let trend: Trend
    @Binding var hideTabBar: Bool
    @State private var isPressed = false
    
    var body: some View {
                                NavigationLink(destination: ContentView(selectedTrend: trend)
                            .onAppear { hideTabBar = true }
                            .onDisappear { hideTabBar = false }
                        ) {
            ZStack {
                // Enhanced card background
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .fill(.ultraThinMaterial)
                    .overlay(
                        RoundedRectangle(cornerRadius: 16, style: .continuous)
                            .stroke(
                                LinearGradient(
                                    colors: [
                                        .white.opacity(0.2),
                                        trend.color.opacity(0.1),
                                        .clear
                                    ],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ),
                                lineWidth: 1
                            )
                    )
                    .aspectRatio(0.75, contentMode: .fit)
                    .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 4)
                    .shadow(color: trend.color.opacity(0.05), radius: 12, x: 0, y: 6)
                
                // Trend image
                Image(trend.image)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 170, height: 230)
                    .clipped()
                    .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                
                // Enhanced gradient overlay
                LinearGradient(
                    colors: [
                        .clear,
                        .clear,
                        .black.opacity(0.3),
                        .black.opacity(0.7)
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                
                // Content overlay
                VStack {
                    // Enhanced popularity badge
                    HStack {
                        Spacer()
                        Text(trend.popularity.rawValue)
                            .font(.system(size: 10, weight: .bold))
                            .foregroundColor(.white)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(
                                Capsule()
                                    .fill(
                                        LinearGradient(
                                            colors: [trend.popularity.color, trend.popularity.color.opacity(0.8)],
                                            startPoint: .leading,
                                            endPoint: .trailing
                                        )
                                    )
                            )
                            .shadow(color: trend.popularity.color.opacity(0.3), radius: 4, x: 0, y: 2)
                    }
                    .padding(.top, 12)
                    .padding(.trailing, 12)
                    
                    Spacer()
                    
                    // Enhanced title area
                    VStack(spacing: 4) {
                        Text(trend.name)
                            .font(.system(size: 14, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                            .lineLimit(2)
                            .shadow(color: .black.opacity(0.8), radius: 4, x: 0, y: 2)
                    }
                    .padding(.horizontal, 12)
                    .padding(.bottom, 12)
                }
            }
            .scaleEffect(isPressed ? 0.95 : 1.0)
            .animation(.easeInOut(duration: 0.1), value: isPressed)
        }
        .onLongPressGesture(minimumDuration: 0, maximumDistance: .infinity) { pressing in
            isPressed = pressing
        } perform: {}
    }
}

#Preview {
    @State var hideTabBar = false
    return TrendsView(hideTabBar: $hideTabBar)
} 
