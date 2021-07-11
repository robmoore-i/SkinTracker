//
// Created by Rob on 11/7/21.
//

import Foundation

protocol VersionedRecordingStorage {
    /**
     Execute any data migrations that need to happen. After this method has been called, all recordings will be stored
     under the latest model version.
     */
    func migration() throws

    func readAll() -> [Recording]

    func insert(record: Recording)

    func delete(id: Int)

    func recordingsFromJson(json: String) -> [Recording]
}
