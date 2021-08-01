//
// Created by Rob on 2/8/21.
//

import Foundation
import SwiftDate
@testable import SkinTracker

class RecordingTimeFactory {
    static func get(year: Int = 2021, month: Int = 1, day: Int = 1, hour: Int = 1, timeOfDay: TimeOfDay = .am,
                    timezone: ZoneConvertible = Zones.gmt) -> RecordingTime {
        RecordingTime(Date(year: year, month: month, day: day, hour: hour, minute: 15,
                region: Region(zone: timezone)), timeOfDay)
    }
}