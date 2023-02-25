import SwiftUI
import Combine
import PlaygroundSupport

func minSize(_ geometry: GeometryProxy) -> CGFloat {
    min(geometry.size.width, geometry.size.height)
}

struct ProgressView: View {
    let gradientColors: [Color] = [.blue, .purple]
    let sliceSize = 0.35
    let progress: Double

    init(progress: Double = 0.3) {
        self.progress = progress
    }
 
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Group {
                    Circle()
                        .trim(from: 0, to: 1 - CGFloat(sliceSize))
                        .stroke(makeStrokeGradient(), style: makeStrokeStyle(with: geometry))
                        .opacity(0.5)
                    Circle()
                        .trim(from: 0, to: (1 - CGFloat(sliceSize)) * CGFloat(progress))
                        .stroke(makeStrokeGradient(), style: makeStrokeStyle(with: geometry))
                }
                .rotationEffect(.degrees(90) + .degrees(180 * sliceSize))
                
                if progress >= 0.995 {
                    withAnimation {
                        Image(systemName: "star.fill")
                            .font(.system(size: 0.2 * minSize(geometry),
                                          weight: .bold,
                                          design: .rounded))
                            .foregroundColor(.yellow)
                            .offset(y: -0.05 * minSize(geometry))
                    }
                } else {
                    withAnimation {
                        Text(makePercentageText())
                            .font(.system(size: 0.15 * minSize(geometry),
                                          weight: .bold,
                                          design: .rounded))
                            .offset(y: -0.05 * minSize(geometry))
                    }
                }
            }
            .offset(y: 0.1 * minSize(geometry))
            .padding(20)
        }
        .cornerRadius(20)
        .background(Color(UIColor.systemBackground))
    }
    
    private func makeStrokeGradient() -> AngularGradient {
        AngularGradient(
            gradient: Gradient(colors: gradientColors),
            center: .center,
            angle: .degrees(-10))
    }
    
    private func makeStrokeStyle(with geometry: GeometryProxy) -> StrokeStyle {
        StrokeStyle(
            lineWidth: 0.08 * minSize(geometry),
            lineCap: .round)
    }
    
    private func makePercentageText() -> String {
        return "\(Int(progress * 100))%"
    }
}

struct Preview: View {
    @State var progress: Double = 0.25
    
    var body: some View {
        VStack(spacing: 30) {
            ProgressView(progress: progress)
            ProgressView(progress: progress)
                .environment(\.colorScheme, .dark)
            
            HStack(spacing: 30) {
                Button(action: decrement) {
                    Text("Decrement")
                }
                Button(action: increment) {
                    Text("Increment")
                }
            }
        }
        .background(Color(uiColor: .secondarySystemBackground))
        .frame(width: 420, height: 680)
    }
    
    private func increment() {
        withAnimation {
            progress = min(progress + 0.25, 1.0)
        }
    }
    
    private func decrement() {
        withAnimation {
            progress = max(progress - 0.25, 0.0)
        }
    }
}

PlaygroundPage.current.setLiveView(Preview())
