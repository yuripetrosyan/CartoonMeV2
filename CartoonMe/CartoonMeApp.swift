//
//  CartoonMeApp.swift
//  CartoonMe
//
//  Created by Yuri Petrosyan on 10/04/2025.
//

// CartoonMeApp.swift
import SwiftUI
import FirebaseCore
import FirebaseAnalytics
//import FirebaseCrashlytics
//import FirebasePerformance
#if canImport(ActivityKit)
import ActivityKit
#endif

@main
struct CartoonMeApp: App {
    @State private var showLaunchAnimation = true
    
    init() {
        FirebaseApp.configure()
        // Initialize the AdMob singleton when the app starts
        _ = AdMobManager.shared
    }
    
    var body: some Scene {
        WindowGroup {
            if showLaunchAnimation {
                LaunchAnimationView {
                    withAnimation(.easeInOut(duration: 0.5)) {
                        showLaunchAnimation = false
                    }
                }
                .preferredColorScheme(.dark)
            } else {
                MainTabBarView()
                    .preferredColorScheme(.dark)
                    .transition(.opacity)
            }
        }
    }
}


