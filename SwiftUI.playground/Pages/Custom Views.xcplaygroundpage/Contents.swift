import SwiftUI
import Combine
import PlaygroundSupport

struct Cell: View {
    
    var body: some View {
        HStack {
            VStack {
                Text("***")
                    .alignmentGuide(.midStarAndTitle) { d in
                        d[.bottom] * 0.5
                    }
                Text("3 stars")
            }.font(.caption)
            
            VStack {
                HStack {
                    Text("Avocado Toast").font(.title)
                        .alignmentGuide(.midStarAndTitle) { d in
                            d[.bottom] * 0.5
                        }
                    Spacer()
                    Image(systemName: "play.circle").frame(width: 30, height: 30)
                }
                Text("Ingredients: Avocado, Almont Butter, Bread, Red Pepper Flakes")
                    .font(.caption)
                    .lineLimit(1)
            }
        }
        .padding([.leading, .trailing], 16)
        .padding([.bottom, .top], 8)
    }
}

extension VerticalAlignment {
    private enum MidStarAndTitle: AlignmentID {
        static func defaultValue(in context: ViewDimensions) -> CGFloat {
            return context[.bottom]
        }
    }
    
    static let midStarAndTitle = VerticalAlignment(MidStarAndTitle.self)
}

struct TitleValueCell: View {
    let title: String
    let value: String
    
    var body: some View {
        HStack(alignment: .lastTextBaseline) {
            Text(title).layoutPriority(1)
            Image(systemName: "play.circle").alignmentGuide(.lastTextBaseline) { dimention in
                dimention[.bottom] * 0.8
            }
            Text(value).font(.caption)
        }.lineLimit(1)
    }
}

struct ContentView: View {
 
    var body: some View {
        VStack {
            TitleValueCell(title: "Title", value: "Value")
            Cell()
            Cell()
            Cell()
        }
    }
}

PlaygroundPage.current.setLiveView(ContentView().frame(width: 320, height: 480))
