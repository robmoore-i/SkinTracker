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
            Text(text)
                    .font(.largeTitle)
                    .fontWeight(.medium)
                    .foregroundColor(.black)
            Spacer()
        }.padding()
        Divider()
    }
}
