import SwiftUI
import Combine
import PlaygroundSupport

/*
 1. Identity
 - explicit identity (custom or data driven)
 - structural identity (view hierarchy)
 
 SwiftUI is not pointer identity, which was previously used by UIKit.
 Instead it is Value type driven, not allocated (no pointers), ifficient memory representation,
 supports small, single-purpose components (SwiftUI essentials WWDC19)
 
 Structural identity - for relative aragment to define identity. Usually if ousung `if` statements
 or using conditional logic within your View code.
 Istead using conditional identity, SwifyUI promote to use single view as state of truth by default
 to preserve identity and provide more fluid transition.
 
 Don't use AnyView (type erasing any tipe which hides the type of the viwe it is wrappong) on the structure of your views.
 Conditional structure is unable to see code if it is wrapped into AnyView, the identity cannot be return (some View = AnyView
 instead _ConditionalContent generic).
 */

enum IdentitySample {
    
    struct ItemData: Identifiable {
        let id = UUID()
        let title: String
    }
    
    struct DataDrivenIdentity: View {
        private var items: [ItemData]
        
        var body: some View {
            List {
                ForEach(items, id: \.id) { item in
                    Text(item.title)
                }
            }
        }
        
    }
    
    struct CustomIdentityPreview: View {
        let item = ItemData(title: "Text")
        let headerId: Int = 1
        
        var body: some View {
            ScrollViewReader { proxy in
                ScrollView {
                    Text(item.title).id(headerId)
                    
                    Text("Lorem ipsum")
                    
                    Button("Jump top") {
                        withAnimation {
                            proxy.scrollTo(headerId)
                        }
                    }
                }
            }
        }
    }
    
    struct StructuralIdentityPreview: View {
        private var items: [ItemData]
        
        var body: some View {
            /*
             Text and List identities are the same
             because they are replaced by respectivly
             by `if` statement.
             It's also tru if those view doesn't change
             placese in view's hierarchy.
             some View is translated into generic of
             _ConditionalContent<Text, List> and it
             si powered by @ViewBuilder.
             
             some View - return type of our body property,
             is a placehoder which represents static composite
             type.
             
             @ViewBuilder - type of result builder in SwiftUI
             creates single view with logic statements in our
             property.
             */
            if items.isEmpty {
                Text("Empty")
            } else {
                List {
                    ForEach(items) { item in
                        Text(item.title)
                    }
                }
            }
        }
    }
    
    /*
     @ViewBuilder supports for `if` conditional statements
     and also `switch` statements by default. For both
     signature _ConditionalContent stays the same.
     */
    struct ViewBuilderPreview: View {
        private var count: Int
        
        @ViewBuilder // implicit
        var body: some View {
            VStack {
                viewFromIfStatement(for: count)
                viewFromSwitchStatement(for: count)
            }
        }
        
        // @ViewBuilder needs to be explicity if
        // called from function or property
        // which is not default body!
        @ViewBuilder
        func viewFromIfStatement(for count: Int) -> some View {
            if count > 0 {
                Text("count > 0")
            } else if count == 0 {
                Label("None", systemImage: "void")
            } else {
                Text("count < 0")
            }
        }
        
        // @ViewBuilder needs to be explicity if
        // called from function or property
        // which is not default body!
        @ViewBuilder
        func viewFromSwitchStatement(for count: Int) -> some View {
            switch count {
            case 0:
                Label("0", systemImage: "")
            case 1:
                Label("1", systemImage: "")
            case 2:
                Label("2", systemImage: "")
            case 3:
                Label("3", systemImage: "")
            default:
                Text("Unknown count")
            }
        }
        
    }
}

/*
 2. Lifetime - define statement for different values over time for some identity view.
 When view is first created then SwiftUI assigns it an identity using a combination
 of techniques used by explicit or structural identity (onAppear).
 Over time driven by updates new value for view are created, but from SwiftUI perspective
 these represent the same view.
 Once view's identity changes or the view is removed, its lifetime ends (onDisapear).
 */
 
enum LifetimeSample {
    
    class DownloadProgress: ObservableObject {
        @Published var title: String = ""
        @Published var progress: Double = 0.0
    }
    
    struct DownloadProgessView: View {
        let progress: Double
        var body: some View {
            Text("Progess: \(progress)")
        }
    }
    
    struct DownloadItemView: View {
        // @State and @StateObject == View lifetime
        @StateObject private var progress: DownloadProgress
        
        var body: some View {
            VStack {
                Text(progress.title)
                /*
                 SwiftUI copy value every change to perform
                 a comparison and know if the view has changed.
                 After that value is destroyied.
                 View value != view identity
                 */
                DownloadProgessView(progress: progress.progress)
            }
        }
    }
}

/*
 3. Dependencies - all propeties associated with view, when properties are
 changing then the viwe is required to produce new body.
 Dependency Graph is used to obtain proper values in view's hierarchy (it's required
 because SwiftUI relays on this graph to efficient update the body).
 
 Dependency graph
 - underlying representation of SwiftUI views
 - identity is the backbone of the graph
 - efficiently updates the UI (only dependencies that are changed and tied with views)
 - value comparison reduces body generation
 
 Kind of dependencies (properties of the struct):
 - @Binding,
 - @Environment,
 - @State,
 - @StateObject,
 - @ObservedObject,
 - @EnvironmentObject
 
 Identifier stability:
 - directly imapcts lifetime
 - helps performance
 - minimalizes dependency churn
 - avoids state loss
 
 Identifier uniqueness
 - improve animations
 - also helps performance
 - correctly refects dependnecies
 */

enum DependenciesSample {
    enum Animal {
        case dog, cat
    }
    
    struct Pet: Identifiable {
        var name: String
        var kind: Animal
        
        // Not stable identifier, produce animation
        // glitches between the update and animates
        // all elements.
//        var id: UUID { UUID() }
        // Stable identifier should be used:
        var id = UUID()
    }
    
    struct FavouritePets: View {
        var pets: [Pet]
        var body: some View {
            List {
                ForEach(pets) { pet in
                    Text(pet.name)
                }
            }
        }
    }
}

enum ViewModeifierSample {
    
    struct ExpirationModifier: ViewModifier {
        var date: Date
        func body(content: Content) -> some View {
            // ViewModifiers are also producing structural idenfiers
//            if date < .now {
//                content.opacity(0.3)
//            } else {
//                content
//            }
            // There is no cost for change opacity directly,
            // branches are removed and the same view is used
            content.opacity(date < .now ? 0.3 : 1.0)
        }
    }
    
    struct Product: Identifiable {
        let id = UUID()
        let title: String
        let expiryDate: Date
    }
    
    struct Preview: View {
        let products: [Product]
        
        var body: some View {
            ForEach(products, id: \.id) { product in
                Text(product.title)
                    .modifier(ExpirationModifier(date: product.expiryDate))
            }
        }
    }
}
