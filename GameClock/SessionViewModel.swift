//
//  TimerViewModel.swift
//  GameClock
//
//  Created by Christian Rodriguez on 12/26/23.
//

import Foundation

enum GameState {
    case active
    case paused
    case ended
    case restarting
}

enum SessionState {
    case active
    case paused
    case ended
}

class SessionViewModel: ObservableObject {
    
    @Published var sessionState: SessionState = .ended {
        didSet {
            switch sessionState {
            case .active: break
                print("Session Active")
            case .paused: break
                print("Session Paused")
            case .ended:break
                print("Session Ended")
            }
        }
    }

    @Published var gameState: GameState = .ended {
        didSet {
            switch gameState {
            case .active:break
                print("Game Active")
            case .paused:break
                print("Game Paused")
            case .ended:break
                print("Game Ended")
            case .restarting:break
                print("Game Restarting")
            }
        }
    }
    
}
