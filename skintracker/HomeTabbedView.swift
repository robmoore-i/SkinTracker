//
//  HomeTabbedView.swift
//  skintracker
//
//  Created by Rob on 4/5/21.
//

import SwiftUI

struct HomeTabbedView: View {
    var body: some View {
        TabbedView("Home", "house"){
            Text("Home View").padding()
        }
    }
}
