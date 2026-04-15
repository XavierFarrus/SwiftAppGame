import SwiftUI

struct ContentView: View {
    
    @EnvironmentObject var viewModel: ViewModel
    
    var body: some View {
        if viewModel.showStartScreen {
            StartView()
        } else {
            GameView()
        }
    }
}


