//
//  AudioManager.swift
//  GameClock
//
//  Created by Christian Rodriguez on 5/25/23.
//

import AVKit
import Foundation
import SwiftUI
import AVFoundation

class AudioManager: NSObject, ObservableObject, AVAudioPlayerDelegate {

    @Published var isPlaying: Bool = false {
        willSet {
            if newValue == true {
//                playAudio()
                try! AVAudioSession.sharedInstance().setActive(true, options: .notifyOthersOnDeactivation)
            }
            if newValue == false {
                //pause
                try! AVAudioSession.sharedInstance().setActive(false, options: .notifyOthersOnDeactivation)

            }
        }
    }

    var myAudioPlayer = AVAudioPlayer()
    var fileName = ""

    override init() {
        super.init()
        try! AVAudioSession.sharedInstance().setCategory(
            AVAudioSession.Category.playback,
            mode: AVAudioSession.Mode.default,
            options: [
                AVAudioSession.CategoryOptions.duckOthers
            ]
        )
    }

    func playAudio(soundName: String, fileType: String) {
        try! AVAudioSession.sharedInstance().setCategory(
            AVAudioSession.Category.playback,
            mode: AVAudioSession.Mode.default,
            options: [
                AVAudioSession.CategoryOptions.duckOthers
            ]
        )
        try! AVAudioSession.sharedInstance().setActive(true)
        let path = Bundle.main.path(forResource: soundName, ofType:fileType)
        let url = URL(fileURLWithPath: path ?? "empty.mp3")

        do {
            myAudioPlayer = try AVAudioPlayer(contentsOf: url)
            myAudioPlayer.delegate = self
            myAudioPlayer.play()
        } catch {
            // couldn't load file :(
        }
    }
    func playSilentAudio(soundName: String) {
        try! AVAudioSession.sharedInstance().setCategory(
            AVAudioSession.Category.playback,
            mode: AVAudioSession.Mode.default,
            options: [
                AVAudioSession.CategoryOptions.mixWithOthers
            ]
        )
        try! AVAudioSession.sharedInstance().setActive(true)
        let path = Bundle.main.path(forResource: soundName, ofType:"mp3")!
        let url = URL(fileURLWithPath: path)

        do {
            myAudioPlayer = try AVAudioPlayer(contentsOf: url)
            myAudioPlayer.delegate = self
            myAudioPlayer.play()
        } catch {
            // couldn't load file :(
        }
    }

    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        isPlaying = false
    }

}
//class AudioManager: ObservableObject {
//    @Published var audioPlayer : AVAudioPlayer!
//
//    func loadAudio(soundName: String){
//        print("loading audio")
//        let sound = Bundle.main.path(forResource: soundName, ofType: "mp3")
//        self.audioPlayer = try! AVAudioPlayer(contentsOf: URL(fileURLWithPath: sound!))
//    }
//    func playAudio(){
//        print("playing audio")
//        self.audioPlayer.play()
//    }
//    func stopAudio(){
//        print("stopping audio")
//        self.audioPlayer.stop()
//    }
//}
