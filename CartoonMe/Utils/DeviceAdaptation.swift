import SwiftUI
#if canImport(UIKit)
import UIKit
#endif

// MARK: - Device Detection & Adaptive Design System
enum DeviceType {
    case iPhone
    case iPad
    case visionOS
    case mac
    
    static var current: DeviceType {
        #if os(visionOS)
        return .visionOS
        #elseif os(macOS)
        return .mac
        #else
        if UIDevice.current.userInterfaceIdiom == .pad {
            return .iPad
        } else {
            return .iPhone
        }
        #endif
    }
    
    var isLargeScreen: Bool {
        switch self {
        case .iPad, .visionOS, .mac:
            return true
        case .iPhone:
            return false
        }
    }
    
    var supportsSpatialDesign: Bool {
        switch self {
        case .visionOS:
            return true
        default:
            return false
        }
    }
}

// MARK: - Adaptive Layout System
struct AdaptiveLayout {
    let deviceType: DeviceType
    
    init(_ deviceType: DeviceType = DeviceType.current) {
        self.deviceType = deviceType
    }
    
    // Spacing values
    var smallSpacing: CGFloat {
        switch deviceType {
        case .iPhone: return 8
        case .iPad: return 12
        case .visionOS: return 16
        case .mac: return 10
        }
    }
    
    var mediumSpacing: CGFloat {
        switch deviceType {
        case .iPhone: return 16
        case .iPad: return 24
        case .visionOS: return 32
        case .mac: return 20
        }
    }
    
    var largeSpacing: CGFloat {
        switch deviceType {
        case .iPhone: return 24
        case .iPad: return 32
        case .visionOS: return 48
        case .mac: return 28
        }
    }
    
    // Grid columns
    var themeGridColumns: Int {
        switch deviceType {
        case .iPhone: return 2
        case .iPad: return 3
        case .visionOS: return 4
        case .mac: return 3
        }
    }
    
    var trendGridColumns: Int {
        switch deviceType {
        case .iPhone: return 2
        case .iPad: return 3
        case .visionOS: return 4
        case .mac: return 3
        }
    }
    
    // Card sizes
    var themeCardSize: CGSize {
        switch deviceType {
        case .iPhone: return CGSize(width: 160, height: 200)
        case .iPad: return CGSize(width: 220, height: 280)
        case .visionOS: return CGSize(width: 260, height: 340)
        case .mac: return CGSize(width: 200, height: 250)
        }
    }
    
    // Corner radius
    var cornerRadius: CGFloat {
        switch deviceType {
        case .iPhone: return 16
        case .iPad: return 20
        case .visionOS: return 24
        case .mac: return 18
        }
    }
    
    // Tab bar style
    var usesSidebarNavigation: Bool {
        switch deviceType {
        case .iPad, .visionOS, .mac:
            return true
        case .iPhone:
            return false
        }
    }
}

// MARK: - Adaptive Materials & Effects
struct AdaptiveMaterial: View {
    let level: MaterialLevel
    let deviceType: DeviceType
    
    enum MaterialLevel {
        case thin, regular, thick, ultra
    }
    
    init(_ level: MaterialLevel = .regular, for deviceType: DeviceType = DeviceType.current) {
        self.level = level
        self.deviceType = deviceType
    }
    
    var body: some View {
        Group {
            switch deviceType {
            case .visionOS:
                // Enhanced glassmorphism for visionOS
                RoundedRectangle(cornerRadius: AdaptiveLayout(deviceType).cornerRadius, style: .continuous)
                    .fill(.ultraThinMaterial)
                    .overlay(
                        RoundedRectangle(cornerRadius: AdaptiveLayout(deviceType).cornerRadius, style: .continuous)
                            .fill(
                                LinearGradient(
                                    colors: [
                                        .white.opacity(0.2),
                                        .white.opacity(0.1),
                                        .clear,
                                        .black.opacity(0.05)
                                    ],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: AdaptiveLayout(deviceType).cornerRadius, style: .continuous)
                            .stroke(
                                LinearGradient(
                                    colors: [.white.opacity(0.3), .clear],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ),
                                lineWidth: 0.5
                            )
                    )
                    .shadow(color: .black.opacity(0.1), radius: 20, x: 0, y: 10)
                    .shadow(color: .black.opacity(0.05), radius: 1, x: 0, y: 1)
                
            case .iPad:
                // Enhanced material for iPad
                RoundedRectangle(cornerRadius: AdaptiveLayout(deviceType).cornerRadius, style: .continuous)
                    .fill(.regularMaterial)
                    .overlay(
                        RoundedRectangle(cornerRadius: AdaptiveLayout(deviceType).cornerRadius, style: .continuous)
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
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: AdaptiveLayout(deviceType).cornerRadius, style: .continuous)
                            .stroke(.white.opacity(0.2), lineWidth: 0.5)
                    )
                    .shadow(color: .black.opacity(0.1), radius: 15, x: 0, y: 8)
                
            default:
                // Return empty view for iPhone - will use existing components
                EmptyView()
            }
        }
    }
}

// MARK: - Hover Effects for visionOS/iPad
struct AdaptiveHoverEffect: ViewModifier {
    @State private var isHovered = false
    let deviceType: DeviceType
    
    init(for deviceType: DeviceType = DeviceType.current) {
        self.deviceType = deviceType
    }
    
    func body(content: Content) -> some View {
        content
            .scaleEffect(isHovered ? 1.05 : 1.0)
            .shadow(
                color: .black.opacity(isHovered ? 0.2 : 0.1),
                radius: isHovered ? 20 : 10,
                x: 0,
                y: isHovered ? 15 : 5
            )
            .animation(.easeInOut(duration: 0.2), value: isHovered)
            .onHover { hovering in
                if deviceType.isLargeScreen {
                    isHovered = hovering
                }
            }
    }
}

extension View {
    func adaptiveHover(for deviceType: DeviceType = DeviceType.current) -> some View {
        modifier(AdaptiveHoverEffect(for: deviceType))
    }
} 