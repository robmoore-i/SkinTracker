//
// Created by Rob on 5/9/21.
//

import SwiftUI

struct GalleryTabbedView: View {
    let photoStorage: PhotoStorage

    init(_ photoStorage: PhotoStorage) {
        self.photoStorage = photoStorage
    }

    var body: some View {
        TabbedView(tabName: "Gallery", tabIconSfImageName: "photo.on.rectangle.angled") {
            Text("Memes")
        }
    }
}
