import SwiftUI
import PlaygroundSupport

/**
 Views are a function of state,
 not fof a sequence of events
 */

struct Episode {
    let title: String
    let showTitle: String
}

struct PlayerView: View {
    let episode: Episode
    @State private var isPlaying: Bool = false
    
    var body: some View {
        VStack {
            Text(episode.title).foregroundColor(isPlaying ? .black : .gray)
            Text(episode.showTitle).font(.caption).foregroundColor(.gray)
            PlayButton(isPlaying: $isPlaying)
        }
    }
}

struct PlayButton: View {
    @Binding var isPlaying: Bool
    
    var body: some View {
        Button(action: {
            withAnimation { isPlaying.toggle() }
        }) {
            Image(systemName: isPlaying ? "pause.circle" : "play.circle")
        }
    }
}

struct ContentView: View {
 
    var body: some View {
        let episode = Episode(title: "Red Hot Chili Peppers", showTitle: "By the way")
        PlayerView(episode: episode)
            .tint(.orange)
            .padding()
            .frame(width: 320)
    }
}

PlaygroundPage.current.setLiveView(ContentView())
