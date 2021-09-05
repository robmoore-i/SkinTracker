//
// Created by Rob on 21/8/21.
//

import UIKit
import SwiftUI

struct PhotoPicker: UIViewControllerRepresentable {
    let sourceType: UIImagePickerController.SourceType

    @Binding var formRecording: FormRecording
    @Environment(\.presentationMode) var presentationMode

    func makeUIViewController(context: UIViewControllerRepresentableContext<PhotoPicker>) -> UIImagePickerController {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = sourceType
        imagePicker.delegate = context.coordinator
        imagePicker.allowsEditing = false
        imagePicker.cameraFlashMode = .off
        imagePicker.cameraDevice = .front
        imagePicker.cameraCaptureMode = .photo
        imagePicker.showsCameraControls = true
        return imagePicker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: UIViewControllerRepresentableContext<PhotoPicker>) {
    }

    func makeCoordinator() -> PhotoPickerCoordinator {
        PhotoPickerCoordinator(self)
    }
}

class PhotoPickerCoordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    var parent: PhotoPicker

    init(_ parent: PhotoPicker) {
        self.parent = parent
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        if let photo = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            parent.formRecording.setPhoto(photo: photo)
        }
        parent.presentationMode.wrappedValue.dismiss()
    }
}