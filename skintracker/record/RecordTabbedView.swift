//
// Created by Rob on 2/5/21.
//

import SwiftUI

struct RecordTabbedView: View {
    private var recordingStorage: RecordingStorage

    @State private var selectedDate: Date
    @State private var selectedTimeOfDay: TimeOfDay
    @State private var formRecording: FormRecording
    @State private var selectedSpotCounts: RegionalSpotCount = RegionalSpotCount()
    @State private var showFeedbackModal = false

    private init(_ recordingStorage: RecordingStorage,
                 initialDate: Date,
                 initialTimeOfDay: TimeOfDay,
                 initialRecording: FormRecording) {
        self.recordingStorage = recordingStorage
        _selectedDate = .init(initialValue: initialDate)
        _selectedTimeOfDay = .init(initialValue: initialTimeOfDay)
        _formRecording = .init(initialValue: initialRecording)
    }

    static func usingStorage(_ recordingStorage: RecordingStorage) -> RecordTabbedView {
        let initialDate = Date()
        let initialTimeOfDay = TimeOfDay.am
        let formDefaultRecording = FormRecording(date: initialDate, timeOfDay: initialTimeOfDay, recordingStorage: recordingStorage)
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
                            formRecording: $formRecording,
                            recordingStorage: recordingStorage)
                    TimeOfDayToggle(
                            selection: $selectedTimeOfDay,
                            formRecording: $formRecording,
                            recordingStorage: recordingStorage)
                }

                Section {
                    FaceRegionSpotCountGroup(
                            selectedSpotCounts: $selectedSpotCounts,
                            formRecording: $formRecording)
                }

                Section {
                    HStack {
                        Spacer()
                        SubmitButton(
                                selectedDate: $selectedDate,
                                selectedTimeOfDay: $selectedTimeOfDay,
                                selectedSpotCounts: $selectedSpotCounts,
                                formRecording: $formRecording,
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
    @Binding var formRecording: FormRecording

    @ObservedObject var recordingStorage: RecordingStorage

    var body: some View {
        DatePicker("Date", selection: $selection, displayedComponents: .date)
                .onChange(of: selection, perform: onDateChange)
    }

    private func onDateChange(_ date: Date) {
        UsageAnalytics.event(.selectDateUsingDatePicker, properties: ["date": "\(date)"])
        print("Selected date: \(date)")
        formRecording.refresh(date: date)
    }
}

private struct SubmitButton: View {
    @Binding var selectedDate: Date
    @Binding var selectedTimeOfDay: TimeOfDay
    @Binding var selectedSpotCounts: RegionalSpotCount
    @Binding var formRecording: FormRecording

    @ObservedObject var recordingStorage: RecordingStorage

    @State private var showEnableNotificationsModal = false

    var body: some View {
        let (label, tapEvent) = buttonSemantics()
        return Button(label) {
            UsageAnalytics.event(tapEvent)
            let emptyBefore = recordingStorage.all.isEmpty
            formRecording.store(withUserSelectedSpotCounts: selectedSpotCounts)
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