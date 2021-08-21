//
// Created by Rob on 21/8/21.
//

import UIKit

class PhotoStorage {
    private let fileSystem: FileSystem

    init(_ fileManager: FileSystem) {
        self.fileSystem = fileManager
        ensureSkinTrackerDirectoriesAreCreated()
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

    private func facePhotosDirectoryUrl() -> URL {
        fileSystem.userHomeDirectory().appendingPathComponent("SkinTracker App").appendingPathComponent("Photos")
    }

    private func pngFileUrl(forRecordingTime recordingTime: RecordingTime) -> URL? {
        let fileBaseName = "photo_\(recordingTime.formatFilename())"
        return facePhotosDirectoryUrl().appendingPathComponent(fileBaseName + ".png")
    }

    private func ensureSkinTrackerDirectoriesAreCreated() {
        fileSystem.createDirectory(directoryUrl: facePhotosDirectoryUrl())
    }
}
