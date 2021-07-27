//
// Created by Rob on 28/7/21.
//

import Foundation
import SwiftDate

class RecordingTime: CustomStringConvertible, Equatable {
    private let date: Date
    private let timeOfDay: TimeOfDay

    init(_ date: Date, _ timeOfDay: TimeOfDay) {
        self.date = date
        self.timeOfDay = timeOfDay
    }

    var description: String {
        "{date: \(date.toPreciseFormat()), timeOfDay: \(timeOfDay.rawValue)}"
    }

    /**
     The date, with the hour adjusted to match an assumed value based on the time of day for the recording.
     */
    private func assumedDate() -> Date {
        let localDate = date.convertTo(region: Region.current)
        let hour = timeOfDay == .am ? 7 : 22
        return Date(year: localDate.year, month: localDate.month, day: localDate.day, hour: hour, minute: 0, region: Region.current)
    }

    func until(_ laterTime: RecordingTime) -> Range<Date> {
        if (self == laterTime) {
            return assumedDate()..<(assumedDate() + 1.days)
        }

        return assumedDate()..<laterTime.assumedDate()
    }

    static func ==(lhs: RecordingTime, rhs: RecordingTime) -> Bool {
        differenceDescription(lhs, rhs) == nil
    }

    static func differenceDescription(_ lhs: RecordingTime, _ rhs: RecordingTime) -> String? {
        if type(of: lhs) != type(of: rhs) {
            return "Type mismatch. Lhs: \(type(of: lhs)) , Rhs: \(type(of: rhs))"
        }
        if lhs.timeOfDay != rhs.timeOfDay {
            return "TimeOfDay mismatch. Lhs: \(lhs.timeOfDay) , Rhs: \(rhs.timeOfDay)"
        }
        if lhs.date.toPreciseFormat() != rhs.date.toPreciseFormat() {
            return "Date mismatch. Lhs: \(lhs.date.toPreciseFormat()) , Rhs: \(rhs.date.toPreciseFormat())"
        }
        return nil
    }
}