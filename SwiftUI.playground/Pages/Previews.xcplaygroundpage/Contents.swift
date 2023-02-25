import SwiftUI
import Combine
import PlaygroundSupport

struct Dessert {
    struct Rating {
        let rate: Int
        let maxRate: Int
        
        init(rate: Int, maxRate: Int) {
            self.rate = max(0, rate)
            self.maxRate = max(max(0, rate), max(0, maxRate))
        }
    }
    
    let name: String
    let imageName: String?
    let description: String
    let rating: Rating
}

struct DessertView: View {
    let dessert: Dessert
    
    var body: some View {
        VStack {
            Text("Rate This Dessert")
                .font(.largeTitle)
            VStack(alignment: .leading) {
                DessertImage(imageName: dessert.imageName)
                VStack(alignment: .leading, spacing: 10) {
                    Text(dessert.name)
                        .font(.headline)
                    Text(dessert.description)
                        .lineLimit(nil)
                        .font(.callout)
                        .foregroundColor(Color.secondary)
                }
                .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
            }
            .padding(.horizontal, 35.0)
            
            Spacer().frame(height: 35.0)
            Spacer()
            StarRatingView(rating: dessert.rating)
            Text("Rate it")
                .colorScheme(.dark)
                .padding(.vertical)
                .padding(.horizontal, 150)
                .background(Color(hue: 0.598, saturation: 0.749, brightness: 0.81))
                .cornerRadius(6)
        }
        .padding(.vertical)
    }
}

struct DessertImage: View {
    let imageName: String?
    
    var body: some View {
        if let imageName = imageName {
            makeImageView(with: imageName)
        } else {
            makeImagePlaceholder()
        }
    }
    
    private func makeImagePlaceholder() -> some View {
        Rectangle()
            .fill(Color.white)
            .frame(width: 350, height: 350)
            .clipShape(RoundedRectangle(cornerRadius: 10.0))
            .shadow(radius: 4.0)
    }
    
    private func makeImageView(with name: String) -> some View {
        Image(name)
            .resizable()
            .frame(width: 350, height: 350)
            .clipShape(RoundedRectangle(cornerRadius: 10.0))
            .shadow(radius: 4.0)
    }
}

struct StarRatingView: View {
    let rating: Dessert.Rating
    
    var body: some View {
        HStack {
            ForEach(0..<rating.maxRate) { rate in
                if rate < rating.rate {
                    Rectangle().fill(.red).frame(width: 20, height: 20)
                } else {
                    Rectangle().stroke(.red, lineWidth: 2).frame(width: 20, height: 20)
                }
            }
        }
        Text("Slammin'")
            .font(.caption)
    }
}

struct ContentView: View {
 
    var body: some View {
        let dessert = Dessert(
            name: "Churro Cupcake",
            imageName: nil,
            description: "Description test for the dessert...",
            rating: .init(rate: 4, maxRate: 5))
        
        DessertView(dessert: dessert)
    }
}

PlaygroundPage.current.setLiveView(ContentView().frame(width: 420, height: 680))

#if DEBUG

struct ContentViewPreviews: PreviewProvider {
    static var previews: some View {
        Group {
            ContentView()
                .previewDevice("iPhone SE")
            
            ContentView()
                .previewDevice("iPhone XR")
            
            ContentView()
                .previewLayout(.sizeThatFits)
                .environment(\.sizeCategory, .extraLarge)
                .previewDisplayName("Test")
        }
        
    }
}

#endif
