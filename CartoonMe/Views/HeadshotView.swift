import SwiftUI

struct HeadshotView: View {
    @Binding var hideTabBar: Bool
    
    init(hideTabBar: Binding<Bool> = .constant(false)) {
        self._hideTabBar = hideTabBar
    }

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
                                .green.opacity(0.12),
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
                
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 32) {
                        // Enhanced Header
                        VStack(spacing: 16) {
                            Text("AI Headshots")
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
                                            .green.opacity(0.9),
                                            .blue.opacity(0.7),
                                            .cyan.opacity(0.5),
                                            .teal.opacity(0.3)
                                        ],
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                                .frame(width: 80, height: 4)
                                .shadow(color: .green.opacity(0.6), radius: 8, x: 0, y: 4)
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
                            
                            Text("Professional headshots powered by AI")
                                .font(.system(size: 16, weight: .medium))
                                .foregroundColor(.white.opacity(0.7))
                                .multilineTextAlignment(.center)
                        }
                        .padding(.horizontal, 24)
                        .padding(.top, 16)
                        
                        // Professional Headshot Styles Section
                        VStack(spacing: 20) {
                            HStack {
                                Text("🎯 Professional Styles")
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
                            
                            // Grid layout for headshot styles
                            LazyVGrid(columns: [
                                GridItem(.flexible(minimum: 150), spacing: 12),
                                GridItem(.flexible(minimum: 150), spacing: 12)
                            ], spacing: 16) {
                                ForEach(HeadshotStyle.allCases, id: \.id) { style in
                                    HeadshotStyleCard(style: style, hideTabBar: $hideTabBar)
                                }
                            }
                            .padding(.horizontal, 24)
                        }
                        
                        // Bottom spacer
                        Spacer()
                            .frame(height: 40)
                    }
                    .padding(.top, 12)
                }
            }
            .toolbar(.hidden, for: .navigationBar)
        }
    }
}

// Enhanced Headshot Style Card  
struct HeadshotStyleCard: View {
    let style: HeadshotStyle
    @Binding var hideTabBar: Bool
    @State private var isPressed = false
    
    var body: some View {
        NavigationLink(destination: ContentView(selectedHeadshotStyle: style)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar(.hidden, for: .tabBar)
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
                                        style.color.opacity(0.1),
                                        .clear
                                    ],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ),
                                lineWidth: 1
                            )
                    )
                    .aspectRatio(0.8, contentMode: .fit)
                    .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 4)
                    .shadow(color: style.color.opacity(0.05), radius: 12, x: 0, y: 6)
                
                // Enhanced gradient overlay
                LinearGradient(
                    colors: [
                        style.color.opacity(0.1),
                        style.color.opacity(0.05),
                        .clear
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                
                // Content overlay
                VStack(spacing: 12) {
                    Spacer()
                    
                    // Enhanced icon
                    ZStack {
                        Circle()
                            .fill(
                                LinearGradient(
                                    colors: [style.color.opacity(0.3), style.color.opacity(0.1)],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .frame(width: 48, height: 48)
                        
                        Image(systemName: style.icon)
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundStyle(
                                LinearGradient(
                                    colors: [style.color, style.color.opacity(0.8)],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                    }
                    
                    // Style name
                    Text(style.rawValue)
                        .font(.system(size: 16, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                        .shadow(color: .black.opacity(0.3), radius: 2, x: 0, y: 1)
                    
                    // Description
                    Text(style.description)
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(.white.opacity(0.8))
                        .multilineTextAlignment(.center)
                        .lineLimit(2)
                        .padding(.horizontal, 8)
                    
                    Spacer()
                        .frame(height: 8)
                }
                .padding(.vertical, 16)
                .padding(.horizontal, 12)
            }
            .scaleEffect(isPressed ? 0.95 : 1.0)
            .animation(.spring(response: 0.3, dampingFraction: 0.6), value: isPressed)
        }
        .buttonStyle(PlainButtonStyle())
        .onTapGesture {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                isPressed = true
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                    isPressed = false
                }
            }
        }
    }
}

enum HeadshotStyle: String, CaseIterable, Identifiable {
    case casual = "Casual"
    case office = "Office"
    case corporate = "Corporate"
    case creative = "Creative"
    case formal = "Formal"
    case linkedin = "LinkedIn"
    case medical = "Medical"
    case academic = "Academic"

    var id: String { self.rawValue }
    
    var description: String {
        switch self {
        case .casual:
            return "Relaxed, approachable professional style"
        case .office:
            return "Modern workplace professional look"
        case .corporate:
            return "Executive business leadership style"
        case .creative:
            return "Artistic, innovative industry style"
        case .formal:
            return "Traditional formal business attire"
        case .linkedin:
            return "Optimized for professional networking"
        case .medical:
            return "Healthcare professional appearance"
        case .academic:
            return "Educational institution style"
        }
    }
    
    var detailedDescription: String {
        switch self {
        case .casual:
            return "Perfect for startups, tech companies, and modern workplaces"
        case .office:
            return "Ideal for corporate websites and business profiles"
        case .corporate:
            return "Executive-level photos for leadership teams"
        case .creative:
            return "For agencies, studios, and creative professionals"
        case .formal:
            return "Classic business photos for traditional industries"
        case .linkedin:
            return "Professional photos optimized for LinkedIn profiles"
        case .medical:
            return "Trustworthy appearance for healthcare professionals"
        case .academic:
            return "Professional photos for educators and researchers"
        }
    }
    
    var icon: String {
        switch self {
        case .casual:
            return "person.crop.circle"
        case .office:
            return "building.2"
        case .corporate:
            return "briefcase"
        case .creative:
            return "paintbrush"
        case .formal:
            return "suit.club"
        case .linkedin:
            return "link.circle"
        case .medical:
            return "stethoscope"
        case .academic:
            return "graduationcap"
        }
    }
    
    var color: Color {
        switch self {
        case .casual:
            return .blue
        case .office:
            return .cyan
        case .corporate:
            return .purple
        case .creative:
            return .orange
        case .formal:
            return .gray
        case .linkedin:
            return .blue
        case .medical:
            return .green
        case .academic:
            return .indigo
        }
    }
    
    var apiPrompt: String {
        switch self {
        case .casual:
            return "Professional casual headshot, warm lighting, approachable expression, business casual attire, clean background, natural smile, confident posture"
        case .office:
            return "Corporate office headshot, professional lighting, business attire, neutral background, confident expression, workplace appropriate styling"
        case .corporate:
            return "Executive corporate headshot, high-end professional lighting, formal business suit, clean corporate background, authoritative yet approachable expression"
        case .creative:
            return "Creative professional headshot, artistic lighting, modern styling, creative industry appropriate, dynamic background, innovative and confident expression"
        case .formal:
            return "Formal professional headshot, classic lighting, traditional formal attire, elegant background, sophisticated and trustworthy expression"
        case .linkedin:
            return "LinkedIn professional headshot, optimal lighting for social media, professional attire, clean background, trustworthy and approachable expression"
        case .medical:
            return "Medical professional headshot, clean clinical lighting, healthcare appropriate attire, sterile background, trustworthy and compassionate expression"
        case .academic:
            return "Academic professional headshot, scholarly lighting, educational appropriate attire, institutional background, knowledgeable and approachable expression"
        }
    }
}

struct HeadshotView_Previews: PreviewProvider {
    static var previews: some View {
        HeadshotView()
            .preferredColorScheme(.dark)
    }
} 