//
// Created by Rob on 2/5/21.
//

import Foundation
import SwiftDate

enum TimeOfDay: String, Comparable {
    case am = "am"
    case pm = "pm"

    static func presentlyAssumedValue() -> TimeOfDay {
        TimeOfDay.fromGuess(basedOn: Date())
    }

    static func fromGuess(basedOn date: Date) -> TimeOfDay {
        let local = date.convertTo(region: Region.current)
        if (local.hour > 17 || local.hour < 4) {
            return .pm
        } else {
            return .am
        }
    }

    static func <(lhs: TimeOfDay, rhs: TimeOfDay) -> Bool {
        lhs == .am && rhs == .pm
    }

    static func guessHourOfDay(basedOn timeOfDay: TimeOfDay) -> Int {
        if (timeOfDay == .am) {
            return 7
        } else {
            return 22
        }
    }
}
