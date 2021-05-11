//
// Created by Rob on 11/5/21.
//

import SwiftUI

struct YourRecordingsListHeader: View {
    var recordingStorage: RecordingStorage

    var body: some View {
        HStack {
            Text("Your Recordings").font(.title).padding(.trailing)
//            Button(action: {
//                print("Switching to Record tab")
//            }) {
//                HStack {
//                    Image(systemName: "plus.square.fill")
//                            .scaleEffect(1.5, anchor: .center)
//                            .accentColor(Color.blue)
//                }
//            }.padding(.trailing)
            ExportRecordingsButton(recordingStorage: recordingStorage).padding(.trailing)
            ImportRecordingsButton(recordingStorage: recordingStorage)
            Spacer()
        }.padding(.leading).padding(.top)
    }
}