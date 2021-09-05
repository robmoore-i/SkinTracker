//
// Created by Rob on 25/5/21.
//

import Foundation
import UIKit

/**
 This represents the Recording whose values will be used as defaults in the form if it is submitted. In particular, if a
 given time and day are selected, and a Recording already exists for that combination, then the spot counts for it will
 be considered as the defaults in the form. This struct is responsible for playing the role of this implicit, default
 Recording entry, that underlies the form changes made by the user.

 With time, it has also become the place where drafted Recording changes are accumulated before they are submitted.
 The responsibility of committing the content of the drafted Recording data into the app's storage is also held by this
 object, since it privately holds the data in its internal state, and it also has access to the relevant storage media.
 */
struct FormRecording {
    private var date: Date
    private var timeOfDay: TimeOfDay
    private var photo: UIImage? = nil

    private let recordingStorage: RecordingStorage
    private let photoStorage: PhotoStorage

    private var recording: Recording

    private let photoResizer = PhotoResizer()

    init(date: Date, timeOfDay: TimeOfDay, recordingStorage: RecordingStorage, photoStorage: PhotoStorage) {
        self.date = date
        self.timeOfDay = timeOfDay
        self.recordingStorage = recordingStorage
        self.photoStorage = photoStorage
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
        if let photo = photo {
            photoStorage.storePhoto(photo: photo, forRecordingTime: recording.recordingTime)
        }
    }

    func placeholderSpotCount(forRegion region: FaceRegion) -> (left: Int, right: Int) {
        recording.spotCount(forRegion: region)
    }

    mutating func setDate(date: Date) {
        self.date = date
        refreshRecording()
    }

    mutating func setTimeOfDay(timeOfDay: TimeOfDay) {
        self.timeOfDay = timeOfDay
        refreshRecording()
    }

    mutating func setPhoto(photo: UIImage) {
        self.photo = photo
    }

    mutating func removePhoto() {
        self.photo = nil
    }

    func getPhoto(atSize size: CGSize) -> UIImage? {
        self.photo.map({ photo in
            photoResizer.scale(photo: photo, toSize: size)
        })
    }

    private mutating func refreshRecording() {
        recording = recordingStorage.entryFor(date: date, time: timeOfDay)
                ?? Recording(RecordingTime(date, timeOfDay), RegionalSpotCount(/* All Zeros */))
    }
}