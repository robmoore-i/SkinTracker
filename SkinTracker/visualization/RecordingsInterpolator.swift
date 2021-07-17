//
// Created by Rob on 17/7/21.
//

struct RecordingsInterpolator {
    func twiceDailyTotals(fromRecordings recordings: [Recording]) -> [Double] {
        recordings.map {
            Double($0.totalSpotCount())
        }.reversed()
    }
}