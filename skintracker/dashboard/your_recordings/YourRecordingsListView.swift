//
// Created by Rob on 7/5/21.
// Copied from the HTML, and modified slightly, from https://kavsoft.dev/SwiftUI_2.0/Pull_To_Refresh/
//

import SwiftUI

struct YourRecordingsListView: View {
    @ObservedObject var recordingStorage: RecordingStorage

    var body: some View {
        ZStack {
            RecordingsList(recordingStorage: recordingStorage).padding(5)
            AddRecordingFloatingActionButton()
        }
    }
}

private struct RecordingsList: View {
    var recordingStorage: RecordingStorage

    var body: some View {
        List {
            ForEach(recordingStorage.all) { value in
                RecordingsListEntryView(recording: value).padding(10)
            }.onDelete { (v: IndexSet) in
                if (v.count != 1) {
                    print("Unexpectedly tried to delete \(v.count) recordings at a time, rather than the expected, 1.")
                    print("Offending IndexSet of offsets: \(v)")
                    return
                }
                if let index = v.first {
                    recordingStorage.deleteItem(atIndex: index)
                }
            }
        }.background(Color.white)
    }
}

private struct RecordingsListEntryView: View {
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

private struct AddRecordingFloatingActionButton: View {
    var body: some View {
        VStack {
            HStack {
                Spacer()
                Button(action: {
                    print("Going to Record tab")
                }, label: {
                    Text("+")
                            .font(.system(.largeTitle))
                            .frame(width: 50, height: 43)
                            .foregroundColor(Color.white)
                            .padding(.bottom, 7)
                })
                        .background(Color.blue)
                        .cornerRadius(5)
                        .padding()
                        .shadow(color: Color.black.opacity(0.4), radius: 4, x: 4, y: 4)
            }
            Spacer()
        }
    }
}