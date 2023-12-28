//
//  TimerViewModel.swift
//  GameClock
//
//  Created by Christian Rodriguez on 12/26/23.
//

import Foundation
import SwiftUI

class SessionViewModel: ObservableObject {
    
    // Default values to be overridden by User Defaults upon session start
    @Published var config = SessionConfig(sessionLength: 3600, gameLength: 240, transitionLength: 25)
    
    
    // SESSION
    private var sessionTimer = Timer()
    @Published var sessionSecondsRemaining = 0
    @Published var sessionSecondsElapsed = 0
    @Published var sessionProgress: Float = 0.0

    @Published var sessionState: SessionState = .ended {
        didSet {
            switch sessionState {
            case .start(let config):
                self.config = config
                setUpSession()
            case .active:
                startSession()
            case .paused:
                sessionTimer.invalidate()
            case .ended:
                endSession()
            }
        }
    }
    
    private func setUpSession() {
        withAnimation{
            sessionSecondsRemaining = config.sessionLength
            sessionSecondsElapsed = 0
            sessionProgress = 1.0
            self.sessionState = .active
        }
    }

    private func startSession() {
        sessionTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: { [weak self] _ in
            guard let self else { return }
            self.sessionSecondsRemaining -= 1
            self.sessionSecondsElapsed += 1
            withAnimation{
                self.sessionProgress = Float(self.sessionSecondsRemaining) / Float(self.config.sessionLength)
            }
            if self.sessionSecondsRemaining < 0 {
                self.sessionState = .ended
            }
        })
    }
    
    func endSession() {
        sessionTimer.invalidate()
        sessionTimer = Timer()
        endGame()
    }

    // GAME
    private var gameTimer = Timer()
    @Published var gameSecondsRemaining = 0
    @Published var gameSecondsElapsed = 0
    @Published var gameProgress: Float = 0.0
    
    @Published var gameState: GameState = .ended {
        didSet {
            switch gameState {
            case .start:
                setUpGame()
            case .active:
                startGame()
            case .paused:
                gameTimer.invalidate()
            case .ended:
                endGame()
                gameState = .restarting
            case .restarting:
                transitionState = .start
            }
        }
    }
    
    private func setUpGame() {
        withAnimation{
            gameSecondsRemaining = config.gameLength
            gameSecondsElapsed = 0
            gameProgress = 1.0
            self.gameState = .active
        }
    }
    
    private func startGame() {
        gameTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: { [weak self] _ in
            guard let self else { return }
            self.gameSecondsRemaining -= 1
            self.gameSecondsElapsed += 1
            withAnimation{
                self.gameProgress = Float(self.gameSecondsRemaining) / Float(self.config.gameLength)
            }
            if self.gameSecondsRemaining < 0 {
                self.gameState = .ended
            }
        })
    }
    
    func endGame() {
        gameTimer.invalidate()
        gameTimer = Timer()
    }
    
    // TRANSITION
    private var transitionTimer = Timer()
    @Published var transitionSecondsRemaining = 0
    @Published var transitionSecondsElapsed = 0
    @Published var transitionProgress: Float = 0.0
    
    @Published var transitionState: TransitionState = .ended {
        didSet {
            switch transitionState {
            case .start:
                setUpTransition()
            case .active:
                startTransition()
            case .ended:
                endTransition()
                gameState = .start
            case .pause:
                endTransition()
            }
        }
    }
    
    private func setUpTransition() {
        withAnimation{
            transitionSecondsRemaining = config.transitionLength
            transitionSecondsElapsed = 0
            transitionProgress = 1.0
            self.transitionState = .active
        }
    }
    
    private func startTransition() {
        transitionTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: { [weak self] _ in
            guard let self else { return }
            self.transitionSecondsRemaining -= 1
            self.transitionSecondsElapsed += 1
            withAnimation{
                self.transitionProgress = Float(self.transitionSecondsRemaining) / Float(self.config.transitionLength)
            }
            if self.transitionSecondsRemaining < 0 {
                self.transitionState = .ended
            }
        })
    }
    
    func endTransition() {
        transitionTimer.invalidate()
        transitionTimer = Timer()
    }
    
}

enum GameState {
    case start
    case active
    case paused
    case ended
    case restarting
}

enum SessionState : Hashable {
    case start(SessionConfig)
    case active
    case paused
    case ended
}

enum TransitionState {
    case start
    case active
    case ended
    case pause
}
