//
// Created by Rob on 2/5/21.
//

import SwiftUI

private var tabCounter: Int = 1

private func nextTab() -> Int {
    tabCounter += 1
    return tabCounter - 1
}

struct TabbedView<Content: View>: View {
    let content: Content

    private let tabTitle: String
    private let tabSfImageName: String

    init(_ tabTitle: String, _ tabSfImageName: String, content: @escaping () -> Content) {
        self.content = content()
        self.tabTitle = tabTitle
        self.tabSfImageName = tabSfImageName
    }

    var body: some View {
        content.tabItem {
            Label(tabTitle, systemImage: tabSfImageName)
        }.tag(nextTab())
    }
}