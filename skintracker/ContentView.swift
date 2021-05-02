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
            TabbedView("Record", "plus.square", 1) {
                Form {
                    Section {
                        Text("First View")
                    }
                }
            }

            TabbedView("Visualize", "chart.bar.xaxis", 2) {
                Text("Second View")
                        .padding()
            }

            TabbedView("Learn", "book.closed", 3) {
                Text("Third View")
                        .padding()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
