//
// Created by Rob on 20/8/21.
//

import SwiftUI

struct ExperimentTabbedView: View {
    let photoStorage: PhotoStorage

    var body: some View {
        let recordingTime = RecordingTime(Date(year: 2021, month: 8, day: 21, hour: 10, minute: 11), .pm)
        let photo = photoStorage.getPhoto(forRecordingTime: recordingTime)
        return TabbedView(tabName: "Experiment", tabIconSfImageName: "pyramid") {
            Image(uiImage: photo!)
        }
    }
}