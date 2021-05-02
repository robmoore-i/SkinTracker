//
// Created by Rob on 2/5/21.
//

import SwiftUI

struct TabbedView<Content: View>: View {
    let content: Content

    private let tabTitle: String
    private let tabSfImageName: String
    private let tabTag: Int

    init(_ tabTitle: String, _ tabSfImageName: String, _ tabTag: Int,
         @ViewBuilder content: @escaping () -> Content) {
        self.content = content()
        self.tabTitle = tabTitle
        self.tabSfImageName = tabSfImageName
        self.tabTag = tabTag
    }

    var body: some View {
        content
                .tabItem {
                    Label(tabTitle, systemImage: tabSfImageName)
                }
                .tag(tabTag)
    }
}