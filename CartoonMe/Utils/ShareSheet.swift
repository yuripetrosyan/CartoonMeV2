import SwiftUI
import UIKit
import Photos

// MARK: - SwiftUI wrapper that adds “Save to Photos” to the share sheet
struct ShareSheet: UIViewControllerRepresentable {
    /// Items to be shared (e.g. UIImage, URL…)
    let activityItems: [Any]
    /// Whether the custom Save-to-Photos action should be appended (default = true)
    var includeSaveToPhotos: Bool = true

    func makeUIViewController(context: Context) -> UIActivityViewController {
        // Append the custom activity when desired
        let customActivities: [UIActivity] = includeSaveToPhotos ? [SaveToPhotosActivity()] : []

        let controller = UIActivityViewController(
            activityItems: activityItems,
            applicationActivities: customActivities
        )
        return controller
    }

    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {
        // No updates required
    }
}

// MARK: - Custom UIActivity that stores an image in the user’s photo library
class SaveToPhotosActivity: UIActivity {
    private var image: UIImage?

    override var activityType: UIActivity.ActivityType? {
        UIActivity.ActivityType("com.cartoonme.saveToPhotos")
    }

    override var activityTitle: String? {
        "Save to Photos"
    }

    override var activityImage: UIImage? {
        UIImage(systemName: "photo.badge.plus")
    }

    // We can perform this activity only if at least one UIImage is passed in
    override func canPerform(withActivityItems activityItems: [Any]) -> Bool {
        activityItems.contains { $0 is UIImage }
    }

    // Grab the first UIImage from the items
    override func prepare(withActivityItems activityItems: [Any]) {
        image = activityItems.compactMap { $0 as? UIImage }.first
    }

    // Request permission (if needed) and write to the camera roll
    override func perform() {
        guard let image = image else {
            activityDidFinish(false)
            return
        }

        PHPhotoLibrary.requestAuthorization { status in
            DispatchQueue.main.async {
                if status == .authorized || status == .limited {
                    UIImageWriteToSavedPhotosAlbum(
                        image,
                        self,
                        #selector(self.image(_:didFinishSavingWithError:contextInfo:)),
                        nil
                    )
                } else {
                    self.activityDidFinish(false)
                }
            }
        }
    }

    @objc private func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        activityDidFinish(error == nil)
    }
}

// MARK: - Handy SwiftUI button that triggers the sheet in one tap
struct SaveToPhotosButton: View {
    let image: UIImage
    @State private var showShareSheet = false

    var body: some View {
        Button {
            showShareSheet = true
        } label: {
            Label("Save to Photos", systemImage: "photo.badge.plus")
        }
        .sheet(isPresented: $showShareSheet) {
            // The share sheet includes the custom action automatically
            ShareSheet(activityItems: [image])
        }
    }
}
