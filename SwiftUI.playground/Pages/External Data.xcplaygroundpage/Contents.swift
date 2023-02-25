import SwiftUI
import Combine
import PlaygroundSupport

struct Episode {
    let title: String
    let showTitle: String
}

class PodcastPlayerStore: ObservableObject {
    @Published var currentTime: TimeInterval = 0
    @Published var isPlaying: Bool = false
    @Published var currentEpisode: Episode = Episode(title: "Red Hot Chili Peppers", showTitle: "By the way")
    
    func adavance() { }
    func skipForward() { }
    func skipBackward() { }
}

struct PlayerView: View {
    @ObservedObject var player: PodcastPlayerStore
    @State private var isPlaying: Bool = false
    
    var body: some View {
        VStack {
            Text(player.currentEpisode.title).foregroundColor(isPlaying ? .black : .gray)
            Text(player.currentEpisode.showTitle).font(.caption).foregroundColor(.gray)
            PlayButton(isPlaying: $player.isPlaying)
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
        let player = PodcastPlayerStore()
        PlayerView(player: player)
            .tint(.orange)
            .padding()
            .frame(width: 320)
    }
}

PlaygroundPage.current.setLiveView(ContentView())
