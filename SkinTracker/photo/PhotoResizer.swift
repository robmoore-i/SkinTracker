//
// Created by Rob on 5/9/21.
//

import UIKit

struct PhotoResizer {
    func scale(photo: UIImage, toSize targetSize: CGSize) -> UIImage {
        // Scaling code taken from: https://www.advancedswift.com/resize-uiimage-no-stretching-swift/

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
        return UIGraphicsImageRenderer(size: scaledImageSize).image { _ in
            photo.draw(in: CGRect(origin: .zero, size: scaledImageSize))
        }
    }
}
