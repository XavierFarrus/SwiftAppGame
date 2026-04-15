import SwiftUI

struct StartView: View {
    
    @EnvironmentObject var viewModel: ViewModel
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Color.black
                    .edgesIgnoringSafeArea(.all)
                
                VStack {
                    HStack {
                        Spacer()
                        
                        Button(action: {
                            viewModel.toggleMusic()
                        }) {
                            Image(systemName: viewModel.audioManager.isMusicOn ? "speaker.wave.2.fill" : "speaker.slash.fill")
                                .font(.title)
                                .foregroundColor(.white)
                                .padding()
                        }
                    }
                    
                    Spacer()
                }
                
                VStack(spacing: 25) {
                    
                    Image("AppIconImage")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 120, height: 120)
                        .cornerRadius(20)
                    
                    Text("Jumpex")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    
                    Button(action: {
                        viewModel.startGame(size: geometry.size)
                    }) {
                        Text("Start")
                            .font(.title2)
                            .fontWeight(.semibold)
                            .foregroundColor(.black)
                            .padding(.horizontal, 35)
                            .padding(.vertical, 14)
                            .background(Color.yellow)
                            .cornerRadius(12)
                    }
                }
                .padding(30)
                .background(Color.gray.opacity(0.25))
                .cornerRadius(20)
            }
            .onAppear {
                viewModel.startMenuMusic()
            }
        }
    }
}

struct StartView_Previews: PreviewProvider {
    static var previews: some View {
        StartView()
            .environmentObject(ViewModel())
            .previewInterfaceOrientation(.landscapeLeft)
    }
}