//
// Created by Rob on 11/5/21.
// Copied from this blog post: https://programmingwithswift.com/swiftui-floating-action-button/
//

import SwiftUI

struct AddRecordingFloatingActionButton: View {
    @Binding var selectedTab: Int

    var body: some View {
        VStack {
            HStack {
                Spacer()
                Button(action: {
                    selectedTab = 2
                }, label: {
                    Text("+")
                            .font(.system(.largeTitle))
                            .frame(width: 50, height: 43)
                            .foregroundColor(Color.white)
                            .padding(.bottom, 7)
                })
                        .background(Color.blue)
                        .cornerRadius(5)
                        .padding()
                        .shadow(color: Color.black.opacity(0.4), radius: 4, x: 4, y: 4)
            }
            Spacer()
        }
    }
}