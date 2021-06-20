//
//  MainView.swift
//  skintracker
//
//  Created by Rob on 25/4/21.
//

import SwiftUI

struct MainView: View {
    @State private var selectedTab = 1

    private let recordingStorage: RecordingStorage = RecordingStorage()

    var body: some View {
        TabView(selection: $selectedTab) {
            DashboardTabbedView(recordingStorage: recordingStorage, selectedTab: $selectedTab)
            RecordTabbedView(recordingStorage)
            VisualizeTabbedView(recordingStorage)
        }.animation(.linear)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
