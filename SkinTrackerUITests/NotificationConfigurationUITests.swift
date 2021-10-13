//
// Created by Rob on 12/10/21.
//

import XCTest
import UIKit

class NotificationConfigurationUITests: XCTestCase {
    let app = XCUIApplication()

    func testBringUpAndDismissNotificationModal() throws {
        app.launch()

        app.buttons.element(matching: .button, identifier: "Configure notifications").tap()
        app.buttons.element(matching: .button, identifier: "Cancel").tap()
    }
}
