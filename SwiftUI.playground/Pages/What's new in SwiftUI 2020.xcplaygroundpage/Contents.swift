import SwiftUI
import Combine
import PlaygroundSupport

// Support SwiftUI for apps, it's possible to build
// whole application with SwiftUI
// Scene - new component to define pieces/components of UI with support for multiplatform
// WindowGroup - support windows for multiplatform, manageing single window for application

//@main // commented out becuse of playground compilation issues
struct HelloWorldApp: App {
    var body: some Scene {
        WindowGroup {
            Text("hello world!")
                .padding()
        }
    }
}

// Support for Widgets

// @main
struct RecommendedAlbum: Widget {
    var body: some WidgetConfiguration {
        EmptyWidgetConfiguration()
    }
}

// Complications for WatchKit

struct CoffeeHistoryChart: View {
    var body: some View {
        VStack {
//            ComplicationHistoryLabel { }
        }
    }
}

// Improvements to display lists and Collections
// Outlines:

struct Graphic: Identifiable {
    var id: String
    var name: String
    var children: [Graphic]?
    
    static func generate() -> [Graphic] {
        (0..<10).map { index in
            let children = (0..<3).map { subindex in
                Graphic(id: "\(index)-\(subindex)", name: "Item \(index)-\(subindex)", children: nil)
            }
            return Graphic(id: String(index), name: "Section \(index)", children: children)
        }
    }
}

struct ListWithOutlinesSample: View {
    var graphics: [Graphic]
    
    var body: some View {
        List(graphics, children: \.children) {
            Text($0.name)
        }
        .listStyle(SidebarListStyle())
    }
}

// Lazy grids layouts:

struct GridSample: View {
    var items: [String]
    
    var body: some View {
        ScrollView {
            // adaptive with minimum width
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 50))]) {
                ForEach(items) {
                    Text($0).padding().background(.red)
                }
            }
            
            // fixed number of columns
            LazyVGrid(columns: Array(repeating: GridItem(), count: 2)) {
                ForEach(items) {
                    Text($0).padding().background(.red)
                }
            }
            
            // horizontal
            LazyHGrid(rows: [GridItem()]) {
                ForEach(items) {
                    Text($0).padding().background(.red)
                }
            }
            
            // diffrent layout
            LazyVStack(spacing: 2) {
                ForEach(items) {
                    switch $0 {
                    case "a":
                        Text($0).padding(10).background(.red)
                    case "b":
                        Text($0).padding().background(.green)
                    default:
                        Text($0).padding().background(.blue)
                    }
                }
            }
        }
    }
}

// Toolbar:

struct BookList: View {
    var body: some View {
        NavigationView {
            List(0..<10) {
                Text(String($0))
            }
        }
    }
}

struct BookListToolbar: View {
    @State var selection: Int
    
    var body: some View {
        BookList().toolbar {
//            ToolbarItem(placement: .principal) {
//                Picker("View", selection: $selection) {
//                    Text("Details").tag(0)
//                    Text("Notes").tag(1)
//                    Text("Settings").tag(2)
//                }
//                .pickerStyle(SegmentedPickerStyle())
//            }
    //        ToolbarItem(placement: .confirmationAction) {
    //            Button("Cancel", action: { })
    //        }
            
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: { }) {
                    Label("Progress", systemImage: "book.circle") // SF Symobol 2.0
                }
            }
        }
    }
}


// Labels

struct LabelListSample: View {
    var body: some View {
        List {
            Label("Intrduction to SwiftUI", systemImage: "hand.wave")
            Label("SwiftUI Essentials", systemImage: "studentdesk")
            Label("Data Essentials in SwiftUI", systemImage: "flowchart")
        }
    }
}

// Help modifier (with support for accessibility)

let labelWithHelp = Label("Intrduction to SwiftUI", systemImage: "hand.wave").help("Kickoff with SwiftUI")

// ProgressViews

let progressViews = VStack {
    // Linear
    ProgressView("Downloading Photo", value: 0.5)
    // Circular
    ProgressView("Downloading Photo", value: 0.5)
        .progressViewStyle(CircularProgressViewStyle())
    // Spinning
    ProgressView()
}

// Effects and Styling

struct Album: Identifiable {
    let id: String
    let name: String
    
    static func generate() -> [Album] {
        (0..<10).map {
            Album(id: "\($0)", name: "Item \($0)")
        }
    }
}

struct GeometryEffectSample: View {
    @State var unselectedAlbums: [Album]
    @State var selectedAlbums: [Album]
    
    @Namespace private var namespace
    
    var albumGrid: some View {
        ScrollView {
            LazyVGrid(columns: [GridItem()]) {
                ForEach(unselectedAlbums) { album in
                    Button(action: { select(album) }) {
                        Text(album.name)
                            .foregroundColor(.white)
                            .background(.red)
                    }
                    .padding()
                    .matchedGeometryEffect(id: album.id, in: namespace)
                }
            }
        }
    }
    
    var selectedAlbumRow: some View {
        HStack {
            ForEach(selectedAlbums) { album in
                Text(album.name)
                    .foregroundColor(.white)
                    .background(.red)
                    .matchedGeometryEffect(id: album.id, in: namespace)
            }
        }
    }
    
    var body: some View {
        VStack {
            albumGrid
            selectedAlbumRow
        }
    }
    
    private func select(_ album: Album) {
        guard let index = unselectedAlbums.firstIndex(where: { $0.id == album.id }) else {
            return
        }
        unselectedAlbums.remove(at: index)
        selectedAlbums.append(album)
    }
}


// Dynamic Type scaling

struct DynamicTypeScalingSample: View {
    
    // UI Typography for accesibility sizes
    @ScaledMetric private var padding: CGFloat = 10.0
    
    var body: some View {
        VStack {
            Text("Title")
                .font(.custom("AvenirNext-Regular", size: 30))
            Text("\(Image(systemName: "music.mic")) Subtitle")
                .font(.custom("AvenirNext-Regular", size: 17))
        }
        .padding(padding)
        .background(Color.mint)
        .foregroundColor(Color.white)
    }
}

// Tint modifier

struct ListItemTintSample: View {
    @State private var isOn = true
    
    var body: some View {
        List {
            Section {
                Label("Menu", systemImage: "list.bullet")
                Label("Favorites", systemImage: "heart")
                    .listItemTint(.red)
                Label("Rewards", systemImage: "seal")
                    .listItemTint(.purple)
            }
            Section(header: Text("Recipes")) {
                Label("Recipe 1", systemImage: "book")
                Label("Recipe 2", systemImage: "book")
                Label("Recipe 3", systemImage: "book")
            }
            .listItemTint(.monochrome)
            Section {
                Toggle(isOn: $isOn) {
                    Text("Toggle tint")
                }
                .toggleStyle(SwitchToggleStyle(tint: .pink))
            }
        }
    }
}

//PlaygroundPage.current.setLiveView(ListWithOutlinesSample(graphics: Graphic.generate()).frame(width: 320, height: 480))
//PlaygroundPage.current.setLiveView(GridSample(items: ["a", "b", "c", "d", "e"]).frame(width: 320, height: 480))
//PlaygroundPage.current.setLiveView(BookListToolbar(selection: 1).frame(width: 320, height: 480))
//PlaygroundPage.current.setLiveView(LabelListSample().frame(width: 320, height: 480))
//PlaygroundPage.current.setLiveView(labelWithHelp.frame(width: 320, height: 480))
//PlaygroundPage.current.setLiveView(progressViews.frame(width: 320, height: 480))
//PlaygroundPage.current.setLiveView(GeometryEffectSample(unselectedAlbums: Album.generate(), selectedAlbums: []).frame(width: 320, height: 480))
//PlaygroundPage.current.setLiveView(DynamicTypeScalingSample().frame(width: 320, height: 480))
PlaygroundPage.current.setLiveView(ListItemTintSample().frame(width: 320, height: 480))

// Helpers

extension String: Identifiable {
    public var id: Int {
        return hashValue
    }
}
