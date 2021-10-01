//
// Created by Rob on 1/10/21.
//

import SwiftUI

struct TimeOfDayIcon: View {
    let recordingTime: RecordingTime

    var body: some View {
        if (recordingTime.isFor(time: .am)) {
            Image(systemName: "sun.max").accentColor(.yellow)
        } else {
            Image(systemName: "moon").accentColor(.black)
        }
    }
}