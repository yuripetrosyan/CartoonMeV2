import SwiftUI
import Foundation

struct TrendsView: View {
    @State private var selectedCategory: TrendCategory? = nil
    @State private var showAllTrends = false
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
                    LazyVStack(spacing: 40) {
                        // Enhanced Header Section
                        VStack(spacing: 24) {
                            // Main title with sophisticated styling
                            VStack(spacing: 12) {
                                Text("AI Trends")
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
                                    .shadow(color: .blue.opacity(0.3), radius: 20, x: 0, y: 8)
                                
                                // Enhanced accent line with gradient
                                RoundedRectangle(cornerRadius: 3)
                                    .fill(
                                        LinearGradient(
                                            colors: [
                                                .blue.opacity(0.9),
                                                .purple.opacity(0.7),
                                                .pink.opacity(0.5),
                                                .cyan.opacity(0.3)
                                            ],
                                            startPoint: .leading,
                                            endPoint: .trailing
                                        )
                                    )
                                    .frame(width: 80, height: 4)
                                    .shadow(color: .blue.opacity(0.6), radius: 8, x: 0, y: 4)
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
                            Text("Discover the latest viral AI image trends from social media")
                                .font(.system(size: 17, weight: .medium, design: .rounded))
                                .foregroundStyle(
                                    LinearGradient(
                                        colors: [
                                            .white.opacity(0.8),
                                            .white.opacity(0.6)
                                        ],
                                        startPoint: .top,
                                        endPoint: .bottom
                                    )
                                )
                                .multilineTextAlignment(.center)
                                .lineLimit(2)
                                .shadow(color: .black.opacity(0.3), radius: 4, x: 0, y: 2)
                        }
                        .padding(.horizontal, 28)
                        .padding(.top, 16)
                        
                        // Viral Trends Section
                        TrendCarouselSection(
                            title: "🔥 Viral Now",
                            subtitle: "Most popular AI trends taking over social media",
                            trends: trendsData.trendingNow,
                            showSeeAll: true,
                            seeAllAction: { showAllTrends = true }
                        )
                        
                        // Category Filter Pills
                        CategoryFilterSection(selectedCategory: $selectedCategory)
                        
                        // Category-based sections
                        if let selectedCategory = selectedCategory {
                            TrendCarouselSection(
                                title: "\(selectedCategory.emoji) \(selectedCategory.rawValue)",
                                subtitle: "Trending \(selectedCategory.rawValue.lowercased()) AI styles",
                                trends: trendsData.trends(for: selectedCategory),
                                showSeeAll: false,
                                seeAllAction: {}
                            )
                        } else {
                            // Show all categories when none selected
                            ForEach(TrendCategory.allCases, id: \.self) { category in
                                let categoryTrends = trendsData.trends(for: category)
                                if !categoryTrends.isEmpty {
                                    TrendCarouselSection(
                                        title: "\(category.emoji) \(category.rawValue)",
                                        subtitle: "Popular \(category.rawValue.lowercased()) transformations",
                                        trends: Array(categoryTrends.prefix(4)),
                                        showSeeAll: categoryTrends.count > 4,
                                        seeAllAction: { selectedCategory = category }
                                    )
                                }
                            }
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
    }
}

// Category Filter Section
struct CategoryFilterSection: View {
    @Binding var selectedCategory: TrendCategory?
    
    var body: some View {
        VStack(spacing: 16) {
            HStack {
                Text("Categories")
                    .font(.system(size: 22, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                Spacer()
                
                if selectedCategory != nil {
                    Button("Clear") {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            selectedCategory = nil
                        }
                    }
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundColor(.white.opacity(0.8))
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
                }
            }
            .padding(.horizontal, 24)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(TrendCategory.allCases, id: \.self) { category in
                        CategoryPill(
                            category: category,
                            isSelected: selectedCategory == category
                        ) {
                            withAnimation(.easeInOut(duration: 0.3)) {
                                selectedCategory = selectedCategory == category ? nil : category
                            }
                        }
                    }
                }
                .padding(.horizontal, 24)
            }
        }
    }
}

// Category Pill
struct CategoryPill: View {
    let category: TrendCategory
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 8) {
                Image(systemName: category.icon)
                    .font(.system(size: 14, weight: .semibold))
                
                Text(category.rawValue)
                    .font(.system(size: 14, weight: .semibold, design: .rounded))
            }
            .foregroundColor(isSelected ? .white : .white.opacity(0.8))
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
            .background(
                Capsule()
                    .fill(
                        isSelected
                        ? LinearGradient(
                            colors: [category.color, category.color.opacity(0.8)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                        : LinearGradient(
                            colors: [.clear, .clear],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .overlay(
                        Capsule()
                            .stroke(
                                isSelected ? category.color.opacity(0.3) : .white.opacity(0.2),
                                lineWidth: 1
                            )
                    )
            )
            .scaleEffect(isSelected ? 1.05 : 1.0)
            .shadow(color: isSelected ? category.color.opacity(0.3) : .clear, radius: 8, x: 0, y: 4)
        }
        .animation(.easeInOut(duration: 0.2), value: isSelected)
    }
}

// Trend Carousel Section
struct TrendCarouselSection: View {
    let title: String
    let subtitle: String
    let trends: [Trend]
    let showSeeAll: Bool
    let seeAllAction: () -> Void
    
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
            
            // Enhanced trend cards carousel
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(trends, id: \.name) { trend in
                        TrendCard(trend: trend)
                        
                    }
                }
                .padding(.horizontal, 24)
            }
        }
    }
}

// Individual Trend Card
struct TrendCard: View {
    let trend: Trend
    @State private var isPressed = false
    
    var body: some View {
        NavigationLink(destination: ContentView(selectedTrend: trend)) {
            ZStack {
                // Multi-layer background card
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .fill(.ultraThinMaterial)
                    .overlay(
                        RoundedRectangle(cornerRadius: 20, style: .continuous)
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
                    .frame(width: 160, height: 200)
                    .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 4)
                    .shadow(color: trend.color.opacity(0.05), radius: 12, x: 0, y: 6)
                
                // Full-size trend image
                Image(trend.image)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 160, height: 200)
                    .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                
                // Gradient overlay for text readability
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
                .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                
                // Overlayed content
                VStack {
                    // Popularity badge at top
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
                    
                    // Trend name at bottom
                    VStack(spacing: 4) {
                        Text(trend.name)
                            .font(.system(size: 16, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                            .lineLimit(2)
                            .shadow(color: .black.opacity(0.8), radius: 4, x: 0, y: 2)
                    }
                    .padding(.horizontal, 12)
                    .padding(.bottom, 16)
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
    TrendsView()
} 
