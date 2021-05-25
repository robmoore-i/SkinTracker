//
// Created by Rob on 2/5/21.
//

import Foundation
import SwiftDate

enum TimeOfDay: String {
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
}
