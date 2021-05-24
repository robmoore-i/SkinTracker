//
// Created by Rob on 2/5/21.
//

import SwiftUI

struct RecordTabbedView: View {
    private var recordingStorage: RecordingStorage

    @State private var selectedDate: Date
    @State private var selectedTimeOfDay: TimeOfDay
    @State private var storedSpotCountsForDateAndTime: RegionalSpotCount
    @State private var selectedSpotCounts: RegionalSpotCount = RegionalSpotCount()
    @State private var showFeedbackModal = false

    private init(_ recordingStorage: RecordingStorage,
                 initialDate: Date,
                 initialTimeOfDay: TimeOfDay,
                 initialSpotCounts: RegionalSpotCount) {
        self.recordingStorage = recordingStorage
        _selectedDate = .init(initialValue: initialDate)
        _selectedTimeOfDay = .init(initialValue: initialTimeOfDay)
        _storedSpotCountsForDateAndTime = .init(initialValue: initialSpotCounts)
    }

    static func usingStorage(_ recordingStorage: RecordingStorage) -> RecordTabbedView {
        let initialDate = Date()
        let initialTimeOfDay = TimeOfDay.am
        let initialSpotCounts = (recordingStorage.entryFor(date: initialDate, time: initialTimeOfDay)
                ?? Recording(initialDate, initialTimeOfDay, RegionalSpotCount(/* All Zeros */))
        ).regionalSpotCount
        return RecordTabbedView(recordingStorage,
                initialDate: initialDate,
                initialTimeOfDay: initialTimeOfDay,
                initialSpotCounts: initialSpotCounts)
    }

    var body: some View {
        TabbedView(tabName: "Record", tabIconSfImageName: "plus.square") {
            Form {
                Section {
                    LoggedDatePicker(
                            selection: $selectedDate,
                            selectedTimeOfDay: $selectedTimeOfDay,
                            storedSpotCountsForDateAndTime: $storedSpotCountsForDateAndTime,
                            recordingStorage: recordingStorage)
                    TimeOfDayToggle(
                            selection: $selectedTimeOfDay,
                            selectedDate: $selectedDate,
                            storedSpotCountsForDateAndTime: $storedSpotCountsForDateAndTime,
                            recordingStorage: recordingStorage)
                }

                Section {
                    FaceRegionSpotCountGroup(
                            defaultSpotCounts: $storedSpotCountsForDateAndTime,
                            selectedSpotCounts: $selectedSpotCounts)
                }

                Section {
                    HStack {
                        Spacer()
                        SubmitButton(
                                selectedDate: $selectedDate,
                                selectedTimeOfDay: $selectedTimeOfDay,
                                storedSpotCounts: $storedSpotCountsForDateAndTime,
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
    @Binding var selectedTimeOfDay: TimeOfDay
    @Binding var storedSpotCountsForDateAndTime: RegionalSpotCount

    @ObservedObject var recordingStorage: RecordingStorage

    var body: some View {
        DatePicker("Date", selection: $selection, displayedComponents: .date)
                .onChange(of: selection, perform: onDateChange)
    }

    private func onDateChange(_ date: Date) {
        UsageAnalytics.event(.selectDateUsingDatePicker, properties: ["date": "\(date)"])
        print("Selected date: \(date)")
        storedSpotCountsForDateAndTime = (recordingStorage.entryFor(date: date, time: selectedTimeOfDay)
                ?? Recording(date, selectedTimeOfDay, RegionalSpotCount(/* All Zeros */))
        ).regionalSpotCount
    }
}

private struct SubmitButton: View {
    @Binding var selectedDate: Date
    @Binding var selectedTimeOfDay: TimeOfDay
    @Binding var storedSpotCounts: RegionalSpotCount
    @Binding var selectedSpotCounts: RegionalSpotCount

    @ObservedObject var recordingStorage: RecordingStorage

    @State private var showEnableNotificationsModal = false

    var body: some View {
        let (label, tapEvent) = buttonSemantics()
        return Button(label) {
            UsageAnalytics.event(tapEvent)
            let emptyBefore = recordingStorage.all.isEmpty
            print("Merging spot counts:")
            print("selected: \(selectedSpotCounts)")
            print("stored:   \(storedSpotCounts)")
            let merged = selectedSpotCounts.imposedOnto(storedSpotCounts)
            print("merged:   \(merged)")
            recordingStorage.store(selectedDate, selectedTimeOfDay, merged)
            let notEmptyNow = recordingStorage.all.count > 0
            if (emptyBefore && notEmptyNow) {
                showEnableNotificationsModal = true
            }
            hideKeyboard()
        }.frame(maxWidth: 100).padding(10.0)
                .sheet(isPresented: $showEnableNotificationsModal, content: {
                    VStack {
                        VStack(spacing: 0) {
                            Text("You've made your").font(.largeTitle)
                            Text("first recording! 🎉").font(.largeTitle)
                        }.padding()
                        VStack(spacing: 0) {
                            let font: Font = .headline
                            Text("Would you like reminder notifications").font(font)
                            Text("in the morning (7am) and evening (10pm)?").font(font)
                        }.padding()
                        Text("This app sends no other notifications.").foregroundColor(.gray).padding(.bottom)
                        NotificationConfigurationButtonRow(buttons: [.enable, .dismiss])
                        Spacer()
                    }.frame(maxWidth: .infinity, maxHeight: .infinity).background(Color.white)
                })
    }

    func buttonSemantics() -> (String, TrackedEvent) {
        if (recordingStorage.hasEntryFor(date: selectedDate, time: selectedTimeOfDay)) {
            return ("Update", .tapUpdateRecordingButton)
        } else {
            return ("Save", .tapSaveRecordingButton)
        }
    }
}