import SwiftUI
#if canImport(ActivityKit)
import ActivityKit
#endif
#if canImport(WidgetKit)
import WidgetKit
#endif

// Ensures this code only compiles if ActivityKit is available
#if canImport(ActivityKit)
@available(iOS 16.1, *)
struct CartoonProcessingLiveActivityView: View {
    // Properties accessible from the activity configuration
    let context: ActivityViewContext<CartoonProcessingAttributes>

    var body: some View {
        // Main container for the Live Activity
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Image(systemName: "wand.and.stars.iris")
                    .foregroundColor(.purple)
                    .font(.body)
                Text("Cartooning: \(context.attributes.themeName)")
                    .font(.caption.weight(.medium))
                    .foregroundColor(.white)
                Spacer()
                Text("\(Int(context.state.progress * 100))%")
                    .font(.caption.weight(.semibold))
                    .foregroundColor(.white)
            }
            
            // Sleek Progress Bar
            ProgressView(value: context.state.progress, total: 1.0)
                .progressViewStyle(LinearProgressViewStyle(tint: .purple))
                .frame(height: 6)
                .clipShape(Capsule())
        }
        .padding(12)
        .background(Color.black.opacity(0.6)) // Semi-transparent background
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
    }
}

// This struct defines the Lock Screen and expanded Dynamic Island UI
@available(iOS 16.1, *)
struct CartoonProcessingLiveActivityExpandedView: View {
    let context: ActivityViewContext<CartoonProcessingAttributes>

    var body: some View {
        VStack(spacing: 10) {
            HStack {
                Image(systemName: "sparkles")
                    .foregroundColor(.purple)
                    .font(.title2)
                
                VStack(alignment: .leading) {
                    Text("CartoonMe Magic")
                        .font(.headline)
                        .foregroundColor(.white)
                    Text("Processing \(context.attributes.themeName) style...")
                        .font(.footnote)
                        .foregroundColor(.gray)
                }
                Spacer()
                Text("\(Int(context.state.progress * 100))%")
                    .font(.headline.weight(.bold))
                    .foregroundColor(.purple)
            }

            ProgressView(value: context.state.progress, total: 1.0)
                .progressViewStyle(LinearProgressViewStyle(tint: .purple))
                .frame(height: 8)
                .padding(.horizontal)
                .clipShape(Capsule())

            HStack {
                Text("Started: \(context.attributes.startTime, style: .time)")
                Spacer()
                if context.state.progress < 1.0 {
                    Text("Estimating...") // You can add more sophisticated time estimation here
                } else {
                    Text("Completed!")
                        .foregroundColor(.green)
                }
            }
            .font(.caption)
            .foregroundColor(.gray)
        }
        .padding()
        .background(Color.black.opacity(0.7))
    }
}
#endif 