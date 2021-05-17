//
// Created by Rob on 16/5/21.
//

import SwiftUI

struct FeedbackModal: View {
    @Environment(\.presentationMode) var presentation
    @State private var text: String = "This app might be better if..."
    @State private var tapped: Bool = false

    var body: some View {
        VStack {
            VStack(spacing: 0) {
                Text("Your feedback️ is")
                        .font(.largeTitle)
                Text("so important")
                        .font(.largeTitle)

            }.padding().onTapGesture(perform: hideKeyboard)

            TextEditor(text: $text)
                    .foregroundColor(.gray)
                    .padding()
                    .frame(width: 300, height: 150)
                    .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color.gray))
                    .onTapGesture {
                        if (!tapped) {
                            text = ""
                            tapped = true
                        }
                    }
            Button(action: {
                print("Submitted feedback '\(text)'")
            }, label: {
                Text("Submit")
                        .foregroundColor(Color.white)
                        .padding()
            })
                    .background(Color.blue)
                    .cornerRadius(5)
                    .padding(5)
                    .shadow(color: Color.black.opacity(0.4), radius: 4, x: 4, y: 4)
        }
    }
}