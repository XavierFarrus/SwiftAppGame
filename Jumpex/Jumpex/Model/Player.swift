import Foundation
import SwiftUI

class Player: Sprite{
    
    // Límites de pantalla
    private let screenMinY = UIScreen.main.bounds.minY + 50
    private let screenMaxY = UIScreen.main.bounds.maxY - 50
    
    //Velocidad
    func moveDown(){
        // El player no baja más de la pantalla
        let newY = min(self.center.y + 1, screenMaxY)
        self.center.y = newY
    }
    
    func moveUp(){
        withAnimation(.easeInOut(duration: 0.3)){
            self.center.y -= 10
        }
    }
    
    /// Mueve el player hacia el carril especificado (0, 1, 2)
    func moveToLane(_ lane: Int, screenWidth: CGFloat) {
        let laneWidth = screenWidth / 3
        let newX: CGFloat
        
        switch lane {
        case 0:
            newX = laneWidth / 2
        case 1:
            newX = screenWidth / 2
        case 2:
            newX = laneWidth * 2.5
        default:
            newX = self.center.x
        }
        
        withAnimation(.easeInOut(duration: 0.2)) {
            self.center.x = newX
        }
    }
}
