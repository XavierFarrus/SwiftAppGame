import SwiftUI
import UIKit

class ViewModel: ObservableObject {
    
    @Published var player: Player?
    @Published var obstacles: [Obstacle] = []
    @Published var isGameOver: Bool = false
    @Published var lives: Int = 3
    @Published var timeSurvived: Int = 0
    @Published var score: Int = 0
    @Published var levelText: String = "Fácil"
    @Published var showStartScreen: Bool = true
    
    let audioManager = AudioManager()
    
    private var displayLink: CADisplayLink?
    private var lastTimestamp: CFTimeInterval = 0
    private var accumulatedSpawnTime: TimeInterval = 0
    private var accumulatedGameTime: TimeInterval = 0
    
    private var gameWidth: CGFloat = 0
    private var gameHeight: CGFloat = 0
    
    private var spawnInterval: TimeInterval = 1.2
    
    var onHit: (() -> Void)?
    var onResetHit: (() -> Void)?
    
    func setUpGame(size: CGSize) {
        gameWidth = size.width
        gameHeight = size.height
        
        let playerSize: CGFloat = 45
        let playerX: CGFloat = 80
        let playerY: CGFloat = size.height / 2
        
        player = Player(
            center: CGPoint(x: playerX, y: playerY),
            width: playerSize,
            height: playerSize
        )
    }
    
    func startGame(size: CGSize) {
        restartGame(size: size)
        showStartScreen = false
        audioManager.playBackgroundMusic()
        startGameLoop()
    }
    
    func startMenuMusic() {
        audioManager.playBackgroundMusic()
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
    }
    
    func playerJump() {
        guard let player = player, !isGameOver, !showStartScreen else { return }
        player.velocityY = -8
        objectWillChange.send()
    }
    
    @objc private func gameLoop(link: CADisplayLink) {
        if lastTimestamp == 0 {
            lastTimestamp = link.timestamp
            return
        }
        
        let delta = link.timestamp - lastTimestamp
        lastTimestamp = link.timestamp
        
        updateLevel()
        updatePlayer()
        updateObstacles()
        checkCollisions()
        
        accumulatedSpawnTime += delta
        accumulatedGameTime += delta
        
        if accumulatedSpawnTime >= spawnInterval {
            accumulatedSpawnTime = 0
            spawnObstacle()
        }
        
        if accumulatedGameTime >= 1 {
            accumulatedGameTime = 0
            timeSurvived += 1
            score += 10
        }
        
        onResetHit?()
        
        objectWillChange.send()
        
    }
    
    private func updateLevel() {
        if timeSurvived >= 30 {
            levelText = "Difícil"
            spawnInterval = 0.7
        } else {
            levelText = "Fácil"
            spawnInterval = 1.2
        }
    }
    
    private func updatePlayer() {
        guard let player = player else { return }
        
        player.velocityY += 0.35
        var newY = player.center.y + player.velocityY
        
        let minY = player.height / 2
        let maxY = gameHeight - player.height / 2
        
        if newY < minY {
            newY = minY
            player.velocityY = 0
        }
        
        if newY > maxY {
            newY = maxY
            player.velocityY = 0
        }
        
        player.moveY(to: newY)
    }
    
    private func updateObstacles() {
        for obstacle in obstacles {
            obstacle.moveLeft()
        }
        
        obstacles.removeAll { $0.center.x < -50 }
    }
    
    private func spawnObstacle() {
        let laneHeight = gameHeight / 3
        
        let randomLane = Int.random(in: 0...2)
        let laneCenterY = laneHeight * CGFloat(randomLane) + laneHeight / 2
        
        let obstacle = Obstacle(
            center: CGPoint(x: gameWidth + 30, y: laneCenterY),
            width: 40,
            height: 40
        )
        
        if levelText == "Difícil" {
            obstacle.speed = 6
        } else {
            obstacle.speed = 4
        }
        
        obstacles.append(obstacle)
    }
    
    private func checkCollisions() {
        guard let player = player else { return }
        
        if let index = obstacles.firstIndex(where: { $0.checkCollisionWith(player.frame) }) {
            lives -= 1
            
            audioManager.playHitSound()
            onHit?()
            obstacles.remove(at: index)
            
            if lives <= 0 {
                isGameOver = true
                audioManager.playGameOverSound()
                stopGameLoop()
            }
        }
    }
    
    func restartGame(size: CGSize) {
        stopGameLoop()
        
        obstacles.removeAll()
        isGameOver = false
        lives = 3
        timeSurvived = 0
        score = 0
        levelText = "Fácil"
        spawnInterval = 1.2
        accumulatedSpawnTime = 0
        accumulatedGameTime = 0
        
        setUpGame(size: size)
    }
    
    func goToStart() {
        stopGameLoop()
        showStartScreen = true
        audioManager.playBackgroundMusic()
    }
    
    func toggleMusic() {
        audioManager.toggleMusic()
        objectWillChange.send()
    }
    
    deinit {
        stopGameLoop()
    }
}