//
// Created by Rob on 5/9/21.
//

import SwiftUI

struct GalleryTabbedView: View {
    private let photoStorage: PhotoStorage

    init(_ photoStorage: PhotoStorage) {
        self.photoStorage = photoStorage
    }

    var body: some View {
        TabbedView(tabName: "Gallery", tabIconSfImageName: "photo.on.rectangle.angled") {
            List(allPhotos(), id: \.hash) { photo in
                HStack {
                    Image(uiImage: photo.scaledImage(toSize: CGSize(width: 100, height: 100)))
                    Text(photo.descriptionText())
                }
            }
        }
    }

    private func allPhotos() -> [DatedPhoto] {
        photoStorage.allSorted().compactMap { photo in
            photo.upright()
        }
    }
}
