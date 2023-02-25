import SwiftUI
import Combine
import PlaygroundSupport

// State -> Binding between Views
// @Binding modificator (only for @State)

enum BindingSample {
    
    struct EditorConfig {
        var isEditorPresent = false
        var note = ""
        var progress: Double = 0.0
        
        mutating func present(initialProgress: Double) {
            isEditorPresent = true
            note = ""
            progress = initialProgress
        }
    }
    
    struct BookView: View {
        @State private var editorConfig = EditorConfig()
        var body: some View {
            VStack {
                Button(action: {}) {
                    Label("Update progress", systemImage: "book.circle")
                }
            }
        }
    }
    
    struct ProgressEditor: View {
        @Binding var editorConfig: EditorConfig
        
        var body: some View {
            VStack {
                Slider(value: $editorConfig.progress, in: 0.0...1.0)
                TextEditor(text: $editorConfig.note)
            }
        }
    }
}

// Using ObservableObject
/*
 @Publish
 - automatically works with ObservableObject
 - publishes every time the value changes in willSet
 - projectedValue is a Publisher
 
 Why willChange is used instead didChange?
 willChange (willSet) is for collect changes to perform single update in SwiftUI
 */

enum ObservableObjectSample {
    
    struct Book {
        let title: String
    }
    
    struct ReadingProgress {
        struct Entry: Identifiable {
            let id: UUID
            let progress: Double
            let time: Date
            let not: String?
        }
        var entries: [Entry]
    }
    
    class CurrentlyReading: ObservableObject {
        @Published var progress: ReadingProgress
        @Published var isFinished = false
        let book: Book
        
        init(book: Book) {
            self.book = book
            self.progress = ReadingProgress(entries: [])
        }
        
        var currentProgess: Double {
            isFinished ? 1.0 : progress.entries.last?.progress ?? 0.0
        }
    }
    
    struct BookView: View {
        @ObservedObject var currentlyReading: CurrentlyReading
        
        var body: some View {
            VStack {
                BookCard(currentlyReading: currentlyReading)
                makeBookControls()
                ProgressDetailsList(readingProgress: currentlyReading.progress)
            }
        }
        
        private func makeBookControls() -> some View {
            HStack {
                Button(action: { }) {
                    Label("Update progress", systemImage: "book.circle")
                }
                .disabled(currentlyReading.isFinished)
                Toggle(isOn: $currentlyReading.isFinished) {
                    Label("I'm done", systemImage: "checkmark.circle.fill")
                }
            }
        }
    }
    
    struct BookCard: View {
        let currentlyReading: CurrentlyReading
        
        var body: some View {
            Rectangle()
                .fill(.purple)
                .cornerRadius(8)
                .overlay(Text(String(currentlyReading.progress.entries.last?.progress ?? 0.0)))
        }
    }
    
    
    struct ProgressDetailsList: View {
        let readingProgress: ReadingProgress
        
        var body: some View {
            List {
                ForEach(readingProgress.entries) { entry in
                    Text("\(entry.progress) at \(entry.time)")
                }
            }
        }
    }
}

/*
 @StateObject (ties life cycle of object with view)
 - SwiftUI owns the ObservableObject
 - creation and destruction is tied to the view's life cycle
 - instantiated just before body
 */

enum StateObjectSample {
    
    class CoverImageLoader: ObservableObject {
        @Published private(set) var image: Image? = nil
        
        deinit {
            cancel()
        }
        
        func load(_ name: String) {
            //...
        }
        
        func cancel() {
            //...
        }
    }
    
    struct BookCoverView: View {
        @StateObject var loader = CoverImageLoader()
        
        var coverName: String
        var size: CGFloat
        
        var body: some View {
            CoverImage(image: loader.image, size: size)
                .onAppear { loader.load(coverName) }
        }
    }
    
    struct CoverImage: View {
        var image: Image?
        var size: CGFloat
        
        var body: some View {
            Rectangle().fill(.red)
        }
    }
}

// @EnvironmentObject view modifier
/*
 Pass for example ObservableObject through views tree but only
 to dedicated subviews. TO receive the dependcy it need to be
 precedence with @EnvironmentObject modifier
 
 To set @EnvironmentObject:
 .environmentObject(ObservableObject)
 
 To receive @EnvironmentObject:
 @EnvironmentObject var model: ...
 */


// @SceneStorage
/*
 @SceneStorage is lightweight store with data for views
 used when user wants to restore application state from
 background or restart of the app.
 - scene-scoped
 - SwiftUI managed
 - View-only
 */
enum SceneStorageSample {
    
    struct readingListViewer: View {
        @SceneStorage("selection") var selection: String?
        
        var body: some View {
            NavigationView {
                ReadingList(selection: $selection)
            }
        }
    }
    
    struct ReadingList: View {
        @Binding var selection: String?
        
        var body: some View {
            List {
                
            }
        }
    }
    
}

// @AppStorage
/*
 @AppStorage is usefull to setup data for Settings.
 - App-scoped
 - User defaults
 - Usable anywhere
 */
enum AppStorageSample {
    
    struct BookClubSettings: View {
        @AppStorage("updateArtwork") private var updateArtwork = true
        @AppStorage("syncProgress") private var syncProgress = true
        
        var body: some View {
            Form {
                Toggle(isOn: $updateArtwork) {
                    Text("Should update artwork")
                }
                Toggle(isOn: $syncProgress) {
                    Text("Should sync progress")
                }
            }
        }
    }
}


// Previews

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
