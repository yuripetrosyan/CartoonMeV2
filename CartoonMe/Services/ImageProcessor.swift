// ImageProcessor.swift
import Foundation
import UIKit
import Vision // Added Vision framework
import CoreImage
import CoreImage.CIFilterBuiltins

// Extension to resize UIImage to fit within a max pixel count
extension UIImage {
    func resizedToFit(maxPixelCount: Int) -> UIImage? {
        let currentPixelCount = Int(size.width * size.height)
        if currentPixelCount <= maxPixelCount && currentPixelCount > 0 {
            return self
        }
        guard size.height > 0 else {
            print("Warning: Image height is zero.")
            return nil
        }
        let aspectRatio = size.width / size.height
        guard aspectRatio > 0 else {
            print("Warning: Image aspect ratio is zero or negative.")
            return nil
        }
        let newHeight = floor(sqrt(CGFloat(maxPixelCount) / aspectRatio))
        let newWidth = floor(newHeight * aspectRatio)
        let newSize = CGSize(width: newWidth, height: newHeight)
        guard newSize.width > 0 && newSize.height > 0 else {
            print("Warning: Calculated new size has zero width or height. Original: \(self.size), MaxPixels: \(maxPixelCount)")
            return UIGraphicsGetImageFromCurrentImageContext()
        }
        UIGraphicsBeginImageContextWithOptions(newSize, false, self.scale)
        defer { UIGraphicsEndImageContext() }
        self.draw(in: CGRect(origin: .zero, size: newSize))
        return UIGraphicsGetImageFromCurrentImageContext()
    }
    
    // Fix image orientation to avoid rotation issues
    func fixOrientation() -> UIImage {
        // If the orientation is already correct, return the image
        if self.imageOrientation == .up {
            return self
        }
        
        // Create a new image with the correct orientation
        UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale)
        self.draw(in: CGRect(origin: .zero, size: self.size))
        let normalizedImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        return normalizedImage
    }
    
    func fixedOrientation() throws -> UIImage {
        guard imageOrientation != .up else { return self }
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        defer { UIGraphicsEndImageContext() }
        draw(in: CGRect(origin: .zero, size: size))
        guard let normalized = UIGraphicsGetImageFromCurrentImageContext() else {
            throw NSError(domain: "ImageStylizer", code: -3, userInfo: [NSLocalizedDescriptionKey: "Could not normalise orientation"])
        }
        return normalized
    }
    
    // Convert UIImage to base64 string
    func toBase64String() -> String? {
        guard let imageData = self.jpegData(compressionQuality: 0.8) else {
            return nil
        }
        return imageData.base64EncodedString()
    }
    
    // Add effects for progress visualization simulation
    func applyFilter(intensity: Float) -> UIImage? {
        // Fix orientation first to ensure consistent processing
        let orientedImage = self.fixOrientation()
        
        guard let cgImage = orientedImage.cgImage else { return nil }
        let ciImage = CIImage(cgImage: cgImage)
        let context = CIContext()
        
        // Use different effects based on progress stage to simulate generation
        let filterIntensity = min(1.0, max(0.0, intensity))
        
        if filterIntensity < 0.3 {
            // Initial stage: Pixelation and blur
            let pixellateFilter = CIFilter.pixellate()
            pixellateFilter.inputImage = ciImage
            pixellateFilter.scale = 20 * (0.3 - filterIntensity) / 0.3 + 5
            
            guard let outputImage = pixellateFilter.outputImage else { return nil }
            
            let blurFilter = CIFilter.gaussianBlur()
            blurFilter.inputImage = outputImage
            blurFilter.radius = 10 * (0.3 - filterIntensity) / 0.3 + 2
            
            guard let finalImage = blurFilter.outputImage,
                  let cgImg = context.createCGImage(finalImage, from: finalImage.extent) else { return nil }
            return UIImage(cgImage: cgImg)
        } else if filterIntensity < 0.7 {
            // Middle stage: Reduced pixelation, sketch-like effect
            let pixellateFilter = CIFilter.pixellate()
            pixellateFilter.inputImage = ciImage
            pixellateFilter.scale = 10 * (0.7 - filterIntensity) / 0.4 + 2
            
            guard let outputImage = pixellateFilter.outputImage else { return nil }
            
            let edgesFilter = CIFilter.edges()
            edgesFilter.inputImage = outputImage
            edgesFilter.intensity = 2 * (0.7 - filterIntensity) / 0.4
            
            guard let edgeImage = edgesFilter.outputImage else { return nil }
            
            let blendFilter = CIFilter.sourceOverCompositing()
            blendFilter.inputImage = edgeImage
            blendFilter.backgroundImage = outputImage
            
            guard let finalImage = blendFilter.outputImage,
                  let cgImg = context.createCGImage(finalImage, from: finalImage.extent) else { return nil }
            return UIImage(cgImage: cgImg)
        } else {
            // Final stage: Cartoon effect with more details
            let colorFilter = CIFilter.colorControls()
            colorFilter.inputImage = ciImage
            colorFilter.saturation = 1.2 + (filterIntensity - 0.7) * 0.5
            colorFilter.brightness = 0.05
            colorFilter.contrast = 1.1
            
            guard let outputImage = colorFilter.outputImage else { return nil }
            
            let sharpenFilter = CIFilter.sharpenLuminance()
            sharpenFilter.inputImage = outputImage
            sharpenFilter.sharpness = (filterIntensity - 0.7) * 5
            
            guard let finalImage = sharpenFilter.outputImage,
                  let cgImg = context.createCGImage(finalImage, from: finalImage.extent) else { return nil }
            return UIImage(cgImage: cgImg)
        }
    }
}

// MARK: – Public API ---------------------------------------------------------

/// Supported high-level styles. Each case carries its guidance & negatives.
public enum ArtStyle: String, CaseIterable {
    case studioGhibli = "Studio Gibli"
    case simpsons     = "Simpsons"
    case disney3D     = "Disney 3D"
    case modernAnime  = "Modern Anime"
    case comicBook    = "Comic Book"
    case semiRealistic = "Semi-Realistic"
    case genericCartoon = "Generic Cartoon"

    /// Positive guidance. Must *never* mention a living artist by name.
    var prompt: String {
        switch self {
        case .studioGhibli:
            return "anime style studio gibili"
        case .simpsons:
            return "Simpsons cartoon style"
        case .disney3D:
            return "Disney 3D animation style"
        case .modernAnime:
            return "Modern anime style"
        case .comicBook:
            return "Comic book illustration style"
        case .semiRealistic:
            return "Semi-realistic cartoon style"
        case .genericCartoon:
            return "Generic cartoon style"
        }
    }

    /// Negative guidance to keep the model from drifting.
    var negativePrompt: String {
        switch self {
        case .studioGhibli:
            return "harsh lines, neon colors, digital CGI, modern technology"
        case .simpsons:
            return "3D rendering, realistic skin, detailed shading, complex backgrounds"
        case .disney3D:
            return "2D flat style, sketch lines, dark themes, rough textures"
        case .modernAnime:
            return "western cartoon, photorealism, heavy outlines, muted colors"
        case .comicBook:
            return "soft shading, pastel colors, minimalist design, watercolor style"
        case .semiRealistic:
            return "exaggerated cartoon, harsh outlines, flat colors, simple shapes"
        case .genericCartoon:
            return "photorealistic, complex details, dark themes, rough sketches"
        }
    }
}

/// Completion payload.
public struct StylizeResult {
    public let image: UIImage
    public let costInTokens: Int
}

/// Progress callback signature.
public typealias StylizeProgress = (_ preview: UIImage, _ fraction: Float) -> Void

/// Main facade – call `stylize(...)` and await the result.
public final class ImageStylizer {

    // MARK: Configuration ----------------------------------------------------
    public static let shared = ImageStylizer()
    private init() {}

    private let maxPixels = 4_000_000 // 4 MP cap to keep uploads light
    private let openAIKey = ProcessInfo.processInfo.environment["OPENAI_API_KEY"] ?? ""

    private let chatURL = URL(string: "https://api.openai.com/v1/chat/completions")!
    private let imageURL = URL(string: "https://api.openai.com/v1/images/generations")!

    private let ciContext = CIContext()

    // MARK: Public entry point ----------------------------------------------

    /// Stylise *image* in *style*.  The completion runs on the main thread.
    @discardableResult
    public func stylize(image uiImage: UIImage,
                        as style: ArtStyle,
                        progress: @escaping StylizeProgress = {_,_  in},
                        completion: @escaping (Result<StylizeResult, Error>) -> Void) -> Task<Void, Never> {
        Task {
            do {
                // Step 0 – hygiene --------------------------------------------------
                let base = try uiImage
                    .fixedOrientation()
                    .resizedToFit(maxPixelCount: maxPixels)
                    ?? uiImage // fallback

                // Step 1 – what's in the picture? --------------------------------
                let (description, containsPerson) = try await describe(base)

                // Step 2 – build final prompt -------------------------------------
                let finalPrompt = Self.composePrompt(from: description,
                                                      style: style,
                                                      containsPerson: containsPerson)

                // Step 3 – launch generation + fake progress ----------------------
                let stream = ProgressStreamer(original: base, ciContext: ciContext)
                stream.start { img, f in progress(img, f) }

                let stylisedImage = try await generate(with: finalPrompt, referenceImage: base)
                stream.finish(with: stylisedImage) { img in progress(img, 1) }

                completion(.success(.init(image: stylisedImage, costInTokens: description.tokenCount)))
            } catch {
                completion(.failure(error))
            }
        }
    }

    /// Hit gpt-image-1 with the image-to-image edit endpoint using multipart/form-data.
    private func generate(with prompt: String, referenceImage: UIImage) async throws -> UIImage {
        // Calculate optimal dimensions maintaining aspect ratio
        let targetSize = calculateOptimalSize(for: referenceImage.size)
        let editURL = URL(string: "https://api.openai.com/v1/images/edits")!
        var lastError: Error?
        for attempt in 1...2 {
            do {
                // Prepare the image data
                guard let imageData = referenceImage.jpegData(compressionQuality: 0.85) else {
                    throw NSError(domain: "ImageStylizer", code: -1, userInfo: [NSLocalizedDescriptionKey: "Could not convert image to JPEG"])
                }
                let boundary = "Boundary-\(UUID().uuidString)"
                var body = Data()
                // Add model
                body.append("--\(boundary)\r\n".data(using: .utf8)!)
                body.append("Content-Disposition: form-data; name=\"model\"\r\n\r\n".data(using: .utf8)!)
                body.append("gpt-image-1\r\n".data(using: .utf8)!)
                // Add prompt
                body.append("--\(boundary)\r\n".data(using: .utf8)!)
                body.append("Content-Disposition: form-data; name=\"prompt\"\r\n\r\n".data(using: .utf8)!)
                body.append("\(prompt)\r\n".data(using: .utf8)!)
                // Add image
                body.append("--\(boundary)\r\n".data(using: .utf8)!)
                body.append("Content-Disposition: form-data; name=\"image\"; filename=\"image.jpg\"\r\n".data(using: .utf8)!)
                body.append("Content-Type: image/jpeg\r\n\r\n".data(using: .utf8)!)
                body.append(imageData)
                body.append("\r\n".data(using: .utf8)!)
                // Add size
                body.append("--\(boundary)\r\n".data(using: .utf8)!)
                body.append("Content-Disposition: form-data; name=\"size\"\r\n\r\n".data(using: .utf8)!)
                body.append("\(Int(targetSize.width))x\(Int(targetSize.height))\r\n".data(using: .utf8)!)
                // Add quality (medium = cheaper than hd)
                body.append("--\(boundary)\r\n".data(using: .utf8)!)
                body.append("Content-Disposition: form-data; name=\"quality\"\r\n\r\n".data(using: .utf8)!)
                body.append("medium\r\n".data(using: .utf8)!)
                // End boundary
                body.append("--\(boundary)--\r\n".data(using: .utf8)!)
                // Create request
                var request = URLRequest(url: editURL)
                request.httpMethod = "POST"
                request.httpBody = body
                request.setValue("Bearer \(openAIKey)", forHTTPHeaderField: "Authorization")
                request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
                let (data, response) = try await URLSession.shared.data(for: request)
                guard (response as? HTTPURLResponse)?.statusCode == 200 else {
                    let errorMsg = String(data: data, encoding: .utf8) ?? "<binary>"
                    throw NSError(domain: "ImageStylizer", code: -2, userInfo: [NSLocalizedDescriptionKey: errorMsg])
                }
                guard
                    let root = try JSONSerialization.jsonObject(with: data) as? [String: Any],
                    let responseData = (root["data"] as? [[String: Any]])?.first,
                    let b64 = responseData["b64_json"] as? String,
                    let imgData = Data(base64Encoded: b64),
                    let uiImg = UIImage(data: imgData)
                else {
                    throw NSError(domain: "ImageStylizer", code: -1, userInfo: [NSLocalizedDescriptionKey: "Bad JSON response"])
                }
                return uiImg
            } catch {
                lastError = error
                let errorString = error.localizedDescription
                if errorString.contains("safety system") || errorString.contains("moderation_blocked") {
                    print("⚠️ Attempt \(attempt) blocked by safety system")
                    if attempt < 2 {
                        try await Task.sleep(nanoseconds: 1_000_000_000)
                        continue
                    } else {
                        throw NSError(domain: "ImageStylizer", code: -2, userInfo: [NSLocalizedDescriptionKey: "Content was blocked by OpenAI's safety system. Try a different photo or simpler prompt."])
                    }
                } else {
                    throw error
                }
            }
        }
        throw lastError ?? NSError(domain: "ImageStylizer", code: -3, userInfo: [NSLocalizedDescriptionKey: "Unknown error"])
    }

    // MARK: – Private helpers ----------------------------------------------------
    
    /// Calculate optimal output dimensions from supported API sizes
    private func calculateOptimalSize(for originalSize: CGSize) -> CGSize {
        // API only supports these specific sizes
        let supportedSizes: [CGSize] = [
            CGSize(width: 1024, height: 1024),  // Square
            CGSize(width: 1024, height: 1536),  // Portrait
            CGSize(width: 1536, height: 1024)   // Landscape
        ]
        
        // Calculate aspect ratio of original image
        let originalAspectRatio = originalSize.width / originalSize.height
        
        // Find the supported size that best matches the original aspect ratio
        var bestSize = supportedSizes[0] // Default to square
        var smallestAspectRatioDifference: CGFloat = .greatestFiniteMagnitude
        
        for size in supportedSizes {
            let sizeAspectRatio = size.width / size.height
            let aspectRatioDifference = abs(originalAspectRatio - sizeAspectRatio)
            
            if aspectRatioDifference < smallestAspectRatioDifference {
                smallestAspectRatioDifference = aspectRatioDifference
                bestSize = size
            }
        }
        
        return bestSize
    }
    /// Ask GPT-4o to describe the scene in neutral, privacy-safe terms.
    private func describe(_ img: UIImage) async throws -> (text: String, person: Bool) {
        let jpeg = img.jpegData(compressionQuality: 0.85)!
        let b64  = jpeg.base64EncodedString()

        let visionPrompt = """
        Describe this scene for artistic reference, focusing on composition, pose, and visual elements. Include:
        - Camera angle and viewpoint (close-up, medium shot, wide shot, high angle, low angle, eye level, etc.)
        - Overall composition and framing
        - Subject positioning and pose
        - Clothing colors and general style
        - Background elements and setting
        - Lighting direction and mood
        - Any accessories or objects visible
        
        Use neutral artistic terms. Refer to any people as \"the subject\" or \"figure\". Avoid detailed facial descriptions. Keep under 120 words for style reference.
        """

        let body: [String: Any] = [
            "model": "gpt-4o-mini", // much cheaper alternative to gpt-4o
            "messages": [[
                "role": "user",
                "content": [["type": "text", "text": visionPrompt],
                             ["type": "image_url", "image_url": ["url": "data:image/jpeg;base64,\(b64)", "detail": "low"]]]
            ]],
            "max_tokens": 300, // reduced from 450 to save costs
            "temperature": 0.8
        ]

        let json = try JSONSerialization.data(withJSONObject: body)
        let txt = try await Self.post(url: chatURL, key: openAIKey, payload: json)

        // Conservative detection: only flag if explicitly mentions person/human terms
        let person = txt.range(of: #"\b(person|people|human|man|woman|child|face|figure|subject)\b"#, options: [.regularExpression, .caseInsensitive]) != nil
        return (txt, person)
    }

    /// Static helper to POST and read a *string* response.
    private static func post(url: URL, key: String, payload: Data) async throws -> String {
        var req = URLRequest(url: url)
        req.httpMethod = "POST"
        req.httpBody   = payload
        req.setValue("Bearer \(key)", forHTTPHeaderField: "Authorization")
        req.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let (data, resp) = try await URLSession.shared.data(for: req)
        guard (resp as? HTTPURLResponse)?.statusCode == 200 else {
            let msg = String(data: data, encoding: .utf8) ?? "<binary>"
            throw NSError(domain: "ImageStylizer", code: -2, userInfo: [NSLocalizedDescriptionKey: msg])
        }
        return String(data: data, encoding: .utf8) ?? ""
    }

    /// Merge description + style into the *ultimate* prompt.
    private static func composePrompt(from desc: String, style: ArtStyle, containsPerson: Bool) -> String {
        // Enhanced text-only approach with detailed descriptions for better fidelity
        
        let basePrompt: String
        if containsPerson {
            // Detailed guidance for people using comprehensive text description
            basePrompt = """
            Create a \(style.rawValue) style artwork with this exact composition:
            
            \(desc)
            
            Recreate this scene precisely: maintain the exact camera angle, subject pose, framing, lighting direction, clothing colors, and background elements as described. Keep the same spatial relationships and composition.
            
            Art style: \(style.prompt)
            Avoid: \(style.negativePrompt)
            """
        } else {
            // Detailed approach for non-human scenes
            basePrompt = """
            Create a \(style.rawValue) style illustration of this scene:
            
            \(desc)
            
            Recreate the exact composition, camera angle, lighting, colors, and spatial arrangement described. Maintain all visual elements and their positions precisely.
            
            Art style: \(style.prompt)
            Avoid: \(style.negativePrompt)
            """
        }
        
        return basePrompt
    }
}

// MARK: – Progress stream ----------------------------------------------------
private final class ProgressStreamer {
    private let original: UIImage
    private let ctx: CIContext
    private var timer: DispatchSourceTimer?

    init(original: UIImage, ciContext: CIContext) {
        self.original = original
        self.ctx = ciContext
    }

    func start(update: @escaping StylizeProgress) {
        var step: Float = 0
        timer = DispatchSource.makeTimerSource()
        timer?.schedule(deadline: .now(), repeating: 0.25)
        timer?.setEventHandler { [weak self] in
            guard let self else { return }
            step += 0.05
            if step >= 0.95 { step = 0.95 }
            let preview = self.glitch(intensity: step)
            DispatchQueue.main.async { update(preview, step) }
        }
        timer?.resume()
    }

    func finish(with final: UIImage, completion: (UIImage) -> Void ) {
        timer?.cancel()
        completion(final)
    }

    /// Core-Image glitch for progress illusion.
    private func glitch(intensity: Float) -> UIImage {
        let ci = CIImage(image: original)!
        let pix = CIFilter.pixellate()
        pix.inputImage = ci
        pix.scale = 40 * (1 - intensity) + 2
        let blur = CIFilter.gaussianBlur()
        blur.inputImage = pix.outputImage
        blur.radius = 15 * (1 - intensity) + 1
        let out = blur.outputImage!
        let cg = ctx.createCGImage(out, from: out.extent)!
        return UIImage(cgImage: cg)
    }
}

// MARK: – Misc ---------------------------------------------------------------
private extension String {
    /// Brutally simple token count approximation (for cost debugging).
    var tokenCount: Int { split { $0 == " " || $0 == "\n" }.count }
}

// MARK: – Legacy API Compatibility ------------------------------------------
// Bridge to maintain compatibility with existing ContentView.swift

class ImageProcessor {
    static let shared = ImageProcessor()
    private init() {}
    
    func cartoonify(image: UIImage,
                    theme: String,
                    customControlStrength: Double? = nil,
                    progressCallback: @escaping (UIImage, Float) -> Void = { _, _ in },
                    completion: @escaping (UIImage?) -> Void) {
        
        // Map theme string to ArtStyle enum
        let artStyle: ArtStyle
        switch theme.lowercased().trimmingCharacters(in: .whitespacesAndNewlines) {
        case "studio ghibli":
            artStyle = .studioGhibli
        case "simpsons", "the simpsons":
            artStyle = .simpsons
        case "disney", "disney 3d", "pixar style", "pixar":
            artStyle = .disney3D
        case "anime", "anime style", "modern anime", "manga":
            artStyle = .modernAnime
        case "marvel comic", "marvel", "comic book":
            artStyle = .comicBook
        default:
            artStyle = .genericCartoon
        }
        
        // Use the new ImageStylizer
        ImageStylizer.shared.stylize(
            image: image,
            as: artStyle,
            progress: progressCallback
        ) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let stylizeResult):
                    completion(stylizeResult.image)
                case .failure(let error):
                    print("❌ Stylization failed: \(error.localizedDescription)")
                    completion(nil)
                }
            }
        }
    }

    func transformWithTrend(image: UIImage,
                           trend: Trend,
                           progressCallback: @escaping (UIImage, Float) -> Void = { _, _ in },
                           completion: @escaping (UIImage?) -> Void) {
        
        // Use ImageStylizer with a custom trend-based approach
        Task {
            do {
                // Step 0 – hygiene --------------------------------------------------
                let base = try image
                    .fixedOrientation()
                    .resizedToFit(maxPixelCount: 4_000_000)
                    ?? image // fallback

                // Step 1 – create trend prompt directly using the trend's prompt
                let trendPrompt = trend.prompt

                // Step 2 – launch generation + fake progress ----------------------
                let progressStreamer = TrendProgressStreamer(original: base)
                progressStreamer.start { img, f in progressCallback(img, f) }

                let transformedImage = try await self.generateWithTrendPrompt(prompt: trendPrompt, referenceImage: base)
                progressStreamer.finish(with: transformedImage) { img in progressCallback(img, 1) }

                DispatchQueue.main.async {
                    completion(transformedImage)
                }
            } catch {
                print("❌ Trend transformation failed: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    completion(nil)
                }
            }
        }
    }
    
    /// Generate image using trend-specific prompt
    private func generateWithTrendPrompt(prompt: String, referenceImage: UIImage) async throws -> UIImage {
        let openAIKey = ProcessInfo.processInfo.environment["OPENAI_API_KEY"] ?? ""
        
        // Calculate optimal dimensions maintaining aspect ratio
        let targetSize = self.calculateOptimalSize(for: referenceImage.size)
        let editURL = URL(string: "https://api.openai.com/v1/images/edits")!
        
        // Prepare the image data
        guard let imageData = referenceImage.jpegData(compressionQuality: 0.85) else {
            throw NSError(domain: "ImageProcessor", code: -1, userInfo: [NSLocalizedDescriptionKey: "Could not convert image to JPEG"])
        }
        
        let boundary = "Boundary-\(UUID().uuidString)"
        var body = Data()
        
        // Add model
        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"model\"\r\n\r\n".data(using: .utf8)!)
        body.append("gpt-image-1\r\n".data(using: .utf8)!)
        
        // Add prompt
        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"prompt\"\r\n\r\n".data(using: .utf8)!)
        body.append("\(prompt)\r\n".data(using: .utf8)!)
        
        // Add image
        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"image\"; filename=\"image.jpg\"\r\n".data(using: .utf8)!)
        body.append("Content-Type: image/jpeg\r\n\r\n".data(using: .utf8)!)
        body.append(imageData)
        body.append("\r\n".data(using: .utf8)!)
        
        // Add size
        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"size\"\r\n\r\n".data(using: .utf8)!)
        body.append("\(Int(targetSize.width))x\(Int(targetSize.height))\r\n".data(using: .utf8)!)
        
        // Add quality
        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"quality\"\r\n\r\n".data(using: .utf8)!)
        body.append("medium\r\n".data(using: .utf8)!)
        
        // End boundary
        body.append("--\(boundary)--\r\n".data(using: .utf8)!)
        
        // Create request
        var request = URLRequest(url: editURL)
        request.httpMethod = "POST"
        request.httpBody = body
        request.setValue("Bearer \(openAIKey)", forHTTPHeaderField: "Authorization")
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        let (data, response) = try await URLSession.shared.data(for: request)
        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
            let errorMsg = String(data: data, encoding: .utf8) ?? "<binary>"
            throw NSError(domain: "ImageProcessor", code: -2, userInfo: [NSLocalizedDescriptionKey: errorMsg])
        }
        
        guard
            let root = try JSONSerialization.jsonObject(with: data) as? [String: Any],
            let responseData = (root["data"] as? [[String: Any]])?.first,
            let b64 = responseData["b64_json"] as? String,
            let imgData = Data(base64Encoded: b64),
            let uiImg = UIImage(data: imgData)
        else {
            throw NSError(domain: "ImageProcessor", code: -1, userInfo: [NSLocalizedDescriptionKey: "Bad JSON response"])
        }
        
        return uiImg
    }
    
    /// Calculate optimal output dimensions from supported API sizes
    private func calculateOptimalSize(for originalSize: CGSize) -> CGSize {
        // API only supports these specific sizes
        let supportedSizes: [CGSize] = [
            CGSize(width: 1024, height: 1024),  // Square
            CGSize(width: 1024, height: 1536),  // Portrait
            CGSize(width: 1536, height: 1024)   // Landscape
        ]
        
        // Calculate aspect ratio of original image
        let originalAspectRatio = originalSize.width / originalSize.height
        
        // Find the supported size that best matches the original aspect ratio
        var bestSize = supportedSizes[0] // Default to square
        var smallestAspectRatioDifference: CGFloat = .greatestFiniteMagnitude
        
        for size in supportedSizes {
            let sizeAspectRatio = size.width / size.height
            let aspectRatioDifference = abs(originalAspectRatio - sizeAspectRatio)
            
            if aspectRatioDifference < smallestAspectRatioDifference {
                smallestAspectRatioDifference = aspectRatioDifference
                bestSize = size
            }
        }
        
        return bestSize
    }
}

// MARK: – Trend Progress stream ----------------------------------------------------
private final class TrendProgressStreamer {
    private let original: UIImage
    private let ctx = CIContext()
    private var timer: DispatchSourceTimer?

    init(original: UIImage) {
        self.original = original
    }

    func start(update: @escaping (UIImage, Float) -> Void) {
        var step: Float = 0
        timer = DispatchSource.makeTimerSource()
        timer?.schedule(deadline: .now(), repeating: 0.25)
        timer?.setEventHandler { [weak self] in
            guard let self else { return }
            step += 0.05
            if step >= 0.95 { step = 0.95 }
            let preview = self.glitch(intensity: step)
            DispatchQueue.main.async { update(preview, step) }
        }
        timer?.resume()
    }

    func finish(with final: UIImage, completion: (UIImage) -> Void ) {
        timer?.cancel()
        completion(final)
    }

    /// Core-Image glitch for progress illusion.
    private func glitch(intensity: Float) -> UIImage {
        let ci = CIImage(image: original)!
        let pix = CIFilter.pixellate()
        pix.inputImage = ci
        pix.scale = 40 * (1 - intensity) + 2
        let blur = CIFilter.gaussianBlur()
        blur.inputImage = pix.outputImage
        blur.radius = 15 * (1 - intensity) + 1
        let out = blur.outputImage!
        let cg = ctx.createCGImage(out, from: out.extent)!
        return UIImage(cgImage: cg)
    }
}
