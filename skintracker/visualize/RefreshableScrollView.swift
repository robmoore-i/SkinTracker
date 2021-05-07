// Author: The SwiftUI Lab
// Full article: https://swiftui-lab.com/scrollview-pull-to-refresh/

import SwiftUI

struct RefreshableScrollView<Content: View>: View {
    @State private var previousScrollOffset: CGFloat = 0
    @State private var scrollOffset: CGFloat = 0
    @State private var frozen: Bool = false
    @State private var rotation: Angle = .degrees(0)

    let threshold: CGFloat
    @Binding var refreshing: Bool
    let content: Content

    init(height: CGFloat = 10, refreshing: Binding<Bool>, @ViewBuilder content: () -> Content) {
        threshold = height
        self._refreshing = refreshing
        self.content = content()
    }

    var body: some View {
        VStack {
            ScrollView {
                ZStack(alignment: .top) {
                    MovingView()

                    VStack {
                        content
                    }.alignmentGuide(.top, computeValue: { d in (refreshing && frozen) ? -threshold : 0.0 })

                    SymbolView(height: threshold, loading: refreshing, frozen: frozen, rotation: rotation)
                }
            }
                    .background(FixedView())
                    .onPreferenceChange(RefreshableKeyTypes.PrefKey.self) { values in
                        refreshLogic(values: values)
                    }
        }
    }

    func refreshLogic(values: [RefreshableKeyTypes.PrefData]) {
        DispatchQueue.main.async {
            // Calculate scroll offset
            let movingBounds = values.first {
                $0.vType == .movingView
            }?.bounds ?? .zero
            let fixedBounds = values.first {
                $0.vType == .fixedView
            }?.bounds ?? .zero

            self.scrollOffset = movingBounds.minY - fixedBounds.minY

            self.rotation = symbolRotation(scrollOffset)

            // Crossing the threshold on the way down, we start the refresh process
            if !refreshing && (scrollOffset > threshold && previousScrollOffset <= threshold) {
                self.refreshing = true
            }

            if refreshing {
                // Crossing the threshold on the way up, we add a space at the top of the ScrollView
                if previousScrollOffset > threshold && scrollOffset <= threshold {
                    self.frozen = true

                }
            } else {
                // remove the space at the top of the scroll view
                self.frozen = false
            }

            // Update last scroll offset
            self.previousScrollOffset = scrollOffset
        }
    }

    func symbolRotation(_ scrollOffset: CGFloat) -> Angle {

        // We will begin rotation, only after we have passed
        // 60% of the way of reaching the threshold.
        if scrollOffset < threshold * 0.20 {
            return .degrees(0)
        } else {
            // Calculate rotation, based on the amount of scroll offset
            let h = Double(threshold)
            let d = Double(scrollOffset)
            let v = max(min(d - (h * 0.6), h * 0.4), 0)
            return .degrees(180 * v / (h * 0.4))
        }
    }

    struct SymbolView: View {
        var height: CGFloat
        var loading: Bool
        var frozen: Bool
        var rotation: Angle


        var body: some View {
            Group {
                if loading { // If loading, show the activity control
                    VStack {
                        Spacer()
                        ActivityRep()
                        Spacer()
                    }.frame(height: height).fixedSize()
                            .offset(y: -height + (loading && frozen ? height : 0.0))
                } else {
                    Image(systemName: "arrow.down") // If not loading, show the arrow
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: height * 0.1, height: height * 0.1).fixedSize()
                            .padding(height * 0.2)
                            .rotationEffect(rotation)
                            .offset(y: -height + (loading && frozen ? +height : 0.0))
                }
            }
        }
    }

    struct MovingView: View {
        var body: some View {
            GeometryReader { proxy in
                Color.clear.preference(key: RefreshableKeyTypes.PrefKey.self, value: [RefreshableKeyTypes.PrefData(vType: .movingView, bounds: proxy.frame(in: .global))])
            }.frame(height: 0)
        }
    }

    struct FixedView: View {
        var body: some View {
            GeometryReader { proxy in
                Color.clear.preference(key: RefreshableKeyTypes.PrefKey.self, value: [RefreshableKeyTypes.PrefData(vType: .fixedView, bounds: proxy.frame(in: .global))])
            }
        }
    }
}

struct RefreshableKeyTypes {
    enum ViewType: Int {
        case movingView
        case fixedView
    }

    struct PrefData: Equatable {
        let vType: ViewType
        let bounds: CGRect
    }

    struct PrefKey: PreferenceKey {
        static var defaultValue: [PrefData] = []

        static func reduce(value: inout [PrefData], nextValue: () -> [PrefData]) {
            value.append(contentsOf: nextValue())
        }

        typealias Value = [PrefData]
    }
}

struct ActivityRep: UIViewRepresentable {
    func makeUIView(context: UIViewRepresentableContext<ActivityRep>) -> UIActivityIndicatorView {
        UIActivityIndicatorView()
    }

    func updateUIView(_ uiView: UIActivityIndicatorView, context: UIViewRepresentableContext<ActivityRep>) {
        uiView.startAnimating()
    }
}