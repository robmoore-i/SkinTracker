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

    func createDirectory(directoryUrl: URL) {
        do {
            try fileManager.createDirectory(at: directoryUrl, withIntermediateDirectories: true)
        } catch let error {
            print(error.localizedDescription)
        }
    }
}