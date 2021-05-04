//
//  ContentView.swift
//  skintracker
//
//  Created by Rob on 25/4/21.
//

import SwiftUI

struct MainView: View {
    @State private var selectedTab = 2

    var body: some View {
        TabView(selection: $selectedTab) {
            HomeTabbedView()
            RecordTabbedView()
            VisualizeTabbedView()
            LearnTabbedView()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
