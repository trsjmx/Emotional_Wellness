import SwiftUI

struct EndPage: View {
    private let numberOfStars = 10
    private let minStarDistance: CGFloat = 100.0
    private let starPlacementRange: CGFloat = 200
    private let starRegenerationInterval: Double = 2.0

    @State private var starPositions: [CGSize] = []
    @State private var timer: Timer?

    var body: some View {
        NavigationView {
            ZStack {
                // Background color
                Color.cyan.opacity(0.2)
                    .edgesIgnoringSafeArea(.all)

                // Stars
                ForEach(0..<starPositions.count, id: \.self) { index in
                    CustomStarShape()
                        .frame(width: 50, height: 50)
                        .foregroundColor(Color.white.opacity(0.8))
                        .offset(x: starPositions[index].width, y: starPositions[index].height)
                }
                
                // "END GAME" Text
                VStack(spacing: 5) {
                    Text("END GAME")
                        .font(.system(size: 70)) // Increased font size
                        .fontWeight(.bold)
                        .foregroundColor(.black)
                    
                    Text("Doll name has fulfilled its duty. Hope it made you feel better.")
                        .font(.system(size: 16)) // Smaller font size for the bottom text
                        .fontWeight(.bold)
                        .foregroundColor(.black)
                        .multilineTextAlignment(.center)
                        .frame(maxWidth: .infinity) // Ensures it spans the width
                }
                .padding()
                .position(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height / 3) // Centered vertically
                
            }
            .onAppear {
                generateStarPositions()
                startStarRegeneration()
            }
            .onDisappear {
                timer?.invalidate()
            }
        }
    }

    func generateStarPositions() {
        DispatchQueue.global(qos: .userInitiated).async {
            var positions: [CGSize] = []
            
            while positions.count < numberOfStars {
                let newPosition = CGSize(
                    width: CGFloat.random(in: -starPlacementRange...starPlacementRange),
                    height: CGFloat.random(in: -starPlacementRange...starPlacementRange)
                )
                
                if positions.allSatisfy({ distance($0, newPosition) >= minStarDistance }) {
                    positions.append(newPosition)
                }
            }
            
            DispatchQueue.main.async {
                starPositions = positions
            }
        }
    }

    func startStarRegeneration() {
        timer = Timer.scheduledTimer(withTimeInterval: starRegenerationInterval, repeats: true) { _ in
            withAnimation {
                starPositions.removeAll() // Fade out stars
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                generateStarPositions() // Generate new star positions
            }
        }
    }

    func distance(_ a: CGSize, _ b: CGSize) -> CGFloat {
        return sqrt(pow(a.width - b.width, 2) + pow(a.height - b.height, 2))
    }
}

struct CustomStarShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let points = [
            CGPoint(x: rect.width / 2, y: 0),
            CGPoint(x: rect.width, y: rect.height / 2),
            CGPoint(x: rect.width / 2, y: rect.height),
            CGPoint(x: 0, y: rect.height / 2)
        ]
        path.move(to: points[0])
        path.addLines(points)
        path.closeSubpath()
        return path
    }
}

struct EndPage_Previews: PreviewProvider {
    static var previews: some View {
        EndPage()
    }
}