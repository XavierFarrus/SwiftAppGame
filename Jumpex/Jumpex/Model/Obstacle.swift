import Foundation
import SwiftUI

/// Clase Obstacle que hereda de Sprite
/// Representa un obstáculo que se mueve en la pantalla en uno de los tres carriles
class Obstacle: Sprite {
    
    /// Carril en el que se encuentra el obstáculo (0, 1, 2)
    var lane: Int
    
    /// Constructor que asigna un carril aleatorio al obstáculo
    /// - Parameters:
    ///   - screenWidth: ancho de la pantalla
    ///   - width: ancho del obstáculo
    ///   - height: alto del obstáculo
    init(screenWidth: CGFloat, width: CGFloat, height: CGFloat) {
        // Asignar carril aleatoriamente (0, 1, 2)
        self.lane = Int.random(in: 0...2)
        
        let laneWidth = screenWidth / 3
        let centerX: CGFloat
        
        // Determinar el center en X basado en el carril
        switch self.lane {
        case 0:
            centerX = laneWidth / 2
        case 1:
            centerX = screenWidth / 2
        case 2:
            centerX = laneWidth * 2.5
        default:
            centerX = screenWidth / 2
        }
        
        let centerY = UIScreen.main.bounds.minY - 50
        let center = CGPoint(x: centerX, y: centerY)
        
        super.init(center: center, width: width, height: height)
    }
    
    /// Mueve el obstáculo hacia abajo en la pantalla
    func moveDown(speed: CGFloat = 5) {
        self.center.y += speed
    }
    
    /// Verifica si el obstáculo ha salido de la pantalla inferior
    func isOffScreen() -> Bool {
        return self.center.y > UIScreen.main.bounds.maxY + 50
    }
} 
