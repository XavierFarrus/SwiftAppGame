import Foundation
import AVFoundation
import AudioToolbox

class AudioManager: ObservableObject {
    
    // Sonido corto de colisión
    private var hitSoundID: SystemSoundID = 0
    
    // Música de fondo
    private var audioPlayer: AVAudioPlayer?

    // Sonido de Game Over
    private var gameOverSoundID: SystemSoundID = 0
    
    // Estado para saber si la música está activa
    @Published var isMusicOn: Bool = true
    
    init() {
        setUpHitSound()
        setUpGameOverSound()   
        setUpBackgroundMusic()
    }
    
    // MARK: - System Sound Services
    
    private func setUpHitSound() {
        if let soundURL: CFURL = Bundle.main.url(forResource: "hit", withExtension: "wav") as CFURL? {
            AudioServicesCreateSystemSoundID(soundURL, &hitSoundID)
        }
    }
    
    func playHitSound() {
        AudioServicesPlaySystemSound(hitSoundID)
    }
    
    func playGameOverSound() {
        AudioServicesPlaySystemSound(gameOverSoundID)
    }
    

    private func setUpGameOverSound() {
        if let soundURL: CFURL = Bundle.main.url(forResource: "gameover", withExtension: "wav") as CFURL? {
            AudioServicesCreateSystemSoundID(soundURL, &gameOverSoundID)
        }
    }
}
    
    // MARK: - AVAudioPlayer
    
    private func setUpBackgroundMusic() {
        if let soundURL = Bundle.main.url(forResource: "background_music", withExtension: "mp3") {
            do {
                audioPlayer = try AVAudioPlayer(contentsOf: soundURL)
                audioPlayer?.prepareToPlay()
                audioPlayer?.numberOfLoops = -1
            } catch {
                print("Error al cargar la música de fondo")
            }
        }
    }
    
    func playBackgroundMusic() {
        if isMusicOn {
            audioPlayer?.play()
        }
    }
 
    func pauseBackgroundMusic() {
        audioPlayer?.pause()
    }
    
    func stopBackgroundMusic() {
        audioPlayer?.stop()
    }
    
    func toggleMusic() {
        isMusicOn.toggle()
        
        if isMusicOn {
            audioPlayer?.play()
        } else {
            audioPlayer?.pause()
        }
    }
}