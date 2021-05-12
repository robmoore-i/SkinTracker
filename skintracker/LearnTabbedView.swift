//
// Created by Rob on 2/5/21.
//

import SwiftUI

struct LearnTabbedView: View {

    var body: some View {
        TabbedView("Learn", "book.closed") {
            VStack(spacing: 0) {
                TabHeader("Learn")
                Text("Learn view").padding()
                Spacer()
            }
        }
    }
}
