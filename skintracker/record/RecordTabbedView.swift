//
// Created by Rob on 2/5/21.
//

import SwiftUI

struct RecordTabbedView: View {
    @State private var selectedDate = Date()
    @State private var selectedTimeOfDay = TimeOfDay.am

    var body: some View {
        TabbedView("Record", "plus.square", 1) {
            Form {
                DatePicker("Date", selection: $selectedDate, displayedComponents: .date)
                TimeOfDayToggle(selection: $selectedTimeOfDay)

                Button("Save") {
                    print("Save pressed!")
                }
            }
        }
    }
}