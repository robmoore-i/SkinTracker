//
// Created by Rob on 2/5/21.
//

import SwiftUI

struct RecordTabbedView: View {
    private let recordingStorage: RecordingStorage

    @State private var selectedDate = Date()
    @State private var selectedTimeOfDay = TimeOfDay.am
    @State private var selectedSpotCounts: RegionalSpotCount = RegionalSpotCount()

    init(_ recordingStorage: RecordingStorage) {
        self.recordingStorage = recordingStorage
    }

    var body: some View {
        TabbedView("Record", "plus.square") {
            VStack(spacing: 0) {
                TabHeader("Record")
                Form {
                    Section {
                        LoggedDatePicker(selection: $selectedDate)
                        TimeOfDayToggle(selection: $selectedTimeOfDay)
                    }

                    Section {
                        FaceRegionSpotCountGroup(selection: $selectedSpotCounts)
                    }

                    Section {
                        HStack {
                            Spacer()
                            SubmitButton(
                                    selectedDate: $selectedDate,
                                    selectedTimeOfDay: $selectedTimeOfDay,
                                    selectedSpotCounts: $selectedSpotCounts,
                                    recordingStorage: recordingStorage)
                            Spacer()
                        }
                    }
                }
            }
        }
    }
}

private struct LoggedDatePicker: View {
    @Binding var selection: Date

    var body: some View {
        DatePicker("Date", selection: $selection, displayedComponents: .date)
                .onChange(of: selection) { newDate in
                    print("Selected date: \(newDate)")
                }
    }
}

private struct SubmitButton: View {
    @Binding var selectedDate: Date
    @Binding var selectedTimeOfDay: TimeOfDay
    @Binding var selectedSpotCounts: RegionalSpotCount

    @ObservedObject var recordingStorage: RecordingStorage

    var body: some View {
        Button(buttonLabel()) {
            recordingStorage.store(selectedDate, selectedTimeOfDay, selectedSpotCounts)
        }.frame(maxWidth: 100).padding(10.0)
    }

    func buttonLabel() -> String {
        if (recordingStorage.hasEntryFor(date: selectedDate, time: selectedTimeOfDay)) {
            return "Update"
        } else {
            return "Save"
        }
    }
}