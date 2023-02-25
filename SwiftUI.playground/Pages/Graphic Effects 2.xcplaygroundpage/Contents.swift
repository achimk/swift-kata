import SwiftUI
import Combine
import PlaygroundSupport

extension Int: Identifiable {
    public var id: Int {
        return hashValue
    }
}

// Data Model
class Ring: ObservableObject {
    
    struct Wedge {
        
        struct AnimatableData {
            
        }
        
        var width: Double
        var depth: Double
        var hue: Double
        var animatableData: AnimatableData
    }
    
    var wedges: [Int: Wedge] = [:]
    var wedgeIds: [Int] = []
    
    func deleteWedge(id: Int) {
        wedges[id] = nil
        wedgeIds.removeAll(where: { $0 == id })
    }
}

class WedgeGeometry {
    let wedge: Ring.Wedge
    let rect: CGRect
    
    var cen: CGPoint
    var r0: Double
    var r1: Double
    var a0: Angle
    var a1: Angle
    var topRight: CGPoint
    
    init(_ wedge: Ring.Wedge, in rect: CGRect) {
        self.wedge = wedge
        self.rect = rect
    }
}

struct WedgeShape: Shape {
    var wedge: Ring.Wedge
    
    func path(in rect: CGRect) -> Path {
        var p = Path()
        let g = WedgeGeometry(wedge, in: rect)
        p.addArc(center: g.cen, radius: g.r0, startAngle: g.a0, endAngle: g.a1, clockwise: false)
        p.addLine(to: g.topRight)
        p.addArc(center: g.cen, radius: g.r1, startAngle: g.a1, endAngle: g.a0, clockwise: true)
        p.closeSubpath()
        return p
    }
    
    var animatableData: Ring.Wedge.AnimatableData {
        get { return wedge.animatableData }
        set { wedge.animatableData = newValue }
    }
}

struct RingView: View {
    @EnvironmentObject var ring: Ring
    
    var body: some View {
        ZStack {
            ForEach(self.ring.wedgeIds) { id in
                WedgeView(wedge: ring.wedges[id]!)
                    .onTapGesture {
                        withAnimation { ring.deleteWedge(id: id) }
                    }
                    .transition(scaleAndFade)
            }
        }
    }
}

struct WedgeView: View {
    let wedge: Ring.Wedge
    
    var body: some View {
        Rectangle().fill(.red)
    }
}

struct ScaleAndFade: ViewModifier {
    var isActive: Bool
    
    func body(content: Content) -> some View {
        return content
            .scaleEffect(isActive ? 0.1 : 1)
            .opacity(isActive ? 0 : 1)
    }
}

let scaleAndFade = AnyTransition.modifier(
    active: ScaleAndFade(isActive: true),
    identity: ScaleAndFade(isActive: false))


struct ContentView: View {
 
    var body: some View {
        Text("Hello")
            .tint(.orange)
            .padding()
            
    }
}

PlaygroundPage.current.setLiveView(ContentView().frame(width: 320, height: 480))
