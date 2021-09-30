//
// Created by Rob on 26/9/21.
//

import Foundation
import UIKit
import SwiftUI

struct DatedPhoto {
    private let photoPresenter = PhotoPresenter()

    private let photo: UIImage
    private let dateTag: String

    public let hash: Int

    init(photo: UIImage, dateTag: String) {
        self.photo = photo
        self.dateTag = dateTag
        self.hash = photo.hash
    }

    func upright() -> DatedPhoto? {
        photo.cgImage.map({ cgImage in
            DatedPhoto(photo: UIImage(cgImage: cgImage, scale: 1.0, orientation: .right), dateTag: dateTag)
        })
    }

    func scaledImage(toSize targetSize: CGSize) -> UIImage {
        photoPresenter.scale(photo: photo, toSize: targetSize)
    }

    func descriptionText() -> String {
        dateTag
    }

    static func ==(lhs: DatedPhoto, rhs: DatedPhoto) -> Bool {
        lhs.photo == rhs.photo && lhs.dateTag == rhs.dateTag
    }
}