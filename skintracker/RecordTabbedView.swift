//
// Created by Rob on 2/5/21.
//

import SwiftUI

struct RecordTabbedView: View {
    @State var selectedDate = Date()

    var body: some View {
        TabbedView("Record", "plus.square", 1) {
            Form {
                DatePicker("Date", selection: $selectedDate, displayedComponents: .date)

                Section {
                    Text("Time")
                }

                Button("Save") {
                    print("Save pressed!")
                }
            }
        }
    }
}