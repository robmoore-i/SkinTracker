//
// Created by Rob on 4/9/21.
//

import SwiftUI

struct PhotoPreview: View {
    @Binding var formRecording: FormRecording

    var body: some View {
        if let scaledPhoto = formRecording.scalePhoto(toSize: CGSize(width: 100, height: 100)) {
            HStack {
                Spacer()
                Image(uiImage: scaledPhoto)
                Spacer()
                Button(action: {
                    formRecording.removePhoto()
                }, label: {
                    Image(systemName: "minus.circle")
                            .scaleEffect(2, anchor: .center)
                            .foregroundColor(.red)
                            .padding()
                })
            }
        }
    }
}
