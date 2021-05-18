//
// Created by Rob on 18/5/21.
//

import UIKit

extension UIDevice {
    func idForVendor() -> String {
        identifierForVendor?.uuidString ?? "device-id-unavailable"
    }
}

struct IdentifiedDevice {
    static func deviceIdForVendor() -> String {
        UIDevice.current.idForVendor()
    }
}