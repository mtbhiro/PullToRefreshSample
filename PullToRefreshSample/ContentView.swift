//

import SwiftUI

struct ContentView: View {
  @State private var now = Date()
    @State var isLoading = false
    

  var body: some View {
      VStack {
          Text("Sample Header")
              .padding()
              .frame(height: 40)
              .background(Color.gray)
          RefreshableScrollView {
              VStack {
                  ForEach(1..<20) {
                    Text("\(Calendar.current.date(byAdding: .hour, value: $0, to: now)!)")
                       .padding(10)
                   }
                 }.padding()

          } onRefresh: { done in
              DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                  self.now = Date()
                  done()
                }
          }
      }
     }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
