//
// Created by Rob on 2/5/21.
//

import SwiftUI

struct LearnTabbedView: View {

    let emojis = ["🙏", "👊", "🙌", "👏", "👑", "🌞", "⭐️", "☀️", "🌈"]

    var body: some View {
        TabbedView("Learn", "book.closed") {
            VStack(spacing: 0) {
                TabHeader("Keep informed \(emojis.randomElement()!)")
                Text("Learn view").padding()
                Spacer()
            }
        }
    }
}
