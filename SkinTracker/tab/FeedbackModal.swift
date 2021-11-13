//
// Created by Rob on 16/5/21.
//

import SwiftUI

struct FeedbackModal: View {
    @Environment(\.presentationMode) var presentation
    @State private var text: String = "This app might be better if..."
    @State private var textColor: Color = .gray
    @State private var tapped: Bool = false

    var body: some View {
        VStack {
            VStack(spacing: 0) {
                Text("Your feedback️ is").font(.largeTitle)
                Text("so important").font(.largeTitle)
            }.padding().onTapGesture(perform: hideKeyboard)
            TextEditor(text: $text)
                    .foregroundColor(textColor)
                    .padding()
                    .frame(width: 300, height: 150)
                    .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color.gray))
                    .onTapGesture {
                        if (!tapped) {
                            text = ""
                            tapped = true
                            textColor = .black
                        }
                    }
            HStack {
                Button(action: {
                    UsageAnalytics.event(.tapSubmitFeedbackModalButton, properties: ["text": text])
                    print("Submitted feedback '\(text)'")
                    presentation.wrappedValue.dismiss()
                }, label: {
                    Text("Submit")
                            .foregroundColor(Color.white)
                            .padding()
                })
                        .background(Color.blue)
                        .cornerRadius(5)
                        .padding(5)
                        .shadow(color: Color.black.opacity(0.3), radius: 3, x: 3, y: 3)
                Button(action: {
                    UsageAnalytics.event(.tapCancelFeedbackModalButton)
                    presentation.wrappedValue.dismiss()
                }, label: {
                    Text("Cancel")
                            .foregroundColor(Color.blue)
                            .padding()
                })
                        .background(Color.white)
                        .cornerRadius(5)
                        .padding(5)
                        .shadow(color: Color.black.opacity(0.3), radius: 3, x: 3, y: 3)
            }
            Text("You can also go to the app store to submit feedback, if you want other people to see it.")
                    .multilineTextAlignment(.center)
                    .padding()
            Spacer()
        }
    }
}