import SwiftUI

struct LevelSelectionView: View {
    @Binding var currentScreen: GameScreen
    @ObservedObject var viewModel: ViewModelJumpex

    var body: some View {
        VStack(spacing: 30) {
            Spacer()

            Text("SELECCIONA NIVEL")
                .font(.system(size: 32, weight: .bold))
                .foregroundColor(.white)
                .shadow(radius: 5)

            Spacer()

            LevelButton(
                title: "PRINCIPIANTE",
                subtitle: "Dificultad Baja",
                isSelected: viewModel.currentLevel == 1,
                action: {
                    viewModel.currentLevel = 1
                    withAnimation(.easeInOut(duration: 0.5)) {
                        currentScreen = .gameplay
                    }
                }
            )

            LevelButton(
                title: "INTERMEDIO",
                subtitle: "Dificultad Alta",
                isSelected: viewModel.currentLevel == 2,
                action: {
                    viewModel.currentLevel = 2
                    withAnimation(.easeInOut(duration: 0.5)) {
                        currentScreen = .gameplay
                    }
                }
            )

            Spacer()

            Button(action: {
                withAnimation(.easeInOut(duration: 0.5)) {
                    currentScreen = .welcome
                }
            }) {
                Text("VOLVER")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .background(Color.gray.opacity(0.7))
                    .cornerRadius(10)
            }
            .padding(.horizontal, 40)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct LevelButton: View {
    let title: String
    let subtitle: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: 10) {
                Text(title)
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.white)

                Text(subtitle)
                    .font(.system(size: 14, weight: .regular))
                    .foregroundColor(.white.opacity(0.8))
            }
            .frame(maxWidth: .infinity)
            .frame(height: 100)
            .background(
                RoundedRectangle(cornerRadius: 15)
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: [
                                Color(red: 0.2, green: 0.4, blue: 0.8),
                                Color(red: 0.1, green: 0.3, blue: 0.7)
                            ]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
            )
            .overlay(
                RoundedRectangle(cornerRadius: 15)
                    .stroke(isSelected ? Color.yellow : Color.clear, lineWidth: 3)
            )
        }
        .padding(.horizontal, 40)
    }
}
