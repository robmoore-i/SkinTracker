//
// Created by Rob on 17/7/21.
//

struct RecordingsInterpolator {
    func twiceDailyTotals(fromRecordings recordings: [Recording]) -> [Double] {
        if (recordings.isEmpty) {
            return []
        }

        return recordings.map {
            Double($0.totalSpotCount())
        }.reversed()
    }
}