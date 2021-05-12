//
// Created by Rob on 7/5/21.
//

import SwiftUI

private var emojis = ["🙏", "👊", "🙌", "👏", "👑", "🌞", "⭐️", "☀️", "🌈"]

struct TabHeader: View {
    private let text: String

    init(_ text: String) {
        self.text = text
    }

    func randomUniqueEmoji() -> String {
        emojis.remove(at: emojis.indices.randomElement()!)
    }

    var body: some View {
        HStack {
            Text("\(text) \(randomUniqueEmoji())")
                    .font(.largeTitle)
                    .fontWeight(.medium)
                    .foregroundColor(.black)
            Spacer()
        }.padding()
        Divider()
    }
}
