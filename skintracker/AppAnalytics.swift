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
    case dismissAfterFirstRecordingUserActivationModal = "dismissAfterFirstRecordingUserActivationModal"
    case tapEnableNotificationsButton = "tapEnableNotificationsButton"
    case toggleRecordingTimeOfDay = "toggleRecordingTimeOfDay"
    case changeRecordingSpotCountEntry = "changeRecordingSpotCountEntry"
    case tapFaceRegionSpotCountFieldRegionName = "tapFaceRegionSpotCountFieldRegionName"
    case tapFaceRegionSpotCountFieldSideLabel = "tapFaceRegionSpotCountFieldSideLabel"
    case tapFeedbackButton = "tapFeedbackButton"
    case dismissFeedbackModal = "dismissFeedbackModal"
}

struct AppAnalytics {
    static func event(_ event: TrackedEvent) {
        Analytics.trackEvent(event.rawValue)
    }

    static func event(_ event: TrackedEvent, properties: [String: String]) {
        Analytics.trackEvent(event.rawValue, withProperties: properties)
    }
}
