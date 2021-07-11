//
// Created by Rob on 7/5/21.
// Copied from the HTML, and modified slightly, from https://kavsoft.dev/SwiftUI_2.0/Pull_To_Refresh/
//

import SwiftUI

struct YourRecordingsListView: View {
    @ObservedObject var recordingStorage: RecordingStorage
    @Binding var selectedTab: Int

    var body: some View {
        ZStack {
            PagedRecordingList(recordingStorage: recordingStorage).padding(5)
            if (!recordingStorage.all.isEmpty) {
                AddRecordingFloatingActionButton(selectedTab: $selectedTab)
            }
        }
    }
}

private struct RecordingsListEntry: View {
    let recording: Recording

    var body: some View {
        VStack {
            HStack {
                Text(recording.dateDescription())
                if (recording.isFor(time: .am)) {
                    Image(systemName: "sun.max").accentColor(.yellow)
                } else {
                    Image(systemName: "moon").accentColor(.black)
                }
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

/**
 This is a recording list which lazily loads the list, rather than trying to load everything at once.
 */
private struct PagedRecordingList: View {
    @ObservedObject var recordingStorage: RecordingStorage

    private let pageSize = 10

    @State private var indices = PagedRecordingList.initiallyLoadedIndices()
    private static let numberOfRecordingsToLoadInitially = 15

    var body: some View {
        List {
            ForEach(safeIndices(), id: \.self) { index in
                RecordingsListEntry(recording: recordingStorage.all[index]).padding(10)
                        .onAppear {
                            // Load the next page when the last entry appears
                            if indices.last == index && index < maxLoadedEntries() {
                                let next = maxLoadedEntries() - index
                                indices.append(contentsOf: Array(index + 1..<index + (next > pageSize ? pageSize : next)))
                            }
                        }
            }.onDelete(perform: onDelete)
        }
    }

    /**
     These are the indices of the recordings list which are initially loaded.
     */
    static func initiallyLoadedIndices() -> [Int] {
        Array(0..<(PagedRecordingList.numberOfRecordingsToLoadInitially - 1))
    }

    func safeIndices() -> [Int] {
        if (recordingStorage.all.count <= PagedRecordingList.numberOfRecordingsToLoadInitially) {
            return Array(0..<recordingStorage.all.count)
        } else {
            return indices
        }
    }

    func maxLoadedEntries() -> Int {
        recordingStorage.all.count
    }

    func onDelete(v: IndexSet) {
        if (v.count != 1) {
            print("Unexpectedly tried to delete \(v.count) recordings at a time, rather than the expected, 1.")
            print("Offending IndexSet of offsets: \(v)")
        } else if let index = v.first {
            UsageAnalytics.event(.swipeToDeleteRecording, properties: ["index": "\(index)"])
            let recording = recordingStorage.deleteItem(atIndex: index)
            UsageAnalytics.event(.deleteRecording, properties: ["recording": "\(recording.toAnalyticsJson())"])
        }
    }
}