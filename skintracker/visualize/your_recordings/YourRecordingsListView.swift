//
// Created by Rob on 7/5/21.
// Copied from the HTML, and modified slightly, from https://kavsoft.dev/SwiftUI_2.0/Pull_To_Refresh/
//

import SwiftUI

struct YourRecordingsListView: View {
    @ObservedObject var recordingStorage: RecordingStorage

    var body: some View {
        List {
            ForEach(recordingStorage.all) { value in
                RecordingsListEntryView(recording: value)
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
        }.padding().background(Color.white)
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
                Text(recording.spotsShortDescription())
                Spacer()
            }
        }.padding()
    }
}
