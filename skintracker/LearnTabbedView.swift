//
// Created by Rob on 2/5/21.
//

import SwiftUI

struct LearnTabbedView: View {
    var body: some View {
        TabbedView("Learn", "book.closed", 4) {
            Text("Learn View").padding()
        }
    }
}
