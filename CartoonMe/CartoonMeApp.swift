//
//  CartoonMeApp.swift
//  CartoonMe
//
//  Created by Yuri Petrosyan on 10/04/2025.
//

// CartoonMeApp.swift
import SwiftUI
#if canImport(ActivityKit)
import ActivityKit
#endif

@main
struct CartoonMeApp: App {
    
    init() {
        // Initialize the AdMob singleton when the app starts
        _ = AdMobManager.shared
    }
    
    var body: some Scene {
        WindowGroup {
            MainTabBarView()
                .preferredColorScheme(.dark)
        }
    }
}


