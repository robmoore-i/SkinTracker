//
// Created by Rob on 2/5/21.
//

import SwiftUI

struct RecordTabbedView: View {
    private let recordingStorage: RecordingStorage

    @State private var selectedDate = Date()
    @State private var selectedTimeOfDay = TimeOfDay.am
    @State private var selectedSpotCounts: RegionalSpotCount = RegionalSpotCount()
    @State private var showFeedbackModal = false

    init(_ recordingStorage: RecordingStorage) {
        self.recordingStorage = recordingStorage
    }

    var body: some View {
        TabbedView(tabIconSubtitle: "Record", tabIconSfImageName: "plus.square", tabHeader: "Record") {
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

private struct LoggedDatePicker: View {
    @Binding var selection: Date

    var body: some View {
        DatePicker("Date", selection: $selection, displayedComponents: .date)
                .onChange(of: selection) { newDate in
                    AppAnalytics.event(.selectDateUsingDatePicker, properties: ["date": "\(newDate)"])
                    print("Selected date: \(newDate)")
                }
    }
}

private struct SubmitButton: View {
    @Binding var selectedDate: Date
    @Binding var selectedTimeOfDay: TimeOfDay
    @Binding var selectedSpotCounts: RegionalSpotCount

    @ObservedObject var recordingStorage: RecordingStorage

    @State private var showEnableNotificationsModal = false

    var body: some View {
        let label = buttonLabel()
        return Button(label) {
            AppAnalytics.event(label == "Update" ? .tapUpdateRecordingButton : .tapSaveRecordingButton)
            let emptyBefore = recordingStorage.all.isEmpty
            recordingStorage.store(selectedDate, selectedTimeOfDay, selectedSpotCounts)
            let notEmptyNow = recordingStorage.all.count > 0
            if (emptyBefore && notEmptyNow) {
                showEnableNotificationsModal = true
            }
        }.frame(maxWidth: 100).padding(10.0)
                .sheet(isPresented: $showEnableNotificationsModal, content: EnableNotificationsModal.init)
    }

    func buttonLabel() -> String {
        if (recordingStorage.hasEntryFor(date: selectedDate, time: selectedTimeOfDay)) {
            return "Update"
        } else {
            return "Save"
        }
    }
}