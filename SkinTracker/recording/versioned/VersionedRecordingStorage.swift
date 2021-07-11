//
// Created by Rob on 11/7/21.
//

import Foundation

protocol VersionedRecordingStorage {
    func migration() throws

    func readAll() -> [Recording]

    func insert(record: Recording)

    func delete(id: Int)

    func recordingsFromData(data: Data) -> [Recording]
}
