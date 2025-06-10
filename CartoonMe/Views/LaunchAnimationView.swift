import SwiftUI

struct LaunchAnimationView: View {
    @State private var animationPhase: AnimationPhase = .initial
    @State private var gradientOffset: CGFloat = 0
    @State private var isComplete = false
    
    let onAnimationComplete: () -> Void
    
    enum AnimationPhase {
        case initial
        case colorAnimation
        case transition
        case complete
    }
    
    // Calculate the final position in ThemeSelectionView
    // The rounded rectangle appears under the "Transform Your Style" title
    private var finalOffset: CGSize {
        CGSize(width: 0, height: -285) // Moved higher on the screen
    }
    
    var body: some View {
        ZStack {
            // Background - matching the theme selection view
            LinearGradient(
                colors: [
                    Color.black.opacity(0.95),
                    Color.purple.opacity(0.08),
                    Color.pink.opacity(0.05)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            // Ambient background effects (similar to ThemeSelectionView)
            RadialGradient(
                colors: [
                    .purple.opacity(0.15),
                    .clear
                ],
                center: .center,
                startRadius: 20,
                endRadius: 100
            )
            .frame(width: 200, height: 200)
            .offset(x: 120, y: -180)
            .blur(radius: 35)
            
            RadialGradient(
                colors: [
                    .pink.opacity(0.08),
                    .clear
                ],
                center: .center,
                startRadius: 20,
                endRadius: 100
            )
            .frame(width: 200, height: 200)
            .offset(x: -120, y: 180)
            .blur(radius: 35)
            
            // The animated rounded rectangle
            VStack(spacing: 12) {
                // The main animated rectangle
                RoundedRectangle(cornerRadius: 3)
                    .fill(
                        LinearGradient(
                            colors: [
                                .purple.opacity(0.9),
                                .blue.opacity(0.7),
                                .pink.opacity(0.5),
                                .cyan.opacity(0.3)
                            ],
                            startPoint: UnitPoint(x: gradientOffset, y: 0),
                            endPoint: UnitPoint(x: gradientOffset + 0.5, y: 1)
                        )
                    )
                    .frame(
                        width: animationPhase == .initial || animationPhase == .colorAnimation ? 120 : 80,
                        height: animationPhase == .initial || animationPhase == .colorAnimation ? 6 : 4
                    )
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
                    .scaleEffect(
                        animationPhase == .initial || animationPhase == .colorAnimation ? 1.5 : 1.0
                    )
                    .offset(
                        x: animationPhase == .transition || animationPhase == .complete ? finalOffset.width : 0,
                        y: animationPhase == .transition || animationPhase == .complete ? finalOffset.height : 0
                    )
                    .animation(
                        .spring(response: 0.8, dampingFraction: 0.8),
                        value: animationPhase
                    )
            }
        }
        .onAppear {
            startAnimation()
        }
    }
    
    private func startAnimation() {
        // Phase 1: Initial delay and start continuous color animation
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            animationPhase = .colorAnimation
            
            // Start continuous gradient movement that never stops
            startContinuousGradientAnimation()
        }
        
        // Phase 2: Transition to final position with spring animation
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
            withAnimation(.spring(response: 0.8, dampingFraction: 0.7)) {
                animationPhase = .transition
            }
        }
        
        // Phase 3: Complete the animation and show title
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.2) {
            withAnimation(.easeInOut(duration: 0.4)) {
                animationPhase = .complete
            }
        }
        
        // Phase 4: Transition to main app
        DispatchQueue.main.asyncAfter(deadline: .now() + 4.0) {
            withAnimation(.easeInOut(duration: 0.5)) {
                onAnimationComplete()
            }
        }
    }
    
    private func startContinuousGradientAnimation() {
        withAnimation(.linear(duration: 2.0).repeatForever(autoreverses: true)) {
            gradientOffset = 1.0
        }
    }
}

#Preview {
    Group{
        LaunchAnimationView {
            print("Animation complete")
        }
        
    

    }
}

#Preview(body: {
    CartoonView(hideTabBar: .constant(true))
})
