//
// Created by Rob on 7/5/21.
//

import SwiftUI

struct TabHeader: View {
    private let text: String

    init(_ text: String) {
        self.text = text
    }

    var body: some View {
        HStack {
            Text("\(text)")
                    .font(.largeTitle)
                    .fontWeight(.medium)
                    .foregroundColor(.black)
            Spacer()
            Image(systemName: "rectangle.and.pencil.and.ellipsis")
                    .scaleEffect(1.4, anchor: .center)
                    .foregroundColor(Color.blue)
                    .padding()
        }.padding()
        Divider()
    }
}

private struct RandomEmoji {
    private static var emojis = ["🙏", "👊", "🙌", "👏", "👑", "🌞", "⭐️", "☀️", "🌈"]

    static func get() -> String {
        emojis.remove(at: emojis.indices.randomElement()!)
    }
}