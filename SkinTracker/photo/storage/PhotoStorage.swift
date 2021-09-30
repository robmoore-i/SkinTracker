//
// Created by Rob on 21/8/21.
//

import Foundation

class PhotoStorage {
    private let fileSystem: FileSystem

    init(_ fileManager: FileSystem) {
        self.fileSystem = fileManager
        fileSystem.createDirectory(directoryUrl: facePhotosDirectoryUrl())
    }

    /**
     - Returns: A list of the available DatedPhotos, sorted in increasing order of date i.e. the most recent photo is at
       the end of the list.
     */
    func allSorted() -> [DatedPhoto] {
        fileSystem.listFileUrls(facePhotosDirectoryUrl())
                .sorted(by: { $0.path > $1.path })
                .compactMap({ (url: URL) -> DatedPhoto? in
                    DatedPhoto.fromFileSystem(fileSystem: fileSystem, url: url)
                })
    }

    func store(_ datedPhoto: DatedPhoto) {
        if let data = datedPhoto.pngData(), let path = pngFileUrl(forDatedPhoto: datedPhoto) {
            do {
                try data.write(to: path, options: .atomic)
            } catch let error {
                print(error.localizedDescription)
            }
        } else {
            print("Couldn't store DatedPhoto '\(datedPhoto)'")
        }
    }

    func hasPhoto(forRecordingTime recordingTime: RecordingTime) -> Bool {
        if let url = pngFileUrl(forRecordingTime: recordingTime) {
            return fileSystem.fileData(fileUrl: url) != nil
        }
        return false
    }

    func deletePhoto(forRecordingTime recordingTime: RecordingTime) {
        if (hasPhoto(forRecordingTime: recordingTime)) {
            fileSystem.deleteFile(fileUrl: pngFileUrl(forRecordingTime: recordingTime))
        }
    }

    private func facePhotosDirectoryUrl() -> URL {
        fileSystem.userHomeDirectory().appendingPathComponent("SkinTracker App").appendingPathComponent("Photos")
    }

    private func pngFileUrl(forDatedPhoto datedPhoto: DatedPhoto) -> URL? {
        pngFileUrl(filename: datedPhoto.pngFileName())
    }

    private func pngFileUrl(forRecordingTime recordingTime: RecordingTime) -> URL? {
        pngFileUrl(filename: DatedPhoto.pngFileName(forRecordingTime: recordingTime))
    }

    private func pngFileUrl(filename: String) -> URL? {
        facePhotosDirectoryUrl().appendingPathComponent(filename)
    }
}
