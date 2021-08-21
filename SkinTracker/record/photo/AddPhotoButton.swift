//
// Created by Rob on 20/8/21.
//

import SwiftUI

struct AddPhotoButton: View {
    @Binding var selectedDate: Date
    @Binding var isImageBeingSelected: Bool

    var body: some View {
        Button(action: {
            UsageAnalytics.event(.tapAddRecordingPhotoButton, properties: ["date": "\(selectedDate)"])
            isImageBeingSelected = true
        }, label: {
            HStack {
                Text("Photo").foregroundColor(.black)
                Spacer()
                Image(systemName: "camera")
                        .scaleEffect(1.5, anchor: .center)
                        .foregroundColor(.blue)
            }
        })
    }
}

