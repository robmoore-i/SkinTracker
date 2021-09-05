//
// Created by Rob on 21/8/21.
//

import UIKit

class PhotoStorage {
    private let fileSystem: FileSystem

    init(_ fileManager: FileSystem) {
        self.fileSystem = fileManager
        fileSystem.createDirectory(directoryUrl: facePhotosDirectoryUrl())
    }

    /**
     - Returns: A list of the available UIImages, sorted in increasing order of date i.e. the most recent photo is at
      the end of the list.
     */
    func allSorted() -> [UIImage] {
        fileSystem.listFileUrls(facePhotosDirectoryUrl())
                .sorted(by: { $0.path < $1.path })
                .map({ (url: URL) -> CGImage? in
                    if let fileData = fileSystem.fileData(fileUrl: url) {
                        return UIImage(data: fileData)?.cgImage
                    } else {
                        return nil
                    }
                })
                // I have no doubt that there's a way to do this more gracefully
                .filter({ $0 != nil })
                .map({ $0! })
                .map({ cgImage in
                    UIImage(cgImage: cgImage, scale: 1.0, orientation: .right)
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
}
