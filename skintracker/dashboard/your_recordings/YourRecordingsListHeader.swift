//
// Created by Rob on 11/5/21.
//

import SwiftUI

struct YourRecordingsListHeader: View {
    var recordingStorage: RecordingStorage

    var body: some View {
        HStack {
            Text("Your Recordings").font(.title).padding(.trailing)
            ExportRecordingsButton(recordingStorage: recordingStorage).padding(.trailing)
            ImportRecordingsButton(recordingStorage: recordingStorage)
            Spacer()
        }.padding(.leading).padding(.top)
    }
}