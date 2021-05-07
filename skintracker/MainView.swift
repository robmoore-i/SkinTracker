//
//  ContentView.swift
//  skintracker
//
//  Created by Rob on 25/4/21.
//

import SwiftUI

struct MainView: View {
    @State private var selectedTab = 2

    private let recordingStorage: RecordingStorage

    init() {
        recordingStorage = RecordingStorage()
    }

    var body: some View {
        TabView(selection: $selectedTab) {
            HomeTabbedView()
            RecordTabbedView(recordingStorage)
            VisualizeTabbedView(recordingStorage)
            LearnTabbedView()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
