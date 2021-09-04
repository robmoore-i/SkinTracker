//
// Created by Rob on 4/9/21.
//

import SwiftUI

struct PhotoPreview: View {
    @Binding var formRecording: FormRecording

    var body: some View {
        if let photo = formRecording.photo {
            HStack {
                Spacer()
                Image(uiImage: scale(photo: photo, toSize: CGSize(width: 100, height: 100)))
                Spacer()
                Button(action: {
                    formRecording.removePhoto()
                }, label: {
                    Image(systemName: "minus.circle")
                            .scaleEffect(2, anchor: .center)
                            .foregroundColor(.red)
                            .padding()
                })
            }
        }
    }

    private func scale(photo: UIImage, toSize targetSize: CGSize) -> UIImage {
        // Compute the scaling ratio for the width and height separately
        let widthScaleRatio = targetSize.width / photo.size.width
        let heightScaleRatio = targetSize.height / photo.size.height

        // To keep the aspect ratio, scale by the smaller scaling ratio
        let scaleFactor = min(widthScaleRatio, heightScaleRatio)

        // Multiply the original photo’s dimensions by the scale factor
        // to determine the scaled photo size that preserves aspect ratio
        let scaledImageSize = CGSize(
                width: photo.size.width * scaleFactor,
                height: photo.size.height * scaleFactor
        )

        let renderer = UIGraphicsImageRenderer(size: scaledImageSize)
        let scaledPhoto = renderer.image { _ in
            photo.draw(in: CGRect(origin: .zero, size: scaledImageSize))
        }
        return scaledPhoto
    }
}
