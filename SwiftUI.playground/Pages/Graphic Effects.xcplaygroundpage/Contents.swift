import SwiftUI
import Combine
import PlaygroundSupport

struct RedCircle: View {
    
    var body: some View {
        Circle().fill(.red)
    }
}

struct GradientView: View {
    
    var body: some View {
        let spectrum = Gradient(colors: [.red, .green, .blue])
        let conic = AngularGradient(gradient: spectrum, center: .center, angle: .degrees(-90))
        Circle().strokeBorder(conic, lineWidth: 10)
    }
}

struct ContentView: View {
 
    var body: some View {
        VStack(spacing: 5) {
            RedCircle()
            Capsule().stroke(.red, lineWidth: 10)
            Ellipse().strokeBorder(.red)
            GradientView()
        }
    }
}

PlaygroundPage.current.setLiveView(ContentView().frame(width: 320, height: 680))
