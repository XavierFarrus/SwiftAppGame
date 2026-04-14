//
//  Obstacle.swift
//  Jumpex
//
//  Created by alumne on 13/04/2026.
//

import Foundation
import SwiftUI

class Obstacle: Sprite {
    
    var carril: Int // 0, 1 o 2
    
    init(carril: Int? = nil, screenWidth: CGFloat) {
        // Si no se especifica carril, asignarlo aleatoriamente
        self.carril = carril ?? Int.random(in: 0...2)
        
        // Calcular el center.x según el carril
        // Dividimos la pantalla en 3 carriles iguales
        let carrileWidth = screenWidth / 3
        let centerX = (CGFloat(self.carril) * carrileWidth) + (carrileWidth / 2)
        
        // El obstáculo aparecerá en la parte superior de la pantalla
        let centerY = -20 // Un poco por encima de la pantalla
        
        let center = CGPoint(x: centerX, y: centerY)
        let width: CGFloat = 40
        let height: CGFloat = 40
        
        super.init(center: center, width: width, height: height)
    }
    
    func move() {
        // Mover el obstáculo hacia la izquierda en el eje X
        self.center.x -= 1
        // También bajar hacia abajo
        self.center.y += 2
    }
} 
