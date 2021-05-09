//
// Created by Rob on 7/5/21.
// Copied from the HTML, and modified slightly, from https://kavsoft.dev/SwiftUI_2.0/Pull_To_Refresh/
//

import SwiftUI

struct RecordingsListView: View {
    @ObservedObject var recordingStorage: RecordingStorage

    var body: some View {
        RefreshableScrollView(progressTint: .black, arrowTint: .black) {
            VStack {
                let sortedRecordings = recordingStorage.all.sorted { recording1, recording2 in
                    recording1 > recording2
                }
                ForEach(sortedRecordings, id: \.self) { value in
                    RecordingsListEntryView(recording: value)
                }
            }.padding().background(Color.white)
        } onUpdate: {
            recordingStorage.refresh()
        }
    }
}

private struct RecordingsListEntryView: View {
    let recording: Recording

    var body: some View {
        HStack {
            Text(recording.description)
            Spacer()
        }.padding()
    }
}
