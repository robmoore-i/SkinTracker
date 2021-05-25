//
// Created by Rob on 2/5/21.
//

import SwiftUI

struct RecordTabbedView: View {
    private var recordingStorage: RecordingStorage

    @State private var selectedDate: Date
    @State private var selectedTimeOfDay: TimeOfDay
    @State private var storedRecording: FormDefaultRecording
    @State private var selectedSpotCounts: RegionalSpotCount = RegionalSpotCount()
    @State private var showFeedbackModal = false

    private init(_ recordingStorage: RecordingStorage,
                 initialDate: Date,
                 initialTimeOfDay: TimeOfDay,
                 initialRecording: FormDefaultRecording) {
        self.recordingStorage = recordingStorage
        _selectedDate = .init(initialValue: initialDate)
        _selectedTimeOfDay = .init(initialValue: initialTimeOfDay)
        _storedRecording = .init(initialValue: initialRecording)
    }

    static func usingStorage(_ recordingStorage: RecordingStorage) -> RecordTabbedView {
        let initialDate = Date()
        let initialTimeOfDay = TimeOfDay.am
        let formDefaultRecording = FormDefaultRecording(date: initialDate, timeOfDay: initialTimeOfDay, recordingStorage: recordingStorage)
        return RecordTabbedView(recordingStorage,
                initialDate: initialDate,
                initialTimeOfDay: initialTimeOfDay,
                initialRecording: formDefaultRecording)
    }

    var body: some View {
        TabbedView(tabName: "Record", tabIconSfImageName: "plus.square") {
            Form {
                Section {
                    LoggedDatePicker(
                            selection: $selectedDate,
                            storedRecording: $storedRecording,
                            recordingStorage: recordingStorage)
                    TimeOfDayToggle(
                            selection: $selectedTimeOfDay,
                            storedRecording: $storedRecording,
                            recordingStorage: recordingStorage)
                }

                Section {
                    FaceRegionSpotCountGroup(
                            storedRecording: $storedRecording,
                            selectedSpotCounts: $selectedSpotCounts)
                }

                Section {
                    HStack {
                        Spacer()
                        SubmitButton(
                                selectedDate: $selectedDate,
                                selectedTimeOfDay: $selectedTimeOfDay,
                                storedRecording: $storedRecording,
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
    @Binding var storedRecording: FormDefaultRecording

    @ObservedObject var recordingStorage: RecordingStorage

    var body: some View {
        DatePicker("Date", selection: $selection, displayedComponents: .date)
                .onChange(of: selection, perform: onDateChange)
    }

    private func onDateChange(_ date: Date) {
        UsageAnalytics.event(.selectDateUsingDatePicker, properties: ["date": "\(date)"])
        print("Selected date: \(date)")
        storedRecording.refresh(date: date)
    }
}

private struct SubmitButton: View {
    @Binding var selectedDate: Date
    @Binding var selectedTimeOfDay: TimeOfDay
    @Binding var storedRecording: FormDefaultRecording
    @Binding var selectedSpotCounts: RegionalSpotCount

    @ObservedObject var recordingStorage: RecordingStorage

    @State private var showEnableNotificationsModal = false

    var body: some View {
        let (label, tapEvent) = buttonSemantics()
        return Button(label) {
            UsageAnalytics.event(tapEvent)
            let emptyBefore = recordingStorage.all.isEmpty
            recordingStorage.store(selectedDate, selectedTimeOfDay, storedRecording.mergeSpotCounts(with: selectedSpotCounts))
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