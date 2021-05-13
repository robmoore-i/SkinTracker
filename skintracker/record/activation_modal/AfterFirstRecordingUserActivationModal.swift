//
// Created by Rob on 13/5/21.
// Created using Paul Hudson's video on creating a full screen modal: https://www.youtube.com/watch?v=SdIWZzl9h-w
//

import SwiftUI

struct AfterFirstRecordingUserActivationModal: View {
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        VStack {
            VStack(spacing: 0) {
                Text("You've made your").font(.largeTitle)
                Text("first recording! 🎉").font(.largeTitle)
            }.padding()
            Text("Would you like to get a notification in the morning and evening to make recordings?")
                    .multilineTextAlignment(.center).padding()
            EnableNotificationsButton().padding()
            Text("Tap anywhere to dismiss.").padding()
            Spacer()
        }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.white)
                .onTapGesture {
                    presentationMode.wrappedValue.dismiss()
                }
    }
}
