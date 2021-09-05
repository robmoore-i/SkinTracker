//
// Created by Rob on 5/9/21.
//

import SwiftUI

struct GalleryTabbedView: View {
    private let photoStorage: PhotoStorage

    private let photoResizer = PhotoResizer()

    init(_ photoStorage: PhotoStorage) {
        self.photoStorage = photoStorage
    }

    var body: some View {
        TabbedView(tabName: "Gallery", tabIconSfImageName: "photo.on.rectangle.angled") {
            List(photoStorage.allSorted(), id: \.hash) { photo in
                Image(uiImage: photoResizer.scale(photo: photo, toSize: CGSize(width: 100, height: 100)))
            }
        }
    }
}
