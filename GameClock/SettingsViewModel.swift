//
//  SettingsViewModel.swift
//  GameClock
//
//  Created by Christian Rodriguez on 12/27/23.
//

import SwiftUI


struct SessionConfig: Codable, Hashable {
    
    var sessionLength : Int
    var gameLength : Int
    var transitionLength : Int
    
}

class SettingsViewModel: ObservableObject {
    // timer settings in seconds
    @AppStorage("sessionLength") var sessionLength = 3600 
//    {
//            didSet {
//                UserDefaults.standard.set(sessionLength, forKey: "sessionLength")
//            }
//        }
    @AppStorage("gameLength") var gameLength = 10 
//    {
//            didSet {
//                UserDefaults.standard.set(gameLength, forKey: "gameLength")
//            }
//        }
    @AppStorage("transitionLength") var transitionLength = 2 
//    {
//            didSet {
//                UserDefaults.standard.set(transitionLength, forKey: "transitionLength")
//            }
//        }
}

