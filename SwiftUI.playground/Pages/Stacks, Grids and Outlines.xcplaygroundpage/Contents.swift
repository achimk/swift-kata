import SwiftUI
import Combine
import PlaygroundSupport

// LazyStacks

enum LazyStacksSample {
    
    struct HeroView: View {
        var body: some View {
            Rectangle()
                .fill(.purple)
                .cornerRadius(10)
                .overlay(BannerView())
        }
    }
    
    struct BannerView: View {
        var body: some View {
            VStack(alignment: .leading, spacing: 6) {
                Spacer()
                TitleView()
                RatingView()
                    
            }
            .padding(16)
        }
    }
    
    struct TitleView: View {
        var body: some View {
            HStack {
                Text("Title")
                    .foregroundColor(.white)
                Spacer()
            }
        }
    }
    
    struct RatingView: View {
        private let rating: Int
        init(rating: Int = 3) {
            self.rating = rating
        }
        var body: some View {
            HStack {
                ForEach(0..<5) { index in
                    if rating > index {
                        Image(systemName: "star.fill").foregroundColor(.yellow)
                    } else {
                        Image(systemName: "star").foregroundColor(.yellow)
                    }
                }
                Spacer()
            }
        }
    }
    
    struct Preview: View {
        var body: some View {
            ScrollView {
                LazyVStack(spacing: 30) {
                    Text("LazyVStack Sample")
                    ForEach(0..<100) { _ in
                        HeroView().frame(height: 160)
                    }
                }
                .padding(30)
            }
        }
    }
}

// LazyGrids

enum LazyGridsSample {
    struct Preview: View {
        private var columns = [
            GridItem(spacing: 10),
            GridItem(.flexible(minimum: 30, maximum: 100), spacing: 10)
        ]
        
        var body: some View {
            ScrollView {
                Spacer(minLength: 30)
                Text("LazyVGrid Sample")
                LazyVGrid(columns: columns, spacing: 10) {
                    ForEach(0..<100) { index in
                        Rectangle()
                            .fill(index % 2 == 0 ? .mint : .orange)
                            .cornerRadius(4)
                            .frame(height: 66)
                    }
                }
                Spacer(minLength: 30)
            }
        }
    }
}

// Outlines

enum OutlineGroupSample {
    struct ModelGroup: Identifiable {
        let id = UUID()
        let title: String
        var children: [ModelGroup]?
    }
    
    struct TestData {
        static func generate() -> [ModelGroup] {
            (0..<10).map { index in
                let children = (0..<3).map {
                    ModelGroup(title: "Item \($0)", children: nil)
                }
                return ModelGroup(title: "Group \(index)", children: children)
            }
        }
    }
    
    struct Preview: View {
        private var models: [ModelGroup] = TestData.generate()
        var body: some View {
            List {
                ForEach(models) { model in
                    Section(header: Text(model.title)) {
                        OutlineGroup(model, children: \.children) { item in
                            Text(item.title)
                        }
                    }
                }
            }
        }
    }
}

// DisclosureGroup

enum DisclosureGroupSample {
    
    struct ColorView: View {
        private let color: Color
        init(_ color: Color) {
            self.color = color
        }
        
        var body: some View {
            Circle()
                .fill(color)
        }
    }
    
    struct Preview: View {
        @State private var areFillColorsExpanded = true
        
        var body: some View {
            VStack {
                Text("DisclosureGroup Sample").padding()
                Form {
                    DisclosureGroup(isExpanded: $areFillColorsExpanded) {
                        Text("Pick your color")
                        HStack {
                            ColorView(.pink)
                            ColorView(.orange)
                            ColorView(.mint)
                            ColorView(.indigo)
                            ColorView(.purple)
                        }
                    } label: {
                        Label("Colors", systemImage: "flowchart")
                    }
                }
            }
        }
    }
}

// Previews

struct Previews: View {
    var body: some View {
        VStack {
//            LazyStacksSample.Preview()
//            LazyGridsSample.Preview()
//            OutlineGroupSample.Preview()
            DisclosureGroupSample.Preview()
        }
        .frame(width: 420, height: 680)
        .background(Color(uiColor: .secondarySystemBackground))
    }
}


PlaygroundPage.current.setLiveView(Previews())
