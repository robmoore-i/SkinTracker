//
// Created by Rob on 25/5/21.
//

import Foundation

/**
 This represents the Recording whose values will be used as defaults in the form if it is submitted. In particular, if a
 given time and day are selected, and a Recording already exists for that combination, then the spot counts for it will
 be considered as the defaults in the form. This struct is responsible for playing the role of this implicit, default
 Recording entry, that underlies the form changes made by the user. The name could certainly be better.
 */
struct FormDefaultRecording {
    private var date: Date
    private var timeOfDay: TimeOfDay

    private var recordingStorage: RecordingStorage

    private var recording: Recording

    init(date: Date, timeOfDay: TimeOfDay, recordingStorage: RecordingStorage) {
        self.date = date
        self.timeOfDay = timeOfDay
        self.recordingStorage = recordingStorage

        recording = recordingStorage.entryFor(date: date, time: timeOfDay)
                ?? Recording(date, timeOfDay, RegionalSpotCount(/* All Zeros */))
    }

    func spotCountFor(region: FaceRegion) -> (left: Int, right: Int) {
        recording.regionalSpotCount.get(region)
    }

    func mergeSpotCounts(with: RegionalSpotCount) -> RegionalSpotCount {
        recording.regionalSpotCount.imposedOnto(with)
    }

    mutating func refresh(date: Date) {
        self.date = date
        refreshRecording()
    }

    mutating func refresh(timeOfDay: TimeOfDay) {
        self.timeOfDay = timeOfDay
        refreshRecording()
    }

    mutating func refreshRecording() {
        recording = recordingStorage.entryFor(date: date, time: timeOfDay)
                ?? Recording(date, timeOfDay, RegionalSpotCount(/* All Zeros */))
    }
}