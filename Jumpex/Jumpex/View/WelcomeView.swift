import SwiftUI

struct WelcomeView: View {
    @Binding var currentScreen: GameScreen

    var body: some View {
        VStack(spacing: 40) {
            Spacer()

            VStack(spacing: 20) {
                Image(systemName: "figure.jump.rope")
                    .font(.system(size: 80))
                    .foregroundColor(.white)

                Text("JUMPEX")
                    .font(.system(size: 56, weight: .bold, design: .default))
                    .foregroundColor(.white)
                    .shadow(radius: 5)
            }

            Spacer()

            Button(action: {
                withAnimation(.easeInOut(duration: 0.5)) {
                    currentScreen = .levelSelection
                }
            }) {
                Text("EMPEZAR")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 60)
                    .background(
                        LinearGradient(
                            gradient: Gradient(colors: [
                                Color(red: 0.9, green: 0.6, blue: 0.1),
                                Color(red: 0.8, green: 0.5, blue: 0.0)
                            ]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .cornerRadius(15)
                    .shadow(radius: 5)
            }
            .padding(.horizontal, 40)

            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
