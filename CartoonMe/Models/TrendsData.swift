import SwiftUI
import Foundation

class TrendsData {
    static let shared = TrendsData()
    
    let allTrends: [Trend] = [
        Trend(
            name: "Barbie Box",
            description: "Transform into a Barbie-style doll with pink packaging, inspired by childhood nostalgia and the viral Barbie movie trend.",
            color: .pink,
            icon: "gift.fill",
            image: "BarbieBoxImage",
            category: .nostalgic,
            popularity: .viral,
            prompt: "Using the input photo, create a Barbie-style doll of this person. Place them inside a pink toy doll box with a Barbie-like name label and fun accessories that reflect their personality (e.g. laptop, camera, etc.). The style should mimic a real Barbie packaging – bright, glossy, and playful.",
            tags: ["Barbie", "Doll", "Pink", "Packaging", "Nostalgic"]
        ),
        
        Trend(
            name: "Action Figure",
            description: "Turn yourself into a collectible action figure with blister pack packaging, complete with accessories and character stats.",
            color: .blue,
            icon: "figure.stand",
            image: "ActionFigureImage",
            category: .character,
            popularity: .viral,
            prompt: "Create a toy figure of the person in the photo. The figure should be presented as a collectible action figure inside a clear plastic blister pack, with a decorated backing card behind it. Include small accessories around the figure inside the packaging that match the person's personality or \"powers.\" Make it look like a realistic toy product on a store shelf.",
            tags: ["Action Figure", "Packaging", "Collectible", "Toys"]
        ),
        
        Trend(
            name: "Pet to Human",
            description: "Transform your beloved pet into a human character while preserving their unique personality and traits.",
            color: .orange,
            icon: "pawprint.fill",
            image: "PetToHumanImage",
            category: .character,
            popularity: .trending,
            prompt: "Transform this animal into a human character, removing all animal features (fur, ears, snout, tail, etc.) but preserving its personality and recognizable traits. Capture the pet's expression and emotional vibe in the human's face and posture. Make sure the background and clothing also match the pet's spirit.",
            tags: ["Pets", "Human", "Transformation", "Personality"]
        ),
        
        Trend(
            name: "Disney Pixar",
            description: "Turn real photos into vibrant Disney/Pixar animated movie-style characters with big expressive eyes and cute proportions.",
            color: .cyan,
            icon: "sparkles",
            image: "DisneyPixarImage",
            category: .stylized,
            popularity: .viral,
            prompt: "Transform this photo into a vibrant Pixar-style character illustration, keeping the subject's main facial features and personal traits. Use vivid colors, smooth 3D shading, and a whimsical animated background that matches their personality. The image should look like a scene from a Pixar movie, with the person (or pet) depicted as a lovable animated character.",
            tags: ["Disney", "Pixar", "Animation", "3D", "Cartoon"]
        ),
        
        Trend(
            name: "Anime Manga",
            description: "Convert photos into Japanese anime-style portraits with big sparkly eyes, cel-shaded coloring, and dramatic anime hairstyles.",
            color: .purple,
            icon: "star.fill",
            image: "AnimeMangaImage",
            category: .stylized,
            popularity: .viral,
            prompt: "Turn the subject of this photo into a Japanese anime-style portrait. Preserve their key facial features, but render them with bold anime line art, large expressive eyes, and vibrant cel-shaded colors. The final image should resemble a frame from an anime film or a character illustration from a manga.",
            tags: ["Anime", "Manga", "Japanese", "Eyes", "Stylized"]
        ),
        
        Trend(
            name: "Tim Burton Gothic",
            description: "Transform into a Tim Burton-style character with pale skin, oversized hollow eyes, and gothic whimsy.",
            color: .gray,
            icon: "moon.fill",
            image: "TimBurtonGothicImage",
            category: .stylized,
            popularity: .popular,
            prompt: "Convert the subject in the photo into a Tim Burton-style character. Give them a slightly exaggerated, gothic look: think pale complexion, huge round eyes with dark circles, and quirky, Tim Burton-esque attire (striped or Victorian-inspired clothing). The background should have a whimsical spooky atmosphere (like a moonlit night or spiral hill), to capture that Burton film vibe.",
            tags: ["Tim Burton", "Gothic", "Spooky", "Pale", "Dark"]
        ),
        
        Trend(
            name: "90s Yearbook",
            description: "Transform modern selfies into authentic-looking 1990s yearbook photos with retro hairstyles and vintage studio backdrops.",
            color: .brown,
            icon: "book.fill",
            image: "NinetiesYearbookImage",
            category: .nostalgic,
            popularity: .trending,
            prompt: "Take this image and give it a 1990s high school yearbook photo look. Pose the subject in front of a classic '90s portrait backdrop (e.g. a blue gradient or laser grid). Apply soft, diffused lighting with a slight glow. Style their hair and clothing in late-80s/90s fashion (for example, feathered hair, a denim jacket or school sweater). The final image should look like an authentic retro yearbook portrait.",
            tags: ["90s", "Yearbook", "Retro", "Vintage", "Portrait"]
        ),
        
        Trend(
            name: "Fantasy Medieval",
            description: "Transform into epic fantasy characters with armor, medieval gowns, swords, and dragons in cinematic fantasy settings.",
            color: .indigo,
            icon: "crown.fill",
            image: "FantasyMedievalImage",
            category: .fantasy,
            popularity: .popular,
            prompt: "Imagine the subject in the photo as a character in a medieval fantasy realm. Design a detailed portrait where they are dressed in fantasy attire – for example, shining knight's armor with heraldry, or a mystical mage robe – and include appropriate props (sword, staff). The setting/background should be epic (castle hall, ancient forest, or battlefield at dusk). Render it in a cinematic, dramatic art style with realistic lighting, as if it's cover art for a fantasy novel.",
            tags: ["Fantasy", "Medieval", "Knight", "Magic", "Epic"]
        ),
        
        Trend(
            name: "Pokémon Card",
            description: "Create custom Pokémon-style trading cards featuring yourself or pets as Pokémon characters with stats and abilities.",
            color: .yellow,
            icon: "rectangle.portrait.fill",
            image: "PokemonCardImage",
            category: .gaming,
            popularity: .rising,
            prompt: "Create a custom Pokémon-style trading card featuring the subject of the photo. Portray them as a Pokémon character (for a pet, it can be an actual creature; for a person, a trainer or humanoid Pokémon). Include card elements: an illustrated figure of the subject in Pokémon art style (bold outlines, bright colors), a fitting elemental background (like fire, water splash, forest), and a card layout around it (title at top, some stats or moves at bottom). The image should emulate the look of an official Pokémon card.",
            tags: ["Pokémon", "Trading Card", "Gaming", "Nintendo", "Collectible"]
        )
    ]
    
    var trendingNow: [Trend] {
        allTrends.filter { $0.popularity == .viral || $0.popularity == .trending }
    }
    
    var categorizedTrends: [TrendCategory: [Trend]] {
        Dictionary(grouping: allTrends, by: { $0.category })
    }
    
    func trends(for category: TrendCategory) -> [Trend] {
        allTrends.filter { $0.category == category }
    }
} 