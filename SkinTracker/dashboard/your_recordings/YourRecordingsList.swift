//
// Created by Rob on 7/5/21
//

import SwiftUI

struct YourRecordingsList: View {
    @ObservedObject var recordingStorage: RecordingStorage
    let photoStorage: PhotoStorage

    var body: some View {
        List {
            ForEach(recordingStorage.all.indices, id: \.self) { index in
                RecordingsListEntry(recording: recordingStorage.all[index]).padding(10)
            }.onDelete(perform: onDelete)
        }.padding(5)
    }

    func onDelete(v: IndexSet) {
        if (v.count != 1) {
            print("Unexpectedly tried to delete \(v.count) recordings at a time, rather than the expected, 1.")
            print("Offending IndexSet of offsets: \(v)")
        } else if let index = v.first {
            UsageAnalytics.event(.swipeToDeleteRecording, properties: ["index": "\(index)"])
            let recording = recordingStorage.deleteItem(atIndex: index)
            photoStorage.deletePhoto(forRecordingTime: recording.recordingTime)
            UsageAnalytics.event(.deleteRecording, properties: ["recording": "\(recording.recordingTime.toAnalyticsJson())"])
        }
    }
}

private struct RecordingsListEntry: View {
    let recording: Recording

    var body: some View {
        VStack {
            HStack {
                Text(recording.recordingTime.formatReadableDateOnly())
                TimeOfDayIcon(recordingTime: recording.recordingTime)
                Spacer()
            }
            HStack {
                let mostAffectedRegions = recording.mostAffectedRegions()
                let totalSpotCount = recording.totalSpotCount()
                if mostAffectedRegions.isEmpty {
                    Text("Clear")
                } else {
                    VStack(alignment: .leading) {
                        Text("Total: \(totalSpotCount)")
                        Text("Most affected: \(mostAffectedRegions.joined(separator: ", "))")
                    }
                }
                Spacer()
            }
        }
    }
}
