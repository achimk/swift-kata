import UIKit
import SwiftUI
import Combine
import PlaygroundSupport

/**
 Wrap SwiftUI content into UIKit
 SwiftUI views -> UIHostingController
 */

struct DetailView: View {
    var body: some View {
        Rectangle().fill(.red)
    }
}

let detailView = DetailView()
let hostingController = UIHostingController(rootView: detailView)



/**
 Wrap UIKit content into SwiftUI:
    
 UIView -> UIViewRepresentable -> UIViewRepresentableContext (Coord, Env, Transactions)
    - makeUIView
    - updateUIView
    - dismantleUIView
 
 UIViewController -> UIViewControllerRepresentable -> UIViewControllerRepresentableContext  (Coord, Env, Transactions)
    - makeUIViewController
    - updateUIViewController
    - dismantleUIViewController
 */

class CustomView: UIView {
    var color: UIColor = .white
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        backgroundColor = .red
    }
}

struct CustomControlRepresentation: UIViewRepresentable {
    @Binding var color: UIColor
    
    func makeCoordinator() -> Void {
        // make coordinator for taget/selectors of custom view
    }
    
    func makeUIView(context: Context) -> CustomView {
        // instantiate custom view
        return CustomView()
    }
    
    func updateUIView(_ uiView: CustomView, context: Context) {
        // update method for custom uikit view
        uiView.backgroundColor = color
    }
    
    static func dismantleUIView(_ uiView: CustomView, coordinator: Void) {
        // Dismantle uiview from hierarchy
    }
}


struct ContentView: View {
 
    var body: some View {
        Text("Hello")
            .tint(.orange)
            .padding()
            
    }
}

PlaygroundPage.current.setLiveView(ContentView().frame(width: 320, height: 480))
