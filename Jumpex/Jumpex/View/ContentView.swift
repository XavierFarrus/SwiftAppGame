import SwiftUI

enum GameScreen {
    case welcome
    case levelSelection
    case gameplay
    case gameOver
}

struct ContentView: View {
    @StateObject private var viewModel = ViewModelJumpex()
    @State private var currentScreen: GameScreen = .welcome

    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [
                    viewModel.currentLevel == 1 ? Color(red: 0.3, green: 0.7, blue: 0.9) : Color(red: 0.2, green: 0.5, blue: 0.8),
                    Color(red: 0.8, green: 0.9, blue: 1.0)
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            Group {
                switch currentScreen {
                case .welcome:
                    WelcomeView(currentScreen: $currentScreen)
                case .levelSelection:
                    LevelSelectionView(currentScreen: $currentScreen, viewModel: viewModel)
                case .gameplay:
                    GamePlayView(viewModel: viewModel, currentScreen: $currentScreen)
                case .gameOver:
                    GameOverView(viewModel: viewModel, currentScreen: $currentScreen)
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
