import Foundation
import SwiftUI


class Player: Sprite{
    
    //Velocidad
    func move(){
        self.center.y+=1 // + Velocidad
    }
    func moveToPoint(_ point:CGPoint){
        withAnimation{
            self.center =  point
        }
    }
}
