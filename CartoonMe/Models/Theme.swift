//
//  Theme.swift
//  CartoonMe
//
//  Created by Yuri Petrosyan on 10/04/2025.
//

import SwiftUI

struct Theme: Identifiable {
    let id = UUID()
    let name: String
    let color: Color
    let image: String
    let logo: String?
}

struct Trend: Identifiable {
    let id = UUID()
    let name: String
    let description: String
    let color: Color
    let icon: String
    let image: String
    let category: TrendCategory
    let popularity: PopularityLevel
    let prompt: String
    let tags: [String]
}

enum TrendCategory: String, CaseIterable {
    case nostalgic = "Nostalgic"
    case fantasy = "Fantasy"
    case character = "Character"
    case stylized = "Stylized"
    case gaming = "Gaming"
    
    var color: Color {
        switch self {
        case .nostalgic: return .orange
        case .fantasy: return .purple
        case .character: return .blue
        case .stylized: return .pink
        case .gaming: return .green
        }
    }
    
    var icon: String {
        switch self {
        case .nostalgic: return "clock.fill"
        case .fantasy: return "sparkles"
        case .character: return "person.fill"
        case .stylized: return "paintbrush.fill"
        case .gaming: return "gamecontroller.fill"
        }
    }
    
    var emoji: String {
        switch self {
        case .nostalgic: return "🕰️"
        case .fantasy: return "✨"
        case .character: return "👤"
        case .stylized: return "🎨"
        case .gaming: return "🎮"
        }
    }
}

enum PopularityLevel: String, CaseIterable {
    case viral = "🔥 Viral"
    case trending = "📈 Trending"
    case popular = "⭐ Popular"
    case rising = "🚀 Rising"
    
    var color: Color {
        switch self {
        case .viral: return .red
        case .trending: return .orange
        case .popular: return .yellow
        case .rising: return .green
        }
    }
} 