//
// Created by Rob on 2/5/21.
//

import SwiftUI

struct RecordTabbedView: View {
    @State private var selectedDate = Date()
    @State private var selectedTimeOfDay = TimeOfDay.am
    @State private var selectedFaceRegion = FaceRegion.cheek

    var body: some View {
        TabbedView("Record", "plus.square", 1) {
            Form {
                DatePicker("Date", selection: $selectedDate, displayedComponents: .date)
                TimeOfDayToggle(selection: $selectedTimeOfDay)
                FaceRegionSpotCounter(selection: $selectedFaceRegion)
                Button("Save") {
                    print("Save pressed!")
                }
            }.onTapGesture(perform: self.hideKeyboard)
        }
    }
}

#if canImport(UIKit)
extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
#endif