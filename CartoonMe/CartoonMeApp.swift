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
    var body: some Scene {
        WindowGroup {
            MainTabBarView()
                .preferredColorScheme(.dark)
        }
    }
}


