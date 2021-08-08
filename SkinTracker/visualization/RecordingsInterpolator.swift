//
// Created by Rob on 17/7/21.
//

struct RecordingsInterpolator {
    /**
     We walk through the Recordings from farthest back to most recent, stopping at every possible RecordingTime.

     For any given RecordingTime, there may be a missing entry. This indicates a morning or evening in which we forgot
     to create an entry. This means that we don't have data for this entry, which means we need to guess. To guess, we
     use linear interpolation.

     We determine the size of the gap in entries - that is, the number of missed entries. We also determine the
     difference in the data across that gap. Using this information, we determine what each data point should be
     in between the two data points which are adjacent in terms of the Recordings list, but not adjacent in
     RecordingTime.

     As we walk through the RecordingTime values, if we find a hit in the Recordings list, we add that data point. If
     there's a miss, we need to start interpolating. To interpolate, we determine the step size then continue walking
     over the RecordingTimes, adding our guessed data points to them, until we arrive back at a real entry and continue
     as normal.
    */
    func twiceDailyTotals(fromRecordings recordings: [Recording]) -> [Double] {
        if (recordings.isEmpty) {
            return []
        }

        let mostRecentTime = (recordings.first!).recordingTime
        let farthestBackTime = (recordings.last!).recordingTime
        var current = farthestBackTime

        var x = 0
        var dataPoints: [(x: Int, y: Double)] = []
        var recordingsIndex = recordings.count - 1
        var step: (size: Double, next: Double)? = nil

        while (current <= mostRecentTime) {
            let r = recordings[recordingsIndex]
            if (r.recordingTime == current) {
                dataPoints.append((x: x, y: Double(r.totalSpotCount())))
                recordingsIndex -= 1
                step = nil
            } else if (step == nil) {
                // Comparing r and previous r to assess gap size and determine the correct linear interpolation
                let previousR = recordings[recordingsIndex + 1]

                // Step through x values to get the number of steps between previousR.recording and r.recordingTime
                var walker = previousR.recordingTime
                var stepCount = 0
                while (walker < r.recordingTime) {
                    stepCount += 1
                    walker = walker.next()
                }
                // Number of steps
                let deltaX = stepCount

                // The "vertical" distance that needs to be covered across all the steps
                let deltaY = r.totalSpotCount() - previousR.totalSpotCount()

                // Each step should have a size of delta(y) / delta(x)
                let stepSize = Double(deltaY) / Double(deltaX)
                step = (size: stepSize, next: Double(previousR.totalSpotCount()) + stepSize)
            }

            if (step != nil) {
                let definiteStep = step!
                dataPoints.append((x: x, y: definiteStep.next))
                step = (size: definiteStep.size, next: definiteStep.next + definiteStep.size)
            }

            x += 1
            current = current.next()
        }

        return dataPoints.map { (x: Int, y: Double) -> Double in y }
    }
}