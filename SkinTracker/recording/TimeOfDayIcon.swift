//
// Created by Rob on 1/10/21.
//

import SwiftUI

struct TimeOfDayIcon: View {
    let recordingTime: RecordingTime

    var body: some View {
        if (recordingTime.isFor(time: .am)) {
            Image(systemName: "sun.max").foregroundColor(Color(hexString: "#debd16"))
        } else {
            Image(systemName: "moon").foregroundColor(Color(hexString: "#9c9994"))
        }
    }
}

// Shamelessly copy-pasted from the SwiftUICharts code.
private extension Color {
    init(hexString: String) {
        let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt64()
        Scanner(string: hex).scanHexInt64(&int)
        let r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (r, g, b) = ((int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (r, g, b) = (int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (r, g, b) = (int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (r, g, b) = (0, 0, 0)
        }
        self.init(red: Double(r) / 255, green: Double(g) / 255, blue: Double(b) / 255)
    }
}