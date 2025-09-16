//
//  SoundService.swift
//  PlantID
//
//  Created by Вадим Игнатенко on 16.09.25.
//

import AVFoundation

final class SoundService {
    
    static let shared = SoundService()
    private var player: AVAudioPlayer?

    private init() {}
    
    private enum Songs: String, CaseIterable {
        case plantMusic1 = "plant_music_1"
        case plantMusic2 = "plant_music_2"
        case plantMusic3 = "plant_music_3"
        case plantMusic4 = "plant_music_4"
        case plantMusic5 = "plant_music_5"
        case plantMusic6 = "plant_music_6"
    }
    
    func playAndUpdateForIndex( index: Int) {
        let songs = Songs.allCases[index]
        
        play(file: songs.rawValue)
    }

    func play(file name: String, ext: String = "mp3") {
        guard let url = Bundle.main.url(forResource: name, withExtension: ext) else {
            print("❌ [SoundService] Файл \(name).\(ext) не найден")
            return
        }
        do {
            
            if isPlaying() == true {
                stop()
            }
            player = try AVAudioPlayer(contentsOf: url)
            player?.numberOfLoops = 0   // -1 если нужно зациклить
            player?.prepareToPlay()
            player?.play()
        } catch {
            print("❌ [SoundService] Ошибка воспроизведения:", error.localizedDescription)
        }
    }

    func stop() {
        player?.stop()
        player = nil
    }

    func isPlaying() -> Bool {
        return player?.isPlaying ?? false
    }
}

