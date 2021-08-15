//
// Created by Rob on 18/5/21.
//

import Foundation

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
    case tapNotificationsButton = "tapNotificationsButton"
    case tapDisableNotificationsModalButton = "tapDisableNotificationsModalButton"
    case dismissNotificationsModal = "dismissNotificationsModal"
    case swipeToDeleteRecording = "swipeToDeleteRecording"
    case deleteRecording = "deleteRecording"
    case tapAddRecordingPhotoButton = "tapAddRecordingPhotoButton"
}