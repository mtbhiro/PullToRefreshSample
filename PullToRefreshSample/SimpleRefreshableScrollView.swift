//import Foundation
//import SwiftUI
//
//private struct ScrollOffsetProvider: View {
//  var body: some View {
//    GeometryReader { proxy in
//        Color.clear
//          .preference(key: PositionPreferenceKey.self,
//                      value: proxy.frame(in: .global).minY)
//     }
//    .frame(height: 0)
//  }
//}
//
//private struct PositionPreferenceKey: PreferenceKey {
//    typealias Value = CGFloat
//
//    static var defaultValue: Value = .zero
//    static func reduce(value: inout Value, nextValue: () -> Value) {
//    }
//}
//
//typealias OnRefresh = (@escaping () -> Void) -> Void
//
//struct SimpleRefreshableScrollView<Content: View>: View {
//
//    private enum RefreshState {
//        case waiting, loading
//    }
//
//    let onRefresh: OnRefresh
//    let content: Content
//
//    @State private var previousScrollOffset: CGFloat = 0
//    @State private var state: RefreshState = .waiting
//    @State private var progress: CGFloat = .zero
//    private let kThreshHold: CGFloat = 50
//
//    @State private var frozen: Bool = false
//    init(onRefresh: @escaping OnRefresh,
//         @ViewBuilder content: () -> Content) {
//        self.onRefresh = onRefresh
//        self.content = content()
//    }
//
//  var body: some View {
//    ScrollView {
//
//      ZStack(alignment: .top) {
//          ScrollOffsetProvider()
//
////          content
////              .alignmentGuide(.top, computeValue: { _ in
////                  (state == .loading) ? -kThreshHold : 0
////              })
//          VStack { self.content }.alignmentGuide(.top, computeValue: { d in (self.state == .loading && self.frozen) ? -self.kThreshHold : 0.0 })
//
////          RefreshInficatorView(progress: progress)
////              .frame(height: kThreshHold / 2)
////              .offset(y: (state == .loading && self.frozen) ? 0 : -kThreshHold)
//        }
//      }
//      .onPreferenceChange(PositionPreferenceKey.self) { value in
////        if state != .loading {
//          DispatchQueue.main.async {
//              let offset = value - 50
//              self.progress = offset / kThreshHold
////              if offset > kThreshHold && state == .waiting {
//              if state == .waiting && (offset > kThreshHold && previousScrollOffset <= kThreshHold) {
//                  state = .loading
//                  onRefresh {
//                      withAnimation {
//                          self.state = .waiting
//                      }
//                  }
//              } else {
//                  state = .waiting
//              }
//
//              if state == .loading {
//                // Crossing the threshold on the way up, we add a space at the top of the scrollview
//                if self.previousScrollOffset > self.kThreshHold && offset <= kThreshHold {
//                    self.frozen = true
//                }
//              } else {
//                    // remove the sapce at the top of the scroll view
//                    self.frozen = false
//              }
//              self.previousScrollOffset = offset
//          }
////        }
//      }
//  }
//}
//
