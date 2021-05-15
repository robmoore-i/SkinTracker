//
// Created by Rob on 2/5/21.
//

import SwiftUI

private func link(_ text: String) -> some View {
    TextLink(text) {
        Text("Sweet information").navigationBarTitle(text, displayMode: .large)
    }
}

struct LearnTabbedView: View {
    var body: some View {
        TabbedView("Learn", "book.closed") {
            NavigationView {
                List {
                    TextLink("Pathogenesis") {
                        List {
                            link("Hypersecretion of sebum")
                            link("Abnormal follicular keratinization")
                            link("Colonisation by commensal bacteria")
                            link("Inflammatory response")
                            link("Cutaneous dysbiosis")
                        }.navigationBarTitle("Pathogenesis")
                    }
                    TextLink("Diet") {
                        List {
                            link("Water")
                            link("IGF-1 (e.g. Dairy and other animal products)")
                            link("Glycemic Load (e.g. Sugar)")
                            link("Lipids")
                            link("Fruit & Vegetables")
                            link("Alcohol")
                        }.navigationBarTitle("Diet")
                    }
                    TextLink("Habits") {
                        List {
                            link("Morning and evening routine")
                            link("Protecting your face")
                            link("Safely dealing with outbreaks")
                        }.navigationBarTitle("Habits")
                    }
                    TextLink("Lifestyle") {
                        List {
                            link("Sleep")
                            link("Stress")
                        }.navigationBarTitle("Lifestyle")
                    }
                }.navigationBarTitle("Learn")
            }
        }
    }
}
