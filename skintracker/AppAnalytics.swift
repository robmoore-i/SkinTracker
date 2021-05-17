//
// Created by Rob on 15/5/21.
// The analytics dashboard is here: https://appcenter.ms/users/robmoore121/apps/SkinTracker/analytics/overview
//

import AppCenterAnalytics

enum TrackedEvent: String {
    case tapImportRecordings = "tapImportRecordings"
    case tapExportRecordings = "tapExportRecordings"
    case tapAddRecordingFloatingActionButton = "tapAddRecordingFloatingActionButton"
    case selectDateUsingDatePicker = "selectDateUsingDatePicker"
    case tapUpdateRecordingButton = "tapUpdateRecordingButton"
    case tapSaveRecordingButton = "tapSaveRecordingButton"
    case tapEnableNotificationsModalButton = "tapEnableNotificationsModalButton"
    case tapCancelNotificationsModalButton = "tapCancelNotificationsModalButton"
    case toggleRecordingTimeOfDay = "toggleRecordingTimeOfDay"
    case changeRecordingSpotCountEntry = "changeRecordingSpotCountEntry"
    case tapFaceRegionSpotCountFieldRegionName = "tapFaceRegionSpotCountFieldRegionName"
    case tapFaceRegionSpotCountFieldSideLabel = "tapFaceRegionSpotCountFieldSideLabel"
    case tapFeedbackButton = "tapFeedbackButton"
    case dismissFeedbackModal = "dismissFeedbackModal"
    case tapSubmitFeedbackModalButton = "tapSubmitFeedbackModalButton"
    case tapCancelFeedbackModalButton = "tapCancelFeedbackModalButton"
}

struct AppAnalytics {
    static func event(_ event: TrackedEvent) {
        var properties: [String: String] = [:]
        AppAnalytics.applyDeviceId(&properties)
        AppAnalytics.event(event, properties: properties)
    }

    static func event(_ event: TrackedEvent, properties: [String: String]) {
        var propertiesCopy = properties
        AppAnalytics.applyDeviceId(&propertiesCopy)
        Analytics.trackEvent(event.rawValue, withProperties: propertiesCopy)
    }

    private static func applyDeviceId(_ properties: inout [String: String]) {
        properties["deviceIdForVendor"] = UIDevice.current.idForVendor()
    }
}

import UIKit

extension UIDevice {
    func idForVendor() -> String {
        identifierForVendor?.uuidString ?? "device-id-unavailable"
    }
}