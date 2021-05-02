//
// Created by Rob on 2/5/21.
//

import SwiftUI

enum TimeOfDay {
    case am
    case pm
}

struct TimeOfDayToggleStyle2: ToggleStyle {
    func makeBody(configuration: Configuration) -> some View {
        HStack {
            configuration.label
            Spacer()
            Image(systemName: configuration.isOn ? "sun.max" : "moon")
                    .resizable()
                    .frame(width: 22, height: 22)
                    .onTapGesture {
                        configuration.isOn.toggle()
                    }
        }
    }
}

struct TimeOfDayToggleStyle: ToggleStyle {
    var onColor = Color(UIColor.black)
    var offColor = Color(UIColor.systemYellow)
    var thumbColor = Color.white

    func makeBody(configuration: Self.Configuration) -> some View {
        HStack {
            configuration.label
            Spacer()
            Image(systemName: "sun.max")
                    .resizable()
                    .frame(width: 22, height: 22)
            Button(action: { configuration.isOn.toggle() }) {
                RoundedRectangle(cornerRadius: 16, style: .circular)
                        .fill(configuration.isOn ? onColor : offColor)
                        .frame(width: 50, height: 29)
                        .overlay(
                                Circle()
                                        .fill(thumbColor)
                                        .shadow(radius: 1, x: 0, y: 1)
                                        .padding(1.5)
                                        .offset(x: configuration.isOn ? 10 : -10))
                        .animation(Animation.easeInOut(duration: 0.15))
            }.buttonStyle(PlainButtonStyle())
            Image(systemName: "moon")
                    .resizable()
                    .frame(width: 22, height: 22)
        }
    }
}

struct TimeOfDayToggle: View {
    @Binding var selection: TimeOfDay
    @State private var toggleIsOn = false

    var body: some View {
        Toggle("Time of Day", isOn: $toggleIsOn)
                .toggleStyle(TimeOfDayToggleStyle())
                .onReceive([toggleIsOn].publisher.first()) { (value) in
                    selection = toggleIsOn ? TimeOfDay.pm : TimeOfDay.am
                }
    }
}

struct RecordTabbedView: View {
    @State private var selectedDate = Date()
    @State private var timeOfDay = TimeOfDay.am

    var body: some View {
        TabbedView("Record", "plus.square", 1) {
            Form {
                DatePicker("Date", selection: $selectedDate, displayedComponents: .date)
                TimeOfDayToggle(selection: $timeOfDay)

                Button("Save") {
                    print("Save pressed!")
                }
            }
        }
    }
}