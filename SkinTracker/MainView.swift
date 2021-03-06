//
//  MainView.swift
//  skintracker
//
//  Created by Rob on 25/4/21.
//

import SwiftUI

struct MainView: View {
    @State private var selectedTab = 1

    private let recordingStorage: RecordingStorage = RecordingStorage(RealmStorageProvider())
    private let photoStorage: PhotoStorage = PhotoStorage(FileSystem(FileManager.default))

    var body: some View {
        TabView(selection: $selectedTab) {
            DashboardTabbedView(recordingStorage, photoStorage, $selectedTab)
            RecordTabbedView(recordingStorage, photoStorage)
            VisualizeTabbedView(recordingStorage)

            // Disabled because it's not well integrated into the rest of the app, and hurts the overall quality of the
            // user experience, such as when importing/exporting data, and also with respect to the speed of the app,
            // because the gallery view is not optimised to be lazy, so when the number of photos reaches a certain,
            // fairly low, number, the performance will start to really hurt. It also isn't well integrated into usage
            // analytics capture.
            // GalleryTabbedView(photoStorage)
        }.animation(.linear)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
