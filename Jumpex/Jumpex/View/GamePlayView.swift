import SwiftUI

struct GamePlayView: View {
    @ObservedObject var viewModel: ViewModelJumpex
    @Binding var currentScreen: GameScreen

    var body: some View {
        ZStack {
            Color(red: 0.3, green: 0.7, blue: 0.9)
                .ignoresSafeArea()

            VStack(spacing: 10) {
                HStack {
                    VStack(alignment: .leading, spacing: 5) {
                        Text("PUNTUACIÓN")
                            .font(.system(size: 12, weight: .semibold))
                            .foregroundColor(.white)

                        Text("\(viewModel.score)")
                            .font(.system(size: 28, weight: .bold))
                            .foregroundColor(.yellow)
                    }

                    Spacer()

                    VStack(alignment: .trailing, spacing: 5) {
                        Text("NIVEL")
                            .font(.system(size: 12, weight: .semibold))
                            .foregroundColor(.white)

                        Text(viewModel.elapsedTime < 60 ? "PRINCIPIANTE" : "DIFÍCIL")
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(.yellow)
                    }
                }
                .padding()
                .background(Color.black.opacity(0.3))
                .cornerRadius(10)
                .padding()

                Spacer()

                GeometryReader { geometry in
                    ZStack {
                        VStack(spacing: 0) {
                            Divider()
                                .frame(height: geometry.size.height / 3)
                            Divider()
                        }
                        .opacity(0.3)

                        ForEach(viewModel.obstacles.indices, id: \.self) { index in
                            let obstacle = viewModel.obstacles[index]
                            Circle()
                                .fill(
                                    LinearGradient(
                                        gradient: Gradient(colors: [Color.red, Color(red: 0.8, green: 0, blue: 0)]),
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .frame(width: obstacle.width, height: obstacle.height)
                                .position(x: obstacle.center.x, y: obstacle.center.y)
                                .shadow(radius: 3)
                        }

                        if let player = viewModel.player {
                            Circle()
                                .fill(
                                    LinearGradient(
                                        gradient: Gradient(colors: [Color.green, Color(red: 0, green: 0.6, blue: 0)]),
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .frame(width: player.width, height: player.height)
                                .position(x: player.center.x, y: player.center.y)
                                .shadow(radius: 5)
                        }
                    }
                    .onAppear {
                        viewModel.setUpPlayer(size: geometry.size)
                    }
                }
                .background(Color(red: 0.5, green: 0.8, blue: 1.0))
                .cornerRadius(10)
                .padding()

                HStack(spacing: 15) {
                    LaneControlButton(lane: 0, action: { viewModel.movePlayerToLane(0) })
                    LaneControlButton(lane: 1, action: { viewModel.movePlayerToLane(1) })
                    LaneControlButton(lane: 2, action: { viewModel.movePlayerToLane(2) })
                }
                .padding()
            }

            if viewModel.gameOver {
                GameOverOverlay(score: viewModel.score, currentScreen: $currentScreen, viewModel: viewModel)
            }
        }
    }
}

struct LaneControlButton: View {
    let lane: Int
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: 5) {
                Image(systemName: "arrow.up")
                    .font(.system(size: 16, weight: .semibold))

                Text("CARRIL \(lane + 1)")
                    .font(.system(size: 10, weight: .semibold))
            }
            .frame(maxWidth: .infinity)
            .frame(height: 50)
            .foregroundColor(.white)
            .background(Color.blue)
            .cornerRadius(10)
            .shadow(radius: 3)
        }
    }
}
