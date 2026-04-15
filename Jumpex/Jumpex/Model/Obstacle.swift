import Foundation
import SwiftUI

class Obstacle: Sprite, Identifiable {
    
    let id = UUID()
    var speed: CGFloat
    var color: Color
    
    // Propiedades para animación
    var scale: CGFloat = 1.0
    var opacity: Double = 1.0
    
    override init(center: CGPoint, width: CGFloat, height: CGFloat) {
        self.speed = 4
        self.color = Color.red
        super.init(center: center, width: width, height: height)
    }
    
    func moveLeft() {
        self.center.x -= speed
    }
}