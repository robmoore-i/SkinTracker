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

    /**
      For the user's timezone, if the date of this instance is the same as the date given, and the time of day of this
      instance is the same as the time of day given, then true. Otherwise false.
     */
    func isFor(date: Date, time: TimeOfDay) -> Bool {
        isFor(date: date) && isFor(time: time)
    }

    func isFor(date: Date) -> Bool {
        let convertedOtherDate = date.convertTo(region: Region.current)
        let convertedSelfDate = self.date.convertTo(region: Region.current)
        return convertedSelfDate.year == convertedOtherDate.year
                && convertedSelfDate.month == convertedOtherDate.month
                && convertedSelfDate.day == convertedOtherDate.day
    }

    func isFor(time: TimeOfDay) -> Bool {
        timeOfDay == time
    }

    func isInLast(numberOfDays: Int, beforeDate: Date) -> Bool {
        date.isInRange(date: beforeDate - numberOfDays.days, and: beforeDate, orEqual: true, granularity: .day)
    }

    /**
     Two RecordingTime instances are considered equal if they represent the same date & time, regardless of whether
     there is an exact match on the date, or the location in memory.
     */
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
        if lhs.assumedDate().toPreciseFormat() != rhs.assumedDate().toPreciseFormat() {
            return "Date mismatch. Lhs: \(lhs.date.toPreciseFormat()) , Rhs: \(rhs.date.toPreciseFormat())"
        }
        return nil
    }
}