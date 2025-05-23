#if canImport(WidgetKit)
import WidgetKit
#endif
import SwiftUI
#if canImport(ActivityKit)
import ActivityKit
#endif

// The CartoonProcessingAttributes struct (and its ContentState) is now expected
// to be defined in the main app target and shared with the widget extension.
// Ensure that CartoonMe/Models/CartoonProcessingActivity.swift is a member of
// both the main app target and the widget extension target in your Xcode project settings.

// @available(iOS 16.1, *)
// struct CartoonProcessingAttributes: ActivityAttributes { // REMOVED
//    public struct ContentState: Codable, Hashable { // REMOVED
//        var progress: Double // REMOVED
//    } // REMOVED
//    var themeName: String // REMOVED
//    var startTime: Date // REMOVED
// } // REMOVED

// Define the Live Activity view
// CartoonProcessingLiveActivityView is now defined in DynamicIslandViews.swift
// Ensure DynamicIslandViews.swift is part of the widget target.

// Define the widget bundle
@main
struct CartoonMeWidgetBundle: WidgetBundle {
    @WidgetBundleBuilder
    var body: some Widget {
        #if canImport(ActivityKit)
        if #available(iOS 16.1, *) {
            CartoonProcessingActualLiveActivityWidget()
        }
        #endif
        // If you have other, non-ActivityKit widgets, you can add them here.
        // e.g., MyRegularWidget()
    }
}

// Define the Live Activity widget
#if canImport(ActivityKit)
// This entire widget struct depends on ActivityKit
@available(iOS 16.1, *)
struct CartoonProcessingActualLiveActivityWidget: Widget {
    private let kind: String = "CartoonProcessingLiveActivity"

    var body: some WidgetConfiguration {
        // CartoonProcessingAttributes and CartoonProcessingLiveActivityView are expected to be found
        // due to correct target memberships.
        ActivityConfiguration(for: CartoonProcessingAttributes.self) { context in
            CartoonProcessingLiveActivityView(context: context) // This view comes from DynamicIslandViews.swift
                .widgetURL(URL(string: "cartoonme://status/\(context.attributes.themeName)"))
        } dynamicIsland: { context in
            DynamicIsland {
                DynamicIslandExpandedRegion(.leading) {
                    HStack {
                        Image(systemName: "wand.and.stars.iris")
                            .foregroundColor(Color.purple)
                        Text(context.attributes.themeName)
                            .font(.caption.weight(.medium))
                            .lineLimit(1)
                            .foregroundColor(.white)
                    }
                }
                DynamicIslandExpandedRegion(.trailing) {
                    Text("\(Int(context.state.progress * 100))%")
                        .font(.caption.weight(.semibold))
                        .foregroundColor(.white)
                }
                DynamicIslandExpandedRegion(.bottom) {
                    ProgressView(value: context.state.progress, total: 1.0)
                        .progressViewStyle(LinearProgressViewStyle(tint: Color.purple))
                        .frame(height: 8)
                        .padding(.horizontal, 4)
                        .clipShape(Capsule())
                }
            } compactLeading: {
                Image(systemName: "wand.and.stars.iris")
                    .foregroundColor(Color.purple)
            } compactTrailing: {
                Text("\(Int(context.state.progress * 100))%")
                    .font(.caption2.weight(.semibold))
                    .foregroundColor(.white)
            } minimal: {
                Image(systemName: "wand.and.stars.iris")
                    .foregroundColor(Color.purple)
            }
            .widgetURL(URL(string: "cartoonme://status/\(context.attributes.themeName)"))
            .keylineTint(Color.purple.opacity(0.8))
        }
    }
}
#endif // This #endif now correctly closes the #if canImport(ActivityKit) for the widget struct 