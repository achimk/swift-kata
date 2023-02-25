import SwiftUI
import Combine
import PlaygroundSupport

/**
 Auto Accessibility in SwiftUI
 */

struct ContentView: View {
    @State private var enabled = false
 
    var body: some View {
        VStack {
            Text("Top") // Default accessibility Text
            Toggle(isOn: $enabled) { // Default accessibility Toggle
                Text("Enabled") // Auto notify due to change of state
            }
            Button(action: { print("action!") }) { // Default accessibility Button
                Text("Action")
            }
            Text("Bottom") // Default accessibility Text
            
            Button(action: { print("action 2!") }) {
                Text("Action 2")
            }
            .buttonStyle(CustomButtonStyle())
        }
    }
}

struct CustomButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.system(size: 18))
            .foregroundColor(configuration.isPressed ? .black : .white)
            .padding(8)
            .background(RoundedRectangle(cornerRadius: 5).fill(configuration.isPressed ? .red : .blue))
    }
}

struct SignupCompleteView: View {
    var body: some View {
        VStack {
            /**
             Accessiblity will read image name!
             To prevent this behaviour we need to use label
             property and provide correct name
             */
            Image("Checkmark", label: Text("Signup Complete!"))
            /**
             To ignore read for image then use decorative property
             */
            Image(decorative: "Checkmark")
        }
    }
}

/**
 SwiftUI Accessibility API
 */

let isSelected = false
Rectangle().fill(.red)
    // view modifiers:
    .accessibilityLabel(Text("Red rectangle")) // for name label
    .accessibilityValue(Text("None")) // for value of displayed view
    .accessibilityAddTraits(isSelected ? .isSelected : []) // for selected state
    .accessibilityAction(named: Text("Clear")) { // custom action
        // clear function here
    }

struct ContrastRatioView: View {
    @State private var ratio: Double
    
    var body: some View {
        VStack {
            Rectangle().fill(.blue)
                .accessibilityLabel(Text("Contact Ratio"))
                .accessibilityValue(Text("\(ratio) to 1"))
                .accessibilityAddTraits(.isHeader) // First header group
            
            VStack {
                Text("Configure") // Configuration header group
                    .accessibilityAddTraits(.isHeader) // Second header group
                
                Text(verbatim: String(format: "Ratio: %.0f", ratio))
//                    .accessibility(visiblility: .hidden) // To ignore reading
            }
        }
            
    }
}

/**
 Accessibility Tree
 Navigate by grouping
 */

struct TableCell: View {
    var body: some View {
        HStack {
            Text("Person")
            Spacer()
            Button(action: { }) {
                Text("Follow")
            }
            Button(action: { }) {
                Text("Share")
            }
        }
        .accessibilityElement(children: .combine) // merge view elements into one accessibilty
    }
}

/**
 Ordering
 sort priority by default all are 0, but we cen overrdie this
 */
Button(action: {}) {
    Text("Reset")
        .foregroundColor(.blue)
}
.accessibilitySortPriority(1) // force to be first


PlaygroundPage.current.setLiveView(ContentView().frame(width: 320, height: 480))
