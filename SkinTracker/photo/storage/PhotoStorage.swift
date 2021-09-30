//
// Created by Rob on 21/8/21.
//

import UIKit
import Foundation
import SwiftDate

class PhotoStorage {
    private let fileSystem: FileSystem

    init(_ fileManager: FileSystem) {
        self.fileSystem = fileManager
        fileSystem.createDirectory(directoryUrl: facePhotosDirectoryUrl())
    }

    /**
     - Returns: A list of the available UIImages, sorted in increasing order of date i.e. the most recent photo is at
      the end of the list.

     Images come out of this method in the exact way that they come out of the storage. I think they come out rotated
     to the side. PhotoPresenter has a method 'upright' which can sort this out for you.
     */
    func allSorted() -> [DatedPhoto] {
        fileSystem.listFileUrls(facePhotosDirectoryUrl())
                .sorted(by: { $0.path > $1.path })
                .compactMap({ (url: URL) -> DatedPhoto? in
                    fileSystem.fileData(fileUrl: url).flatMap({ fileData in
                        UIImage(data: fileData).map({ image in
                            DatedPhoto(photo: image, dateTag: url.pathComponents.last.map({ fileName in
                                PhotoStorage.recordingTimeForFilename(fileName: fileName).formatReadable()
                            }) ?? "<unknown>")
                        })
                    })
                })
    }

    func storePhoto(photo: UIImage, forRecordingTime recordingTime: RecordingTime) {
        if let data = photo.pngData(), let path = pngFileUrl(forRecordingTime: recordingTime) {
            do {
                try data.write(to: path, options: .atomic)
            } catch let error {
                print(error.localizedDescription)
            }
        } else {
            print("Couldn't store photo for RecordingTime '\(recordingTime)'")
        }
    }

    func hasPhoto(forRecordingTime recordingTime: RecordingTime) -> Bool {
        if let url = pngFileUrl(forRecordingTime: recordingTime) {
            return fileSystem.fileData(fileUrl: url) != nil
        }
        return false
    }

    func getPhoto(forRecordingTime recordingTime: RecordingTime) -> UIImage? {
        if let url = pngFileUrl(forRecordingTime: recordingTime), let fileData = fileSystem.fileData(fileUrl: url) {
            return UIImage(data: fileData)
        } else {
            return nil
        }
    }

    func deletePhoto(forRecordingTime recordingTime: RecordingTime) {
        if (hasPhoto(forRecordingTime: recordingTime)) {
            fileSystem.deleteFile(fileUrl: pngFileUrl(forRecordingTime: recordingTime))
        }
    }

    private func facePhotosDirectoryUrl() -> URL {
        fileSystem.userHomeDirectory().appendingPathComponent("SkinTracker App").appendingPathComponent("Photos")
    }

    private func pngFileUrl(forRecordingTime recordingTime: RecordingTime) -> URL? {
        let fileBaseName = "photo_\(recordingTime.formatFilename())"
        return facePhotosDirectoryUrl().appendingPathComponent(fileBaseName + ".png")
    }

    static func recordingTimeForFilename(fileName: String) -> RecordingTime {
        let partSplit = fileName.split(separator: "_")
        let dateSplit = partSplit[1].split(separator: "-")
        let year = Int(dateSplit[0])!
        let month = Int(dateSplit[1])!
        let day = Int(dateSplit[2])!
        let timeOfDay = TimeOfDay(rawValue: String(partSplit[2].dropLast(".png".count)))!
        let date = Date(year: year, month: month, day: day, hour: TimeOfDay.guessHourOfDay(basedOn: timeOfDay), minute: 30)
        return RecordingTime(date, .pm)
    }
}
