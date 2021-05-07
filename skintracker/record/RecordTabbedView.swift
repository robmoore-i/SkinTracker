//
// Created by Rob on 2/5/21.
//

import SwiftUI

struct RecordTabbedView: View {
    @State private var selectedDate = Date()
    @State private var selectedTimeOfDay = TimeOfDay.am
    @State private var selectedSpotCounts: RegionalSpotCount = RegionalSpotCount()

    private let recordingStorage: RecordingStorage

    init(_ recordingStorage: RecordingStorage) {
        self.recordingStorage = recordingStorage
    }

    var body: some View {
        TabbedView("Record", "plus.square") {
            VStack(spacing: 0) {
                HStack {
                    Text("You've got this 😊")
                            .font(.largeTitle)
                            .fontWeight(.medium)
                            .foregroundColor(.black)
                    Spacer()
                }.padding()
                Divider()
                Form {
                    Section {
                        DatePicker("Date", selection: $selectedDate, displayedComponents: .date)
                        TimeOfDayToggle(selection: $selectedTimeOfDay)
                    }

                    Section {
                        FaceRegionSpotCountGroup(selection: $selectedSpotCounts)
                    }

                    Section {
                        HStack {
                            Spacer()
                            Button("Save") {
                                recordingStorage.store(Recording(selectedDate, selectedTimeOfDay, selectedSpotCounts))
                            }.frame(maxWidth: 100).padding(10.0)
                            Spacer()
                        }
                    }
                }
            }
        }
    }
}