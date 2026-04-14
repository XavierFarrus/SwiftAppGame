import SwiftUI
import UIKit

class ViewModel:ObservableObject{

    @Published var player: Player?

    private var displayLink: CADisplayLink?
    private var lastTimestamp: CFTimeInterval = 0
    private var accumulatedTime: TimeInterval = 0
    private let obstacleSpawnInterval: TimeInterval = 10

    func setUpPlayer(size: CGSize){
       
        let playerWidth: CGFloat = 40
        let playerHeight: CGFloat = 40
        let center = CGPoint(x:size.width/10 ,y:size.height/2)
        self.player = Player(center: center, width: playerWidth, height: playerHeight)
       startGameLoop()
    }

   /* func updatePlayerX(to locationX: CGFloat, in size: CGSize){
        guard let player = player else { return }
        let halfWidth = player.width/2
        let minX = halfWidth
        let maxX = size.width - halfWidth
        let clampedX = min(max(locationX, minX), maxX)
        player.center = CGPoint(x: clampedX, y: player.center.y)
        objectWillChange.send()
    }*/

    private func startGameLoop(){
        guard displayLink == nil else { return }
        displayLink = CADisplayLink(target: self, selector: #selector(gameLoop))
        displayLink?.add(to: .main, forMode: .common)
    }

    func stopGameLoop(){
        displayLink?.invalidate()
        displayLink = nil
        lastTimestamp = 0
        accumulatedTime = 0
    }

    @objc private func gameLoop(){
        
        player?.moveDown()
        objectWillChange.send()
        
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
