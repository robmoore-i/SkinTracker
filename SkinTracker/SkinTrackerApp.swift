//
//  skintrackerApp.swift
//  skintracker
//
//  Created by Rob on 25/4/21.
//

import SwiftUI

@main
struct SkinTrackerApp: App {
    var body: some Scene {
        WindowGroup {
            MainView()
        }
    }

    init() {
        UsageAnalytics.setup()
    }
}
