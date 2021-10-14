import SwiftUI

struct ScrollViewTypes {
    enum PositionType {
        case fixed, moving
    }

    struct Position: Equatable {
      let type: PositionType
      let y: CGFloat
    }

    struct PositionPreferenceKey: PreferenceKey {
        typealias Value = [Position]

        static var defaultValue: Value = []
        static func reduce(value: inout Value, nextValue: () -> Value) {
            value.append(contentsOf: nextValue())
        }
    }
}

private struct ScrollViewPositionProvider: View {
    let type: ScrollViewTypes.PositionType
    var body: some View {
        GeometryReader { proxy in
            Color.clear
                .preference(key: ScrollViewTypes.PositionPreferenceKey.self,
                            value: [ScrollViewTypes.Position(type: type, y: proxy.frame(in: .global).minY)])
        }
  }
}

struct RefreshableScrollView<Content: View>: View {
    typealias OnRefresh = (@escaping () -> Void) -> Void
    
    private enum RefreshState {
        case waiting, primed, loading
        
    }
    let content: Content
    let onRefresh: OnRefresh

    @State private var state: RefreshState = .waiting
    @State private var progress: CGFloat = .zero
    private let kThreshHold: CGFloat = 50
    
    init(@ViewBuilder content: () -> Content, onRefresh: @escaping OnRefresh) {
        self.content = content()
        self.onRefresh = onRefresh
    }

  var body: some View {
      ScrollView {
          ZStack(alignment: .top) {
              ScrollViewPositionProvider(type: .moving)
                  .frame(height: 0)
              content
                  .alignmentGuide(.top, computeValue: { _ in
                      (state == .loading) ? -kThreshHold : 0
                  })
              RefreshInficatorView(loading: state == .loading, progress: progress)
                  .frame(height: kThreshHold / 2)
                  .padding(.top, 16)
                  .offset(y: (state == .loading) ? 0 : -kThreshHold)
                  .opacity(progress)
          }
      }
      .background(ScrollViewPositionProvider(type: .fixed))
      .onPreferenceChange(ScrollViewTypes.PositionPreferenceKey.self) { values in
          if state != .loading {
              DispatchQueue.main.async {
                  let movingY = values.first { $0.type == .moving }?.y ?? 0
                  let fixedY = values.first { $0.type == .fixed }?.y ?? 0
                  let offset = movingY - fixedY
                  self.progress = offset / kThreshHold
                  if state == .waiting && offset > kThreshHold {
                      state = .primed
                  } else if state == .primed && offset < kThreshHold {
                      state = .loading
                      onRefresh {
                          withAnimation {
                              self.state = .waiting
                              progress = .zero
                          }
                      }
                  }
              }
          }
      }
  }
}

struct RefreshInficatorView: View {
    var loading = false
    var progress: CGFloat
    @State private var animating = false

    var body: some View {
        Group {
            if loading {
                Circle()
                    .rotation(.degrees(-90))
                    .trim(from: 0, to: 0.3)
                    .stroke(Color.blue, lineWidth: 2)
                    .rotationEffect(.degrees(animating ? 360 : 0))
                    .onAppear {
                        withAnimation(.linear(duration: 0.8).repeatForever(autoreverses: false)) {
                            self.animating = true
                        }
                    }
                    .onDisappear {
                        self.animating = false
                    }

            } else {
                Circle()
                    .rotation(.degrees(-90))
                    .trim(from: 0, to: progress)
                    .stroke(Color.blue, lineWidth: 2)
            }
        }
    }
}
