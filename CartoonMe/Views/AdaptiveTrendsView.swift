import SwiftUI

struct AdaptiveTrendsView: View {
    @Binding var hideTabBar: Bool
    
    var body: some View {
        if DeviceType.current == .iPhone {
            // iPhone: Use existing TrendsView
            TrendsView(hideTabBar: $hideTabBar)
        } else {
            // iPad & visionOS: Enhanced adaptive UI  
            Text("Enhanced Trends View for iPad/visionOS")
                .font(.largeTitle)
                .foregroundColor(.white)
        }
    }
}

struct AdaptiveHeadshotView: View {
    @Binding var hideTabBar: Bool
    
    var body: some View {
        if DeviceType.current == .iPhone {
            // iPhone: Use existing AIHeadshotsView
            HeadshotView(hideTabBar: $hideTabBar)
        } else {
            // iPad & visionOS: Enhanced adaptive UI
            Text("Enhanced AI Headshots View for iPad/visionOS")
                .font(.largeTitle)
                .foregroundColor(.white)
        }
    }
}

struct AdaptiveSettingsView: View {
    @Binding var hideTabBar: Bool
    
    var body: some View {
        if DeviceType.current == .iPhone {
            // iPhone: Use existing SettingsView
            SettingsView(hideTabBar: $hideTabBar)
        } else {
            // iPad & visionOS: Enhanced adaptive UI
            Text("Enhanced Settings View for iPad/visionOS")
                .font(.largeTitle)
                .foregroundColor(.white)
        }
    }
} 
