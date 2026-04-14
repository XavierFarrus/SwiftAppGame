import SwiftUI
import UIKit

class ViewModelJumpex: ObservableObject {
    
    @Published var player: Player?
    @Published var obstacles: [Obstacle] = []
    @Published var score: Int = 0
    @Published var gameOver: Bool = false
    @Published var currentLevel: Int = 1 // 1: Beginner, 2: Intermediate
    @Published var elapsedTime: TimeInterval = 0
    @Published var screenSize: CGSize = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
    
    private var displayLink: CADisplayLink?
    private var lastTimestamp: CFTimeInterval = 0
    private var spawnAccumulator: TimeInterval = 0
    private var passedObstacles: Set<Int> = []
    
    // Parámetros del juego según tiempo transcurrido
    private var obstacleSpeedMultiplier: CGFloat {
        return elapsedTime < 60 ? 1.0 : 1.6
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
        elapsedTime = 0
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
        spawnAccumulator = 0
        elapsedTime = 0
    }
    
    @objc private func gameLoop() {
        guard !gameOver else { return }
        guard let displayLink = displayLink else { return }

        let timestamp = displayLink.timestamp
        let delta: CFTimeInterval
        if lastTimestamp == 0 {
            delta = 1.0 / 60.0
        } else {
            delta = timestamp - lastTimestamp
        }
        lastTimestamp = timestamp

        // Actualizar tiempo de juego
        elapsedTime += delta

        // Actualizar obstáculos con velocidad dependiente del tiempo
        updateObstacles(delta: delta)

        // Verificar colisiones
        checkCollisions()

        // Generar nuevos obstáculos según el tiempo transcurrido
        updateObstacleSpawning(delta: delta)

        // Aplicar gravedad al player
        player?.moveDown()

        DispatchQueue.main.async {
            self.objectWillChange.send()
        }
    }
    
    private func updateObstacles(delta: CFTimeInterval) {
        // velocidad base en puntos por frame aproximado; aumenta después de 60s
        let baseSpeed: CGFloat = elapsedTime < 60 ? 3.0 : 6.0
        let speed = baseSpeed * obstacleSpeedMultiplier

        for obstacle in obstacles {
            obstacle.moveDown(speed: speed * CGFloat(delta * 60))
        }

        // Remover obstáculos que salieron de pantalla
        obstacles.removeAll { $0.isOffScreen() }
    }
    
    private func updateObstacleSpawning(delta: CFTimeInterval) {
        // Ajustar frecuencia según tiempo de juego: menos frecuentes el primer minuto
        let spawnInterval: TimeInterval = elapsedTime < 60 ? 1.5 : 0.8

        spawnAccumulator += delta

        if spawnAccumulator >= spawnInterval {
            let newObstacle = Obstacle(screenWidth: screenSize.width, width: 40, height: 40)
            obstacles.append(newObstacle)
            spawnAccumulator = 0
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
