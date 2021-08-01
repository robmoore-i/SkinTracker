//
// Created by Rob on 25/5/21.
//

import Foundation

/**
 This represents the Recording whose values will be used as defaults in the form if it is submitted. In particular, if a
 given time and day are selected, and a Recording already exists for that combination, then the spot counts for it will
 be considered as the defaults in the form. This struct is responsible for playing the role of this implicit, default
 Recording entry, that underlies the form changes made by the user.
 */
struct FormRecording {
    private var date: Date
    private var timeOfDay: TimeOfDay

    private var recordingStorage: RecordingStorage

    private var recording: Recording

    init(date: Date, timeOfDay: TimeOfDay, recordingStorage: RecordingStorage) {
        self.date = date
        self.timeOfDay = timeOfDay
        self.recordingStorage = recordingStorage

        recording = recordingStorage.entryFor(date: date, time: timeOfDay)
                ?? Recording(RecordingTime(date, timeOfDay), RegionalSpotCount(/* All Zeros */))
    }

    /**
     - Parameter spotCounts: The spot counts to overlay on top of the default values provided by the underlying
      Recording that is encapsulated by this object.

     This method persists this object using its given RecordingStorage, after applying the user's spot count field
     changes, which are represented by the parameter. If the Recording existed before, it will be overwritten. Otherwise
     a new entry will be added.
     */
    func store(withUserSelectedSpotCounts spotCounts: RegionalSpotCount) {
        recordingStorage.store(recording.withImposedSpotCounts(spotCounts))
    }

    func placeholderSpotCount(forRegion region: FaceRegion) -> (left: Int, right: Int) {
        recording.spotCount(forRegion: region)
    }

    mutating func refresh(date: Date) {
        self.date = date
        refreshRecording()
    }

    mutating func refresh(timeOfDay: TimeOfDay) {
        self.timeOfDay = timeOfDay
        refreshRecording()
    }

    private mutating func refreshRecording() {
        recording = recordingStorage.entryFor(date: date, time: timeOfDay)
                ?? Recording(RecordingTime(date, timeOfDay), RegionalSpotCount(/* All Zeros */))
    }
}