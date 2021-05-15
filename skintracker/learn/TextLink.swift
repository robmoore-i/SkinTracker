//
// Created by Rob on 15/5/21.
//

import SwiftUI

struct TextLink<Content: View>: View {
    private let text: String
    private let to: Content

    init(_ text: String, _ to: @escaping () -> Content) {
        self.text = text
        self.to = to()
    }

    var body: some View {
        NavigationLink(destination: to) {
            Text(text)
        }
    }
}