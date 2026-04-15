import SwiftUI

struct GameView: View {
    
    @EnvironmentObject var viewModel: ViewModel
    
    @State private var playerHit = false
    @State private var obstacleHit = false
    
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
                        .scaleEffect(obstacleHit ? 0.2 : 1.0)
                        .opacity(obstacleHit ? 0.0 : 1.0)
                        .position(obstacle.center)
                        .animation(Animation.easeInOut(duration: 0.20))
                }
                
                // Player
                if let player = viewModel.player {
                    Circle()
                        .fill(Color.blue)
                        .frame(width: player.width, height: player.height)
                        .scaleEffect(playerHit ? 1.15 : 1.0)
                        .opacity(playerHit ? 0.6 : 1.0)
                        .position(player.center)
                        .shadow(color: Color.blue.opacity(0.5), radius: 8)
                        .animation(Animation.easeInOut(duration: 0.20))
                }
                
                // HUD
                VStack {
                    HStack(spacing: 20) {
                        Text("Tiempo: \(viewModel.timeSurvived)")
                        Text("Vidas: \(viewModel.lives)")
                        Text("Nivel: \(viewModel.levelText)")
                        Text("Puntos: \(viewModel.score)")
                        
                        Button(action: {
                            viewModel.toggleMusic()
                        }) {
                            Image(systemName: viewModel.audioManager.isMusicOn ? "speaker.wave.2.fill" : "speaker.slash.fill")
                                .foregroundColor(.white)
                                .font(.title2)
                        }
                    }
                    .foregroundColor(.white)
                    .padding(.top, 10)
                    
                    Spacer()
                }
            }
            .contentShape(Rectangle())
            .onTapGesture {
                viewModel.playerJump()
                
                withAnimation(Animation.easeInOut(duration: 0.10)) {
                    playerHit = false
                    obstacleHit = false
                }
            }
            .onAppear {
                viewModel.setUpGame(size: geometry.size)
                
                viewModel.onHit = {
                    withAnimation(Animation.easeInOut(duration: 0.20)) {
                        playerHit = true
                        obstacleHit = true
                    }
                }
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
                    secondaryButton: .destructive(Text("Salir")) {
                        viewModel.goToStart()
                    }
                )
            }
        }
    }
}