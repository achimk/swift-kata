import SwiftUI
import Combine
import PlaygroundSupport

struct ContentView: View {
 
    var body: some View {
        Text("Hello world!")
            .tint(.orange)
            .padding()
    }
}

let withEnvironmentModifiers = ContentView()
    .environment(\.sizeCategory, .extraExtraExtraLarge)
    .environment(\.layoutDirection, .leftToRight)
    .environment(\.locale, Locale(identifier: "GB"))
    .preferredColorScheme(.dark)

PlaygroundPage.current.setLiveView(withEnvironmentModifiers.frame(width: 320, height: 480))
