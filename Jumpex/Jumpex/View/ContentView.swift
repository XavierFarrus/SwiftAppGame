import SwiftUI

struct ContentView: View {
    
    @StateObject private var viewModel = ViewModelJumpex()
    @State private var currentScreen: GameScreen = .welcome
    
    enum GameScreen {
        case welcome
        case levelSelection
        case gameplay
        case gameOver
    }
    
    var body: some View {
        ZStack {
            // Fondo degradado según el nivel
            LinearGradient(
                gradient: Gradient(colors: [
                    viewModel.currentLevel == 1 ? Color(red: 0.3, green: 0.7, blue: 0.9) : Color(red: 0.2, green: 0.5, blue: 0.8),
                    Color(red: 0.8, green: 0.9, blue: 1.0)
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            // Contenido según pantalla
            Group {
                switch currentScreen {
                case .welcome:
                    WelcomeView(currentScreen: $currentScreen)
                case .levelSelection:
                    LevelSelectionView(
                        currentScreen: $currentScreen,
                        viewModel: viewModel
                    )
                case .gameplay:
                    GamePlayView(
                        viewModel: viewModel,
                        currentScreen: $currentScreen
                    )
                case .gameOver:
                    GameOverView(
                        viewModel: viewModel,
                        currentScreen: $currentScreen
                    )
                }
            }
        }
    }
}

// MARK: - Welcome Screen
struct WelcomeView: View {
    @Binding var currentScreen: ContentView.GameScreen
    
    var body: some View {
        VStack(spacing: 40) {
            Spacer()
            
            // Título y Icono
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
            
            // Botón de inicio
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

// MARK: - Level Selection Screen
struct LevelSelectionView: View {
    @Binding var currentScreen: ContentView.GameScreen
    @ObservedObject var viewModel: ViewModelJumpex
    
    var body: some View {
        VStack(spacing: 30) {
            Spacer()
            
            Text("SELECCIONA NIVEL")
                .font(.system(size: 32, weight: .bold))
                .foregroundColor(.white)
                .shadow(radius: 5)
            
            Spacer()
            
            // Beginner Level
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
            
            // Intermediate Level
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
            
            // Botón volver
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

// MARK: - Gameplay Screen
struct GamePlayView: View {
    @ObservedObject var viewModel: ViewModelJumpex
    @Binding var currentScreen: ContentView.GameScreen
    
    var body: some View {
        ZStack {
            // Fondo del juego
            Color(red: 0.3, green: 0.7, blue: 0.9)
                .ignoresSafeArea()
            
            VStack(spacing: 10) {
                // Puntuación y nivel
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
                        
                        Text(viewModel.currentLevel == 1 ? "PRINCIPIANTE" : "INTERMEDIO")
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(.yellow)
                    }
                }
                .padding()
                .background(Color.black.opacity(0.3))
                .cornerRadius(10)
                .padding()
                
                Spacer()
                
                // Área de juego
                GeometryReader { geometry in
                    ZStack {
                        // Líneas de carriles
                        VStack(spacing: 0) {
                            Divider()
                                .frame(height: geometry.size.height / 3)
                            Divider()
                        }
                        .opacity(0.3)
                        
                        // Obstáculos
                        ForEach(viewModel.obstacles.indices, id: \.self) { index in
                            let obstacle = viewModel.obstacles[index]
                            Circle()
                                .fill(
                                    LinearGradient(
                                        gradient: Gradient(colors: [
                                            Color.red,
                                            Color(red: 0.8, green: 0, blue: 0)
                                        ]),
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .frame(width: obstacle.width, height: obstacle.height)
                                .position(x: obstacle.center.x, y: obstacle.center.y)
                                .shadow(radius: 3)
                        }
                        
                        // Player
                        if let player = viewModel.player {
                            Circle()
                                .fill(
                                    LinearGradient(
                                        gradient: Gradient(colors: [
                                            Color.green,
                                            Color(red: 0, green: 0.6, blue: 0)
                                        ]),
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
                
                // Controles de carriles
                HStack(spacing: 15) {
                    LaneControlButton(lane: 0, action: {
                        viewModel.movePlayerToLane(0)
                    })
                    
                    LaneControlButton(lane: 1, action: {
                        viewModel.movePlayerToLane(1)
                    })
                    
                    LaneControlButton(lane: 2, action: {
                        viewModel.movePlayerToLane(2)
                    })
                }
                .padding()
            }
            
            // Mostrar Game Over
            if viewModel.gameOver {
                GameOverOverlay(
                    score: viewModel.score,
                    currentScreen: $currentScreen,
                    viewModel: viewModel
                )
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

// MARK: - Game Over Screen
struct GameOverView: View {
    @ObservedObject var viewModel: ViewModelJumpex
    @Binding var currentScreen: ContentView.GameScreen
    
    var body: some View {
        VStack(spacing: 30) {
            Spacer()
            
            // Game Over
            VStack(spacing: 10) {
                Image(systemName: "xmark.circle.fill")
                    .font(.system(size: 80))
                    .foregroundColor(.red)
                
                Text("GAME OVER")
                    .font(.system(size: 40, weight: .bold))
                    .foregroundColor(.white)
            }
            
            Spacer()
            
            // Puntuación final
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
            
            // Botones
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
                                gradient: Gradient(colors: [
                                    Color.green,
                                    Color(red: 0, green: 0.6, blue: 0)
                                ]),
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
    @Binding var currentScreen: ContentView.GameScreen
    @ObservedObject var viewModel: ViewModelJumpex
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.4)
                .ignoresSafeArea()
            
            GameOverView(viewModel: viewModel, currentScreen: $currentScreen)
        }
    }
}

#Preview {
    ContentView()
}
