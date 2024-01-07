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
    @Published var config = SessionConfig(sessionLength: 3600, gameLength: 240, transitionLength: 25, countDown: true, colorPreference: "system")
    @Published var audio: AudioManager = AudioManager()
    @Published var nullifyAudio = false

    
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
                sessionTimer = Timer()
            case .ended:
                endSession()
            }
        }
    }
    
    private func setUpSession() {
        print("Starting \(config.sessionLength / 60) minute session with \(config.gameLength / 60) minute games and \(config.transitionLength) second transitions")
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
            
            if sessionSecondsRemaining == (config.sessionLength / 2 ) && !nullifyAudio{
                self.audio.playAudio(soundName: "halfway", fileType: "caf")
            }
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
            if self.gameSecondsRemaining % 30 == 0 && !nullifyAudio {
                let soundName = findSoundName(indicator: gameSecondsRemaining)
                self.audio.playAudio(soundName: soundName, fileType: "mp3")
                print("Announcement Sounding: \(soundName)")
            }

            self.gameSecondsRemaining -= 1
            self.gameSecondsElapsed += 1
            withAnimation{
                self.gameProgress = Float(self.gameSecondsRemaining) / Float(self.config.gameLength)
            }
            if self.gameSecondsRemaining == 10 && config.countDown {
                self.audio.playAudio(soundName: "countdown", fileType: "mp3")
            }else if self.gameSecondsRemaining < 0 {
                self.gameState = .ended
            }
            switch UIApplication.shared.applicationState {
            case .background:
              let timeRemaining = UIApplication.shared.backgroundTimeRemaining
              if timeRemaining < Double.greatestFiniteMagnitude {
                let secondsRemaining = String(format: "%.1f seconds remaining", timeRemaining)
              }
            default:
              break
            }
        })
    }
    
    func endGame() {
        gameSecondsRemaining = config.gameLength
        gameSecondsElapsed = 0
        gameProgress = 1.0
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
            
            if transitionSecondsRemaining == 5 {
                let gamesLeft = self.sessionSecondsRemaining / (config.gameLength + config.transitionLength)
                if [5, 4, 3, 2, 1].contains(gamesLeft) && !nullifyAudio {
                    print("\(gamesLeft) Games Left Announcement")
                    self.audio.playAudio(soundName: gamesLeft.description, fileType: "caf")
                }
            }
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
        transitionSecondsRemaining = config.transitionLength
        transitionSecondsElapsed = 0
        transitionProgress = 1.0
        transitionTimer.invalidate()
        transitionTimer = Timer()
    }
    
    @Published var isTaskExecuting = false
    @Published var deepSleep = false

    @Published var lastActive = Date()
    @Published var lastActiveState : LastActiveState = LastActiveState(sessionState: .paused, secondsRemainingSession: 1800, gameState: .paused, secondsRemainingGame: 120, transitionState: .pause, secondsRemainingTransition: 15, secondsLeftInCurrentCycle: 265)
    var backgroundTask: UIBackgroundTaskIdentifier = .invalid
    
    func enterBackgroundState() {
        // TRY TO SCHEDULE ANNOUNCEMENT NOTIFICATIONS HERE
        sessionState = .paused
        if gameState == .active {
            gameState = .paused
            self.endGame()
        }
        if transitionState == .active {
            transitionState = .pause
        }
    }
    
    func catchUpState() {
        print(self.lastActiveState)
        print("time since last active: \(self.lastActive.timeIntervalSinceNow)")
        
        withAnimation{
            // negative value
            var secondsSinceLastActive = Int(self.lastActive.timeIntervalSinceNow)
            
            // Subtract time elapsed from session seconds remaining ALWAYS
            self.sessionState = .active
            self.sessionSecondsRemaining += secondsSinceLastActive
            // PRELIMINARY: checks if time in background surpases the length
            if self.lastActiveState.secondsLeftInCurrentCycle + secondsSinceLastActive > 0  {
                // App has been in background for shorter or equal to last cycle
                print("App has been in background for shorter or equal to last cycle")
                if self.lastActiveState.secondsLeftInCurrentCycle > config.transitionLength {
                    // in game
                    print("Should be in game")
                    gameState = .active
                    gameSecondsRemaining += (secondsSinceLastActive - (config.gameLength - lastActiveState.secondsRemainingGame))
                }else{
                    // "in transition"
                    gameState = .restarting
                    print("Should be in transition")
                    transitionSecondsElapsed = config.transitionLength - self.lastActiveState.secondsLeftInCurrentCycle
                    transitionSecondsRemaining = self.lastActiveState.secondsLeftInCurrentCycle
                }
            }else{
                // App has been in background for longer than last cycle
                print("App has been in background for longer than last cycle")
                secondsSinceLastActive += self.lastActiveState.secondsLeftInCurrentCycle
                let secondsIntoNewCycle = (secondsSinceLastActive * -1) % (config.gameLength + config.transitionLength)
                print("seconds into new cycle \(secondsIntoNewCycle)")
                if secondsIntoNewCycle >= config.gameLength {
                    // in transition
                    gameState = .restarting
                    print("Should be in transition")
                    transitionSecondsElapsed = secondsIntoNewCycle - config.gameLength
                    transitionSecondsRemaining = config.transitionLength - (secondsIntoNewCycle - config.gameLength)
//                    transitionState = .active
                }else{
                    // in game
                    print("Should be in game")
                    gameState = .start
                    gameSecondsRemaining -= secondsIntoNewCycle
                }
            }
        }
    }
    
    func logState(){
        self.lastActive = Date()
//        find seconds left in current cycle
        if gameState == .active {
            let secondsLeftInCurrentCycle = gameSecondsRemaining + config.transitionLength
            self.lastActiveState = LastActiveState(sessionState: sessionState, secondsRemainingSession: sessionSecondsRemaining, gameState: gameState, secondsRemainingGame: gameSecondsRemaining, transitionState: transitionState, secondsRemainingTransition: transitionSecondsRemaining, secondsLeftInCurrentCycle: secondsLeftInCurrentCycle)
        }
        if transitionState == .active {
            let secondsLeftInCurrentCycle = transitionSecondsRemaining
            self.lastActiveState = LastActiveState(sessionState: sessionState, secondsRemainingSession: sessionSecondsRemaining, gameState: gameState, secondsRemainingGame: gameSecondsRemaining, transitionState: transitionState, secondsRemainingTransition: transitionSecondsRemaining, secondsLeftInCurrentCycle: secondsLeftInCurrentCycle)
        }
    }

    func registerBackgroundTask() {
        self.nullifyAudio = true
      backgroundTask = UIApplication.shared.beginBackgroundTask { [weak self] in
        print("iOS has signaled time has expired")
        self?.logState()
        self?.scheduleAnnouncements()
        self?.enterBackgroundState()
        self?.endBackgroundTaskIfActive()
        self?.deepSleep = true
      }
    }

    func endBackgroundTaskIfActive() {
      let isBackgroundTaskActive = backgroundTask != .invalid
      if isBackgroundTaskActive {
        print("Background task ended.")
        UIApplication.shared.endBackgroundTask(backgroundTask)
        backgroundTask = .invalid
      }
        else{
            if deepSleep{
                catchUpState()
                self.deepSleep = false
            }else{
                print("test")
                // case when scene phase goes active -> inactive -> active
            }
      }
    }


    func scheduleAnnouncements() {
        if lastActiveState.secondsLeftInCurrentCycle > config.transitionLength {
            print("Scheduling remaining announcements for the rest of the current cycle")
            // immediately schedule current cycle's worth of announcements
            let idk = 30 - config.transitionLength
            let nextAnnouncementSeconds = lastActiveState.secondsLeftInCurrentCycle % 30
            let soonestAnnouncement = lastActiveState.secondsLeftInCurrentCycle - nextAnnouncementSeconds
            let announcementsInCurrentCycle = soonestAnnouncement / 30
            if announcementsInCurrentCycle >= 1 {
                scheduleTimerNotification(secondsFromNow: nextAnnouncementSeconds + idk, soundIndicator: soonestAnnouncement - 30)
                for announcement in 1..<announcementsInCurrentCycle {
                    let nextAnnouncement = soonestAnnouncement - (announcement * 30) - 30
                    scheduleTimerNotification(secondsFromNow: nextAnnouncementSeconds + (announcement * 30) + idk, soundIndicator: nextAnnouncement)
                }
            }
        }
        let cycleLength = config.transitionLength + config.gameLength
        var base = lastActiveState.secondsLeftInCurrentCycle
        let remainingGames = (sessionSecondsRemaining - lastActiveState.secondsLeftInCurrentCycle) / cycleLength
        // 30 to be replaced by user announcement rate settings
        let announcementsInCycle = cycleLength / 30
        
//        print("Scheduling announcements for the \(remainingGames) games left in the session")
        sendNotification(title: "ATTENTION ‼️", subtitle: "Timer updates will only sound for the next 5 games each time the app moves to the background.", body: "For ideal experience, keep app in the foreground. Never kill the app while the session is active!")

        for game in 0..<5 {
            print("Game #\(game)")
            var soundIndicator = cycleLength + (30 - config.transitionLength)
            for announcement in 0...announcementsInCycle{
                soundIndicator -= 30
                let secondsFromNow = base + (announcement * 30)
                scheduleTimerNotification(secondsFromNow: secondsFromNow, soundIndicator: soundIndicator)
            }
            base += cycleLength
        }
    }
    func sendNotification(title: String,subtitle: String, body: String){

        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.subtitle = subtitle
        // Allows notification to play sound even on mute
        content.interruptionLevel = .active
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 3, repeats: false)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)

        // add our notification request
        UNUserNotificationCenter.current().add(request) { (error) in
            if let error = error {
                print("Error scheduling notification: \(error.localizedDescription)")
            } else {
//                print("Notification scheduled successfully")
            }
        }
    }
    func scheduleTimerNotification(secondsFromNow: Int, soundIndicator: Int){

        let soundName = findSoundName(indicator: soundIndicator)
        
        let minute = soundIndicator / 60 % 60
        let second = soundIndicator % 60
        
        print("\(soundName) notification scheduled \(secondsFromNow) seconds from now")
        
        if soundIndicator == 30 && config.countDown {
            scheduleTimerNotification(secondsFromNow: secondsFromNow + 20, soundIndicator: 420)
        }

        let content = UNMutableNotificationContent()
        content.title = "\(minute) minutes and \(second) seconds remaining"
        if soundIndicator == 420 {
            content.title = "10 second countdown"
        }
        content.sound = UNNotificationSound.default
        content.sound = .criticalSoundNamed(UNNotificationSoundName(rawValue: "\(soundName).mp3"), withAudioVolume: 1.0)
        // Allows notification to play sound even on mute
        content.interruptionLevel = .critical

        let fireDate = Calendar.current.date(byAdding: .second, value: secondsFromNow, to: lastActive)!
        let components = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: fireDate)

        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
        // choose a random identifier
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        // add our notification request
        UNUserNotificationCenter.current().add(request) { (error) in
            if let error = error {
                print("Error scheduling notification: \(error.localizedDescription)")
            } else {
//                print("Notification scheduled successfully")
            }
        }
    }
    
    func findSoundName(indicator: Int) -> String {
        
        var soundName = ""
        
        let announcementsInCycle = config.gameLength / 30
        let soundPoint = indicator / 30
        
        if soundPoint == announcementsInCycle {
            soundName = "startGame"
        }else if soundPoint == 0{
            // final whistle
            soundName = "finalWhistle"
        }else if indicator == 420 {
            soundName = "countdown"
        }
        else{
            soundName = indicator.description
        }

        return soundName
    }
    
    func cancelAllNotifications() {
        let center = UNUserNotificationCenter.current()
        
        // Remove all pending notification requests
        center.removeAllPendingNotificationRequests()
        
        // You can also remove delivered notifications if needed
         center.removeAllDeliveredNotifications()
        
        print("All scheduled notifications canceled")
    }

    func onChangeOfScenePhase(_ newPhase: ScenePhase) {
      switch newPhase {
      case .background:
        let isTaskUnregistered = backgroundTask == .invalid

        if isTaskUnregistered {
            print("Registering Background Task")
          registerBackgroundTask()
        }
      case .active:
          self.nullifyAudio = false
        endBackgroundTaskIfActive()
          cancelAllNotifications()

      default:
        break
      }
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

struct LastActiveState {
    
    var sessionState : SessionState
    var secondsRemainingSession: Int

    var gameState : GameState
    var secondsRemainingGame: Int
    
    var transitionState : TransitionState
    var secondsRemainingTransition: Int
    
    var secondsLeftInCurrentCycle: Int
    
}
