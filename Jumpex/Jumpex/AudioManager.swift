import Foundation
import AVFoundation
import AudioToolbox

class AudioManager: ObservableObject {
    
    private var hitSoundID: SystemSoundID = 0
    private var gameOverSoundID: SystemSoundID = 0
    private var audioPlayer: AVAudioPlayer?
    
    @Published var isMusicOn: Bool = true
    
    init() {
        setUpHitSound()
        setUpGameOverSound()
        setUpBackgroundMusic()
    }
    
    private func setUpHitSound() {
        if let soundURL: CFURL = Bundle.main.url(forResource: "hit", withExtension: "wav") as CFURL? {
            AudioServicesCreateSystemSoundID(soundURL, &hitSoundID)
        }
    }
    
    private func setUpGameOverSound() {
        if let soundURL: CFURL = Bundle.main.url(forResource: "gameover", withExtension: "wav") as CFURL? {
            AudioServicesCreateSystemSoundID(soundURL, &gameOverSoundID)
        }
    }
    
    func playHitSound() {
        AudioServicesPlaySystemSound(hitSoundID)
    }
    
    func playGameOverSound() {
        AudioServicesPlaySystemSound(gameOverSoundID)
    }
    
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