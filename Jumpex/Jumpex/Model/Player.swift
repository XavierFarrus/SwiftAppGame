import Foundation
import SwiftUI


class Player: Sprite{
    
    //Velocidad
    func moveDown(){
        withAnimation{
            self.center.y+=1 // + Velocidad
        }
    }
    func moveUp(){
        withAnimation{
            self.center.y-=10
        }
    }
}
