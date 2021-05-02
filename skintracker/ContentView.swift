//
//  ContentView.swift
//  skintracker
//
//  Created by Rob on 25/4/21.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            RecordTabbedView()
            VisualizeTabbedView()
            LearnTabbedView()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
