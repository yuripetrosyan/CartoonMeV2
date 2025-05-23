// Using conditional imports to avoid linter errors
#if canImport(ActivityKit)
import ActivityKit
#endif
import SwiftUI

#if canImport(ActivityKit)
// Only define these when ActivityKit is available
struct CartoonProcessingAttributes: ActivityAttributes {
    // public struct ContentState: Codable, Hashable { // Commented out as an example, will be fixed below
    //     var progress: Double
    //     var isComplete: Bool
    // }
    public struct ContentState: Codable, Hashable {
        var progress: Double
        // isComplete removed, can be inferred from progress == 1.0
    }
    
    var themeName: String
    var startTime: Date
}
#endif

class CartoonProcessingManager {
    static let shared = CartoonProcessingManager()
    
    #if canImport(ActivityKit)
    @available(iOS 16.1, *)
    private var currentActivity: Activity<CartoonProcessingAttributes>?
    #endif
    
    func startActivity(themeName: String) {
        #if canImport(ActivityKit)
        if #available(iOS 16.1, *), ActivityAuthorizationInfo().areActivitiesEnabled {
            let attributes = CartoonProcessingAttributes(
                themeName: themeName,
                startTime: Date()
            )
            
            let initialState = CartoonProcessingAttributes.ContentState(
                progress: 0.0
                // isComplete: false // Removed
            )
            
            do {
                currentActivity = try Activity.request(
                    attributes: attributes,
                    contentState: initialState, // Corrected to use the simplified ContentState
                    pushType: nil
                )
                print("Cartoon processing activity started with ID: \(currentActivity?.id ?? "unknown")")
            } catch {
                print("Error starting cartoon processing activity: \(error.localizedDescription)")
            }
        } else {
            print("Live Activities not supported on this device or iOS version")
        }
        #else
        print("ActivityKit not available in this build")
        #endif
    }
    
    func updateProgress(_ progress: Double) {
        #if canImport(ActivityKit)
        if #available(iOS 16.1, *) {
            guard let activity = currentActivity else { return }
            
            let updatedState = CartoonProcessingAttributes.ContentState(
                progress: progress
                // isComplete: false // Removed
            )
            
            Task {
                await activity.update(using: updatedState) // Corrected
            }
        }
        #endif
    }
    
    func completeActivity() {
        #if canImport(ActivityKit)
        if #available(iOS 16.1, *) {
            guard let activity = currentActivity else { return }
            
            let finalState = CartoonProcessingAttributes.ContentState(
                progress: 1.0
                // isComplete: true // Removed
            )
            
            Task {
                // For dismissalPolicy, ensure you use the correct ActivityUIDismissalPolicy if needed,
                // or rely on the default behavior if .immediate is causing issues or not desired.
                // Example: await activity.end(using: finalState, dismissalPolicy: .default)
                await activity.end(using: finalState, dismissalPolicy: .immediate) // Corrected
                currentActivity = nil
            }
        }
        #endif
    }
    
    func cancelActivity() {
        #if canImport(ActivityKit)
        if #available(iOS 16.1, *) {
            guard let activity = currentActivity else { return }
            
            Task {
                await activity.end(dismissalPolicy: .immediate)
                currentActivity = nil
            }
        }
        #endif
    }
} 
