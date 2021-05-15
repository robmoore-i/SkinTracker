//
//  skintrackerApp.swift
//  skintracker
//
//  Created by Rob on 25/4/21.
//

import AppCenter
import AppCenterAnalytics
import AppCenterCrashes

import SwiftUI

@main
struct skintrackerApp: App {
    var body: some Scene {
        WindowGroup {
            MainView()
        }
    }

    init() {
        AppCenter.start(withAppSecret: "8edb0034-b2ca-4ffb-b8db-3278744e9f7a", services: [Analytics.self, Crashes.self])
    }
}
