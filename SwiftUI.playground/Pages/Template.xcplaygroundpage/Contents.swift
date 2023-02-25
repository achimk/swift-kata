import SwiftUI
import Combine
import PlaygroundSupport

struct Previews: View {
    var body: some View {
        VStack(spacing: 30) {
            Text("Hello, world!")
        }
        .frame(width: 420, height: 680)
        .background(Color(uiColor: .secondarySystemBackground))
    }
}


PlaygroundPage.current.setLiveView(Previews())
