import Foundation
import SwiftUI

class Obstacle: Sprite, Identifiable {
    
    let id = UUID()
    var speed: CGFloat
    var color: Color
    
    override init(center: CGPoint, width: CGFloat, height: CGFloat) {
        self.speed = 4
        self.color = .red
        super.init(center: center, width: width, height: height)
    }
    
    func moveLeft() {
        self.center.x -= speed
    }
}