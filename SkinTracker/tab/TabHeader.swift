//
// Created by Rob on 7/5/21.
//

import SwiftUI

struct TabHeader: View {
    let text: String
    @Binding var showFeedbackModal: Bool
    @Binding var showNotificationsModal: Bool

    var body: some View {
        let configureNotificationsButtonAccessibilityText = "Configure notifications"
        let feedbackButtonAccessibilityText = "Send feedback about the app"
        HStack {
            Text("\(text)")
                    .font(.largeTitle)
                    .fontWeight(.medium)
                    .foregroundColor(.black)
            Spacer()
            Button(action: {
                UsageAnalytics.event(.tapNotificationsButton)
                showNotificationsModal = true
            }, label: {
                Image(systemName: "bell")
                        .scaleEffect(1.4, anchor: .center)
                        .foregroundColor(Color.blue)
            })
                    .padding([.leading, .trailing])
                    .accessibility(label: Text(configureNotificationsButtonAccessibilityText))
                    .accessibilityIdentifier(configureNotificationsButtonAccessibilityText)
            Button(action: {
                UsageAnalytics.event(.tapFeedbackButton)
                showFeedbackModal = true
            }, label: {
                Image(systemName: "rectangle.and.pencil.and.ellipsis")
                        .scaleEffect(1.4, anchor: .center)
                        .foregroundColor(Color.blue)
            })
                    .padding([.leading, .trailing])
                    .accessibility(label: Text(feedbackButtonAccessibilityText))
                    .accessibilityIdentifier(feedbackButtonAccessibilityText)
        }.padding()
        Divider()
    }
}
