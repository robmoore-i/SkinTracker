//
// Created by Rob on 6/5/21.
//

import Foundation
import SwiftDate

class Recording: CustomStringConvertible, Identifiable, Hashable, Comparable {
    let id: Int

    private let date: Date
    private let timeOfDay: TimeOfDay
    private let regionalSpotCount: RegionalSpotCount

    convenience init(_ date: Date, _ timeOfDay: TimeOfDay, _ regionalSpotCount: RegionalSpotCount) {
        self.init(UUID().hashValue, date, timeOfDay, regionalSpotCount)
    }

    init(_ id: Int, _ date: Date, _ timeOfDay: TimeOfDay, _ regionalSpotCount: RegionalSpotCount) {
        self.id = id
        self.date = date
        self.timeOfDay = timeOfDay
        self.regionalSpotCount = regionalSpotCount
    }

    var description: String {
        "Recording(id: \(id), date: \(date), timeOfDay: \(timeOfDay), regionalSpotCounts: \(regionalSpotCount))"
    }

    /**
     The date, with the hour adjusted to match an assumed value based on the time of day for the recording.
     */
    private func assumedDate() -> Date {
        let localDate = date.convertTo(region: Region.current)
        let hour = timeOfDay == .am ? 7 : 22
        return Date(year: localDate.year, month: localDate.month, day: localDate.day, hour: hour, minute: 0, region: Region.current)
    }

    func until(_ laterRecording: Recording) -> Range<Date> {
        assumedDate()..<laterRecording.assumedDate()
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

    func isForSameDateAndTimeAs(other: Recording) -> Bool {
        isFor(date: other.date, time: other.timeOfDay)
    }

    func isInLast(numberOfDays: Int, beforeDate: Date) -> Bool {
        date.isInRange(date: beforeDate - numberOfDays.days, and: beforeDate, orEqual: true, granularity: .day)
    }

    func spotCount(forRegion region: FaceRegion) -> (left: Int, right: Int) {
        regionalSpotCount.get(region)
    }

    func withImposedSpotCounts(_ selectedSpotCount: RegionalSpotCount) -> Recording {
        Recording(date, timeOfDay, selectedSpotCount.imposedOnto(regionalSpotCount))
    }

    func dateHumanReadableFormat() -> String {
        let convertedDate = date.convertTo(region: Region.current)
        return "\(convertedDate.weekdayName(.short)) \(convertedDate.ordinalDay) \(convertedDate.monthName(.short)) \(convertedDate.year)"
    }

    private func datePreciseFormat() -> String {
        "\(date.toFormat("yyyy-MM-dd'T'HH:mm:ssZ")).\(date.nanosecond)"
    }

    func totalSpotCount() -> Int {
        regionalSpotCount.totalSpots()
    }

    func mostAffectedRegions() -> [String] {
        regionalSpotCount.mostAffectedRegions()
    }

    func toAnalyticsJson() -> String {
        "{\"date\": \"\(date)\", \"timeOfDay\": \"\(timeOfDay.rawValue)\"}"
    }

    static let chronologicalSortCriteria: (Recording, Recording) -> Bool = { recording1, recording2 in
        recording1 > recording2
    }

    /**
      This method exposes the internal data of the class. This is given in a clearly named
      method in order to make it clear that the purpose of this is to enable serialization
      into Realm objects, and certainly not for anything else.
     */
    func realmObjectConversionParts() -> (Date, TimeOfDay, RegionalSpotCount) {
        (date, timeOfDay, regionalSpotCount)
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(date)
        hasher.combine(timeOfDay)
        hasher.combine(regionalSpotCount)
    }

    static func ==(lhs: Recording, rhs: Recording) -> Bool {
        if lhs === rhs {
            return true
        }
        return differenceDescription(lhs, rhs) == nil
    }

    /**
     Interpretation: R1 < R2 <=> R1 is an earlier recording than R2.
     */
    static func <(lhs: Recording, rhs: Recording) -> Bool {
        let localLhs = lhs.date.convertTo(region: Region.current)
        let localRhs = rhs.date.convertTo(region: Region.current)
        let onSameDate = localLhs.year == localRhs.year &&
                localLhs.month == localRhs.month &&
                localLhs.ordinalDay == localRhs.ordinalDay
        if (onSameDate) {
            return lhs.timeOfDay < rhs.timeOfDay
        } else if lhs.timeOfDay < rhs.timeOfDay {
            return localLhs <= localRhs
        } else {
            return localLhs < localRhs
        }
    }

    static func differenceDescription(_ lhs: Recording, _ rhs: Recording) -> String? {
        if type(of: lhs) != type(of: rhs) {
            return "Type mismatch. Lhs: \(type(of: lhs)) , Rhs: \(type(of: rhs))"
        }
        if lhs.id != rhs.id {
            return "Id mismatch. Lhs: \(lhs.id) , Rhs: \(rhs.id)"
        }
        if lhs.timeOfDay != rhs.timeOfDay {
            return "TimeOfDay mismatch. Lhs: \(lhs.timeOfDay) , Rhs: \(rhs.timeOfDay)"
        }
        if lhs.datePreciseFormat() != rhs.datePreciseFormat() {
            return "Date mismatch. Lhs: \(lhs.datePreciseFormat()) , Rhs: \(rhs.datePreciseFormat())"
        }
        if rhs.regionalSpotCount != lhs.regionalSpotCount {
            return "RegionalSpotCount mismatch. Lhs: \(lhs.regionalSpotCount) , Rhs: \(rhs.regionalSpotCount)"
        }
        return nil
    }
}

private enum SerializationError: Error {
    case couldNotSerialize
}
