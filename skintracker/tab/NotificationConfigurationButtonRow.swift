//
// Created by Rob on 17/5/21.
//

import SwiftUI

enum NotificationConfigurationButton: Equatable {
    case enable
    case disable
    case dismiss
    case cancel
}

struct NotificationConfigurationButtonRow: View {
    @Environment(\.presentationMode) var presentation
    let buttons: [NotificationConfigurationButton]
    private let reminderNotificationScheduler = ReminderNotificationScheduler()

    var body: some View {
        HStack {
            if (buttons.contains(.enable)) {
                enableButton()
            }

            if (buttons.contains(.disable)) {
                disableButton()
            }

            if (buttons.contains(.dismiss)) {
                dismissButton(text: "Dismiss")
            } else if (buttons.contains(.cancel)) {
                dismissButton(text: "Cancel")
            }
        }
    }

    private func enableButton() -> some View {
        StyledButton(backgroundColor: .blue,
                action: {
                    UsageAnalytics.event(.tapEnableNotificationsModalButton)
                    reminderNotificationScheduler.scheduleReminders()
                    presentation.wrappedValue.dismiss()
                },
                label: {
                    StyledIconLabel(text: "Enable", foregroundColor: .white, iconSfImageName: "bell.fill")
                })
    }

    private func disableButton() -> some View {
        StyledButton(backgroundColor: .white,
                action: {
                    UsageAnalytics.event(.tapDisableNotificationsModalButton)
                    reminderNotificationScheduler.removeReminders()
                    presentation.wrappedValue.dismiss()
                },
                label: {
                    StyledIconLabel(text: "Disable", foregroundColor: .red, iconSfImageName: "bell.slash.fill")
                })
    }

    private func dismissButton(text: String) -> some View {
        StyledButton(backgroundColor: .white,
                action: {
                    UsageAnalytics.event(TrackedEvent.tapCancelNotificationsModalButton)
                    presentation.wrappedValue.dismiss()
                },
                label: {
                    Text(text).font(.subheadline).foregroundColor(Color.blue).padding(10)
                })
    }
}

private struct StyledButton<Label: View>: View {
    let backgroundColor: Color
    let action: () -> Void
    let label: () -> Label

    var body: some View {
        Button(action: action, label: label)
                .background(backgroundColor)
                .cornerRadius(5)
                .shadow(color: Color.black.opacity(0.3), radius: 3, x: 3, y: 3)
    }
}

private struct StyledIconLabel: View {
    let text: String
    let foregroundColor: Color
    let iconSfImageName: String

    var body: some View {
        HStack {
            Text(text)
                    .font(.subheadline)
                    .foregroundColor(foregroundColor)
                    .padding([.leading, .top, .bottom], 10)
            Image(systemName: iconSfImageName)
                    .foregroundColor(foregroundColor)
                    .padding(.trailing, 10)
        }
    }
}

extension Array where Element == NotificationConfigurationButton {
    func contains(_ o: Element) -> Bool {
        contains(where: { $0 == o })
    }
}
