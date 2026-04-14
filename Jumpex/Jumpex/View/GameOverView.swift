import SwiftUI

struct GameOverView: View {
    @ObservedObject var viewModel: ViewModelJumpex
    @Binding var currentScreen: GameScreen

    var body: some View {
        VStack(spacing: 30) {
            Spacer()

            VStack(spacing: 10) {
                Image(systemName: "xmark.circle.fill")
                    .font(.system(size: 80))
                    .foregroundColor(.red)

                Text("GAME OVER")
                    .font(.system(size: 40, weight: .bold))
                    .foregroundColor(.white)
            }

            Spacer()

            VStack(spacing: 10) {
                Text("PUNTUACIÓN FINAL")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.white)

                Text("\(viewModel.score)")
                    .font(.system(size: 60, weight: .bold))
                    .foregroundColor(.yellow)
                    .shadow(radius: 5)
            }

            Spacer()

            VStack(spacing: 15) {
                Button(action: {
                    viewModel.restartGame()
                    withAnimation(.easeInOut(duration: 0.5)) {
                        currentScreen = .gameplay
                    }
                }) {
                    Text("REINTENTAR")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 60)
                        .background(
                            LinearGradient(
                                gradient: Gradient(colors: [Color.green, Color(red: 0, green: 0.6, blue: 0)]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .cornerRadius(15)
                }

                Button(action: {
                    viewModel.stopGameLoop()
                    withAnimation(.easeInOut(duration: 0.5)) {
                        currentScreen = .welcome
                    }
                }) {
                    Text("MENÚ PRINCIPAL")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 60)
                        .background(Color.gray)
                        .cornerRadius(15)
                }
            }
            .padding(.horizontal, 40)

            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct GameOverOverlay: View {
    let score: Int
    @Binding var currentScreen: GameScreen
    @ObservedObject var viewModel: ViewModelJumpex

    var body: some View {
        ZStack {
            Color.black.opacity(0.4)
                .ignoresSafeArea()

            GameOverView(viewModel: viewModel, currentScreen: $currentScreen)
        }
    }
}
