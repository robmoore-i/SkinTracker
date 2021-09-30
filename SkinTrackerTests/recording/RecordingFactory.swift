//
// Created by Rob on 2/8/21.
//

import Foundation
import SwiftDate
@testable import SkinTracker

class RecordingFactory {
    static func get(year: Int = 2021, month: Int = 1, day: Int = 1, hour: Int = 1, minute: Int = 15, timeOfDay: TimeOfDay = .am,
                    timezone: ZoneConvertible = Zones.gmt) -> Recording {
        let recordingTime = RecordingTime(Date(year: year, month: month, day: day, hour: hour, minute: minute,
                region: Region(zone: timezone)), timeOfDay)
        return Recording(recordingTime, RegionalSpotCount())
    }

    static func get(day: Int = 1, timeOfDay: TimeOfDay, dailyTotal: Int) -> Recording {
        let regionalSpotCount = RegionalSpotCount()
        regionalSpotCount.put(region: .cheek, left: dailyTotal)
        return Recording(
                RecordingTime(
                        Date(year: 2021, month: 7, day: day, hour: 12, minute: 15,
                                region: Region(zone: Zones.asiaSingapore)),
                        timeOfDay),
                regionalSpotCount)
    }
}