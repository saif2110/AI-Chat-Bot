//
//  PlaySound.swift
//  AI Chat Bot
//
//  Created by Admin on 04/09/23.
//

import Foundation
import AVFAudio
import AVFoundation

var player: AVAudioPlayer?


enum soundType:String {
    case receive = "RecivingSound"
    case send = "SendSound"
}

func playSound(type:soundType) {
    guard let url = Bundle.main.url(forResource: type.rawValue, withExtension: "mp3") else { return }
    do {
        try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
        try AVAudioSession.sharedInstance().setActive(true)
        player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)
        guard let player = player else { return }
        player.play()
    } catch let error {
        print(error.localizedDescription)
    }
}
