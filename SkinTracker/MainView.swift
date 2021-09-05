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
            GalleryTabbedView(photoStorage)
        }.animation(.linear)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
