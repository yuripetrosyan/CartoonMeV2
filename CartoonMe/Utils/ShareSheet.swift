import SwiftUI
import UIKit
import Photos

struct ShareSheet: UIViewControllerRepresentable {
    let activityItems: [Any]
    let applicationActivities: [UIActivity]? = nil

    func makeUIViewController(context: Context) -> UIActivityViewController {
        let controller = UIActivityViewController(activityItems: activityItems, applicationActivities: applicationActivities)
        return controller
    }

    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {
        // Nothing to update here
    }
}

// Custom activity for saving to photo library with custom UI
class SaveToPhotosActivity: UIActivity {
    private var image: UIImage?
    
    override var activityType: UIActivity.ActivityType? {
        return UIActivity.ActivityType("com.cartoonme.saveToPhotos")
    }
    
    override var activityTitle: String? {
        return "Save to Photos"
    }
    
    override var activityImage: UIImage? {
        return UIImage(systemName: "photo.badge.plus")
    }
    
    override func canPerform(withActivityItems activityItems: [Any]) -> Bool {
        return activityItems.contains { $0 is UIImage }
    }
    
    override func prepare(withActivityItems activityItems: [Any]) {
        image = activityItems.compactMap { $0 as? UIImage }.first
    }
    
    override func perform() {
        guard let image = image else {
            activityDidFinish(false)
            return
        }
        
        PHPhotoLibrary.requestAuthorization { status in
            DispatchQueue.main.async {
                switch status {
                case .authorized, .limited:
                    UIImageWriteToSavedPhotosAlbum(image, self, #selector(self.image(_:didFinishSavingWithError:contextInfo:)), nil)
                default:
                    self.activityDidFinish(false)
                }
            }
        }
    }
    
    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        activityDidFinish(error == nil)
    }
} 