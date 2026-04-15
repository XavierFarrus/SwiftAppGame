import Foundation
import SwiftUI

class Player: Sprite {
    
    var velocityY: CGFloat = 0
    var scale: CGFloat = 1.0
    var opacity: Double = 1.0
    
    func moveY(to newY: CGFloat) {
        withAnimation(.easeInOut(duration: 0.08)) {
            self.center.y = newY
        }
    }
}