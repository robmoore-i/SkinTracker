//
// Created by Rob on 21/8/21.
//

import Foundation

class FileSystem {
    private let fileManager: FileManager

    init(_ fileManager: FileManager) {
        self.fileManager = fileManager
    }

    func fileData(fileUrl: URL) -> Data? {
        fileManager.contents(atPath: fileUrl.path)
    }

    func userHomeDirectory() -> URL {
        fileManager.urls(for: .documentDirectory, in: FileManager.SearchPathDomainMask.userDomainMask).first!
    }

    func listFileUrls(_ url: URL) -> [URL] {
        do {
            return try fileManager.contentsOfDirectory(at: url, includingPropertiesForKeys: nil)
        } catch let error {
            print(error.localizedDescription)
            return []
        }
    }

    func rename(from: String, to: String, inDirectory directory: URL) {
        var fromUrl = directory.appendingPathComponent(from)
        var updatedResourceValues = URLResourceValues()
        updatedResourceValues.name = to
        do {
            try fromUrl.setResourceValues(updatedResourceValues)
        } catch let error {
            print(error.localizedDescription)
        }
    }

    func createDirectory(directoryUrl: URL) {
        do {
            try fileManager.createDirectory(at: directoryUrl, withIntermediateDirectories: true)
        } catch let error {
            print(error.localizedDescription)
        }
    }

    /**
     Deletes the file at the given URL. If the URL is nil, this method does nothing.
     */
    func deleteFile(fileUrl: URL?) {
        if let fileUrl = fileUrl {
            do {
                try fileManager.removeItem(at: fileUrl)
            } catch let error {
                print(error.localizedDescription)
            }
        }
    }
}