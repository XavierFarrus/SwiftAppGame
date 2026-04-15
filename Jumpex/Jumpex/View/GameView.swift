import SwiftUI

struct GameView: View {
    
    @EnvironmentObject var viewModel: ViewModel
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                
                Color.black
                    .edgesIgnoringSafeArea(.all)
                
                // Carriles
                VStack(spacing: 0) {
                    Rectangle().stroke(Color.white.opacity(0.08), lineWidth: 1)
                    Rectangle().stroke(Color.white.opacity(0.08), lineWidth: 1)
                    Rectangle().stroke(Color.white.opacity(0.08), lineWidth: 1)
                }
                
                // Obstáculos
                ForEach(viewModel.obstacles) { obstacle in
                    Rectangle()
                        .fill(obstacle.color)
                        .frame(width: obstacle.width, height: obstacle.height)
                        .position(obstacle.center)
                }
                
                // Player
                if let player = viewModel.player {
                    Circle()
                        .fill(Color.blue)
                        .frame(width: player.width, height: player.height)
                        .position(player.center)
                        .shadow(color: .blue.opacity(0.5), radius: 8)
                }
                
                // HUD
                VStack {
                    HStack(spacing: 20) {
                        Text("Tiempo: \(viewModel.timeSurvived)")
                        Text("Vidas: \(viewModel.lives)")
                        Text("Nivel: \(viewModel.levelText)")
                        Text("Puntos: \(viewModel.score)")
                    }
                    .foregroundColor(.white)
                    .padding(.top, 10)
                    
                    Spacer()
                }
            }
            .contentShape(Rectangle())
            .onTapGesture {
                viewModel.playerJump()
            }
            .onAppear {
                viewModel.setUpGame(size: geometry.size)
            }
            .alert(isPresented: Binding(
                get: { viewModel.isGameOver },
                set: { viewModel.isGameOver = $0 })
            ) {
                Alert(
                    title: Text("Game Over"),
                    message: Text("Puntuación: \(viewModel.score)"),
                    primaryButton: .default(Text("Reiniciar")) {
                        viewModel.startGame(size: geometry.size)
                    },
                    secondaryButton: .cancel(Text("Salir"))
                )
            }
        }
    }
}

struct GameView_Previews: PreviewProvider {
    static var previews: some View {
        GameView()
            .environmentObject(ViewModel())
            .previewInterfaceOrientation(.landscapeLeft)
    }
}