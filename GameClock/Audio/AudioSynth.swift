////
////  AudioSynth.swift
////  GameClock
////
////  Created by Christian Rodriguez on 8/19/23.
////
//
//import AVKit
//import Foundation
//import SwiftUI
//import AVFoundation
//
//
//public class WWDCSynthAudioUnit: AVSpeechSynthesisProviderAudioUnit {
//    public override var speechVoices: [AVSpeechSynthesisProviderVoice] {
//        get {
//            let voices: [String : String] = groupDefaults.value(forKey: "voices") as? [String : String] ?? [:]
//            return voices.map { key, value in
//                return AVSpeechSynthesisProviderVoice(name: value,
//                                                identifier: key,
//                                          primaryLanguages: ["en-US"],
//                                        supportedLanguages: ["en-US"] )
//            }
//        }
//    }
//}
//
//public class WWDCSynthAudioUnit: AVSpeechSynthesisProviderAudioUnit {
//    public override func synthesizeSpeechRequest(speechRequest: AVSpeechSynthesisProviderRequest) {
//        currentBuffer = getAudioBuffer(for: speechRequest.voice, with: speechRequest.ssmlRepresentation)
//        framePosition = 0
//    }
//
//    public override func cancelSpeechRequest() {
//        currentBuffer = nil
//    }
//}
//
//public class WWDCSynthAudioUnit: AVSpeechSynthesisProviderAudioUnit {
//    public override var internalRenderBlock: AUInternalRenderBlock {
//       return { [weak self]
//           actionFlags, timestamp, frameCount, outputBusNumber, outputAudioBufferList, _, _ in
//           guard let self else { return kAudio_ParamError }
//
//           // This is the audio buffer we are going to fill up
//           var unsafeBuffer = UnsafeMutableAudioBufferListPointer(outputAudioBufferList)[0]
//           let frames = unsafeBuffer.mData!.assumingMemoryBound(to: Float32.self)
//                
//           var sourceBuffer = UnsafeMutableAudioBufferListPointer(self.currentBuffer!.mutableAudioBufferList)[0]
//           let sourceFrames = sourceBuffer.mData!.assumingMemoryBound(to: Float32.self)
//
//           for frame in 0..<frameCount {
//               if frames.count > frame && sourceFrames.count > self.framePosition {
//                   frames[Int(frame)] = sourceFrames[Int(self.framePosition)]
//                   self.framePosition += 1
//                   if self.framePosition >= self.currentBuffer!.frameLength {
//                       break
//                   }
//               }
//           }
//                
//           return noErr
//       }
//    }
//}
