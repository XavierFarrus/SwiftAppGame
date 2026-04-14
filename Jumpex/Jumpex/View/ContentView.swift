import SwiftUI

struct ContentView: View {
    @EnvironmentObject var viewModel: ViewModel
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Color.black
                    .edgesIgnoringSafeArea(.all)

                if let player = viewModel.player {
                    Capsule()
                        .fill(Color.red)
                        //.fill(Color("ColorPlayer"))
                        .frame(width: player.width, height: player.height)
                        .position(player.center)
                }
            }
            .onAppear {
                viewModel.setUpPlayer(size: geometry.size)
            }
           
        } .onTapGesture(){
            viewModel.movePlayer()
        }
    }
}
        

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environmentObject(ViewModel())
    }
}
