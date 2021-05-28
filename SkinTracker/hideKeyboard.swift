//
// Created by Rob on 5/5/21.
//

import SwiftUI
import UIKit

extension UIApplication {
    func hideKeyboard() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

extension View {
    func hideKeyboard() {
        UIApplication.shared.hideKeyboard()
    }

    func onTapHideKeyboard() -> some View {
        onTapGesture(perform: hideKeyboard)
    }
}