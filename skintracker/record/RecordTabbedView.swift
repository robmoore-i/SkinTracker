//
// Created by Rob on 2/5/21.
//

import SwiftUI

struct RecordTabbedView: View {
    @State private var selectedDate = Date()
    @State private var selectedTimeOfDay = TimeOfDay.am

    var body: some View {
        TabbedView("Record", "plus.square") {
            Form {
                Section {
                    DatePicker("Date", selection: $selectedDate, displayedComponents: .date)
                    TimeOfDayToggle(selection: $selectedTimeOfDay)
                }

                Section {
                    List(FaceRegion.allCases, id: \.rawValue) { region in
                        FaceRegionSpotCountField(region: region)
                    }
                }

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
