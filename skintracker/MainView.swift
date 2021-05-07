//
//  ContentView.swift
//  skintracker
//
//  Created by Rob on 25/4/21.
//

import SwiftUI
import RealmSwift

struct MainView: View {
    @State private var selectedTab = 2

    private let realm: Realm

    init() {
        do {
            realm = try Realm()
        } catch let error {
            print(error.localizedDescription)
            fatalError("Couldn't initialise Realm")
        }
    }

    var body: some View {
        TabView(selection: $selectedTab) {
            HomeTabbedView()
            RecordTabbedView(realm)
            VisualizeTabbedView(realm)
            LearnTabbedView()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
