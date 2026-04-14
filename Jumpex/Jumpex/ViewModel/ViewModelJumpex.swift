import SwiftUI
import UIKit

class ViewModelJumpex: ObservableObject {
    
    @Published var player: Player?
    @Published var obstacles: [Obstacle] = []
    @Published var score: Int = 0
    @Published var gameOver: Bool = false
    @Published var currentLevel: Int = 1 // 1: Beginner, 2: Intermediate
    @Published var screenSize: CGSize = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
    
    private var displayLink: CADisplayLink?
    private var lastTimestamp: CFTimeInterval = 0
    private var accumulatedTime: TimeInterval = 0
    private let obstacleSpawnInterval: TimeInterval = 1.5
    private var passedObstacles: Set<Int> = []
    
    // Parámetros del juego según nivel
    private var obstacleSpeedMultiplier: CGFloat {
        return currentLevel == 1 ? 1.0 : 1.5
    }
    
    func setUpPlayer(size: CGSize) {
        screenSize = size
        let playerWidth: CGFloat = 40
        let playerHeight: CGFloat = 40
        let center = CGPoint(x: size.width / 2, y: size.height - 100)
        self.player = Player(center: center, width: playerWidth, height: playerHeight)
        self.score = 0
        self.gameOver = false
        self.obstacles = []
        self.passedObstacles = []
        startGameLoop()
    }
    
    private func startGameLoop() {
        guard displayLink == nil else { return }
        displayLink = CADisplayLink(target: self, selector: #selector(gameLoop))
        displayLink?.add(to: .main, forMode: .common)
    }
    
    func stopGameLoop() {
        displayLink?.invalidate()
        displayLink = nil
        lastTimestamp = 0
        accumulatedTime = 0
    }
    
    @objc private func gameLoop() {
        guard !gameOver else { return }
        
        // Actualizar obstáculos
        updateObstacles()
        
        // Verificar colisiones
        checkCollisions()
        
        // Generar nuevos obstáculos
        updateObstacleSpawning()
        
        // Aplicar gravedad al player
        player?.moveDown()
        
        DispatchQueue.main.async {
            self.objectWillChange.send()
        }
    }
    
    private func updateObstacles() {
        for obstacle in obstacles {
            obstacle.moveDown(speed: 5 * obstacleSpeedMultiplier)
        }
        
        // Remover obstáculos que salieron de pantalla
        obstacles.removeAll { $0.isOffScreen() }
    }
    
    private func updateObstacleSpawning() {
        accumulatedTime += 0.016 // ~60 FPS
        
        if accumulatedTime >= obstacleSpawnInterval {
            let newObstacle = Obstacle(screenWidth: screenSize.width, width: 40, height: 40)
            obstacles.append(newObstacle)
            accumulatedTime = 0
        }
    }
    
    private func checkCollisions() {
        guard let player = player else { return }
        
        for (index, obstacle) in obstacles.enumerated() {
            // Verificar si el jugador colidió con el obstáculo
            if player.checkCollisionWith(obstacle.frame) {
                // Sonido de colisión
                playCollisionSound()
                gameOver = true
                stopGameLoop()
                return
            }
            
            // Verificar si el jugador esquivó el obstáculo
            if obstacle.center.y > player.center.y && !passedObstacles.contains(index) {
                passedObstacles.insert(index)
                score += 1
                playSuccessSound()
            }
        }
    }
    
    /// Mueve el player al carril especificado (0, 1, 2)
    func movePlayerToLane(_ lane: Int) {
        player?.moveToLane(lane, screenWidth: screenSize.width)
    }
    
    /// Reinicia el juego
    func restartGame() {
        stopGameLoop()
        obstacles = []
        passedObstacles = []
        gameOver = false
        setUpPlayer(size: screenSize)
    }
    
    // MARK: - Sound Management
    private func playCollisionSound() {
        // TODO: Placeholder - Poner sonido de colisión aquí
        print("🔊 Sonido de colisión")
    }
    
    private func playSuccessSound() {
        // TODO: Placeholder - Poner sonido de éxito (obstáculo esquivado) aquí
        print("🔊 Sonido de obstáculo esquivado")
    }
}

    func movePlayer(){
        print("move player")
        player?.moveUp()
        objectWillChange.send()
        
    }
  

    func restartGame(size: CGSize) {
        // Reiniciar player a la posición inicial
        let playerWidth: CGFloat = 110
        let playerHeight: CGFloat = 10
        let center = CGPoint(x: size.width/2, y: size.height - playerHeight/2 - 20)
        self.player = Player(center: center, width: playerWidth, height: playerHeight)
        // Reiniciar el bucle de juego
        startGameLoop()
    }

    deinit {
        stopGameLoop()
    }
}
