//
// Created by Rob on 26/9/21.
//

import Foundation
import UIKit
import SwiftUI
import SwiftDate

struct DatedPhoto: CustomStringConvertible {
    private let photoPresenter = PhotoPresenter()

    private let photo: UIImage
    private let recordingTime: RecordingTime

    public let hash: Int

    init(photo: UIImage, recordingTime: RecordingTime) {
        self.photo = photo
        self.recordingTime = recordingTime
        self.hash = photo.hash
    }

    static func fromFileSystem(fileSystem: FileSystem, url: URL) -> DatedPhoto? {
        if
                let fileData = fileSystem.fileData(fileUrl: url),
                let image = UIImage(data: fileData),
                let fileName = url.pathComponents.last,
                let recordingTime = recordingTimeForFilename(fileName: fileName) {
            return DatedPhoto(photo: image, recordingTime: recordingTime)
        }
        return nil
    }

    func upright() -> DatedPhoto? {
        photo.cgImage.map({ cgImage in
            DatedPhoto(photo: UIImage(cgImage: cgImage, scale: 1.0, orientation: .right), recordingTime: recordingTime)
        })
    }

    func scaledImage(toSize targetSize: CGSize) -> UIImage {
        photoPresenter.scale(photo: photo, toSize: targetSize)
    }

    func descriptionText() -> String {
        recordingTime.formatReadable()
    }

    var description: String {
        "DatedPhoto{recordingTime=\(recordingTime.formatReadable()), imageHash=\(hash)}"
    }

    static func ==(lhs: DatedPhoto, rhs: DatedPhoto) -> Bool {
        lhs.photo == rhs.photo && lhs.recordingTime == rhs.recordingTime
    }

    func pngData() -> Data? {
        photo.pngData()
    }

    func pngFileName() -> String {
        DatedPhoto.pngFileName(forRecordingTime: recordingTime)
    }

    static func pngFileName(forRecordingTime recordingTime: RecordingTime) -> String {
        "photo_\(recordingTime.formatFilename()).png"
    }

    private static func recordingTimeForFilename(fileName: String) -> RecordingTime? {
        let partSplit = fileName.split(separator: "_")
        let dateSplit = partSplit[1].split(separator: "-")
        if let year = Int(dateSplit[0]), let month = Int(dateSplit[1]), let day = Int(dateSplit[2]), let timeOfDay = TimeOfDay(rawValue: String(partSplit[2].dropLast(".png".count))) {
            let date = Date(year: year, month: month, day: day, hour: TimeOfDay.guessHourOfDay(basedOn: timeOfDay), minute: 30)
            return RecordingTime(date, .pm)
        } else {
            print("Warning: Malformed recording photo filename: '\(fileName)'")
            return nil
        }
    }
}