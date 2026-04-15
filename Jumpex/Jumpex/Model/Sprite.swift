import Foundation
import SwiftUI

class Sprite {
    
    var center: CGPoint
    var width: CGFloat
    var height: CGFloat
    
    var frame: CGRect {
        CGRect(
            x: center.x - width / 2,
            y: center.y - height / 2,
            width: width,
            height: height
        )
    }
    
    init(center: CGPoint, width: CGFloat, height: CGFloat) {
        self.center = center
        self.width = width
        self.height = height
    }
    
    func checkCollisionWith(_ frame: CGRect) -> Bool {
        self.frame.intersects(frame)
    }
}