//
//  TimerViewModel.swift
//  GameClock
//
//  Created by Christian Rodriguez on 4/28/23.
//

import SwiftUI

class TimerViewModel: ObservableObject {
    // AUDIO CONFIG
    @Published var audio: AudioManager = AudioManager()
    @Published var voiceSelection = "male1" {
        didSet {
            UserDefaults.standard.set(voiceSelection, forKey: "voiceSelection")
        }
    }
    @Published var frequencySelection = "medium" {
        didSet {
            UserDefaults.standard.set(frequencySelection, forKey: "frequencySelection")
        }
    }
    @Published var countdown = false {
        didSet {
            UserDefaults.standard.set(countdown, forKey: "countdown")
        }
    }
    
    // USER CONFIG
    @Published var sessionLengthSeconds = 3600 {
        didSet {
            UserDefaults.standard.set(sessionLengthSeconds, forKey: "sessionLengthSeconds")
        }
    }
    @Published var gameLengthSeconds = 240 {
        didSet {
            UserDefaults.standard.set(gameLengthSeconds, forKey: "gameLengthSeconds")
        }
    }
    @Published var transitionLengthSeconds = 15 {
        didSet {
            UserDefaults.standard.set(bufferLengthSeconds, forKey: "bufferLengthSeconds")
        }
    }
    @Published var tips = false {
            didSet {
                UserDefaults.standard.set(tips, forKey: "captainTips")
            }
        }
    
    // SESSION TIMER CONFIG
    private var sessionTimer = Timer()
    @Published var secondsToSessionCompletion = 0
    @Published var sessionProgress: Float = 0.0
    @Published var sessionSecondsElapsed = 0
    
    // GAME TIMER
    @Published var inGame : Bool = false
    @Published var secondsToGameCompletion = 240
    @Published var gameSecondsElapsed = 0
    @Published var gameProgress: Float = 0.0
    
    // BUFFER TIMER CONFIG
    @Published var buffering : Bool = false
    @Published var secondsToBufferCompletion = 15
    @Published var bufferSecondsElapsed = 0
    @Published var bufferProgress: Float = 0.0
    @Published var buffer : Timer.TimerPublisher = Timer.publish(every: 1, on: .main, in: .common)
    
    // INFINITE BACKGROUND LOOP CONFIG
    private var loopTimer = Timer()
    var loopLengthSeconds = 20
    @Published var secondsToLoopCompletion = 0
    @Published var loopSecondsElapsed = 0
    @Published var looping : Bool = false
    var backgroundTask: UIBackgroundTaskIdentifier = .invalid
    @Published var isTaskExecuting = false
    @Published var lastObserved: Date?
    @Published var secondsLeftInGame : Int = 0
    @Published var continueFrom : Int = 0

    // OTHER
    @Published var totalsecondsElapsed: Int = 0
    @Published var completionDate = Date.now
    var updateTimer: Timer?

    init() {
        self.voiceSelection = UserDefaults.standard.string(forKey: "voiceSelection") ?? "male1"
        self.frequencySelection = UserDefaults.standard.string(forKey: "frequencySelection") ?? "medium"
        self.tips = UserDefaults.standard.bool(forKey: "captainTips")
        self.countdown = UserDefaults.standard.bool(forKey: "countdown")
        self.sessionLengthSeconds = UserDefaults.standard.integer(forKey: "sessionLengthSeconds")
        self.secondsToSessionCompletion = self.sessionLengthSeconds
        self.gameLengthSeconds = UserDefaults.standard.integer(forKey: "gameLengthSeconds")
        self.secondsToGameCompletion = self.gameLengthSeconds
        self.bufferLengthSeconds = UserDefaults.standard.integer(forKey: "bufferLengthSeconds")
        self.secondsToBufferCompletion = self.bufferLengthSeconds
    }
    enum TimerState {
        case active
        case paused
        case resumed
        case ended
    }

    enum SessionState {
        case active
        case paused
        case resumed
        case ended
    }
    
    @Published var sessionState: SessionState = .ended {
        didSet {
            switch sessionState {
            case .ended:
                // Cancel the timer and reset all progress properties
                print("session end")
                sessionTimer.invalidate()
                sessionTimer = Timer()
                secondsToSessionCompletion = sessionLengthSeconds
                sessionProgress = 0
                secondsToGameCompletion = gameLengthSeconds

            case .active:
                // Starts the timer and sets all progress properties
                // to their initial values
                print("session started")
                secondsToSessionCompletion = sessionLengthSeconds
                sessionSecondsElapsed = 0
                sessionProgress = 1.0
                startSession()
                updateCompletionDate()

            case .paused:

                sessionTimer.invalidate()

            case .resumed:

                startSession()
            
            }
        }
    }

    @Published var loopState: TimerState = .ended {
        didSet {
            switch loopState {
            case .ended:
                // End the timer and reset all progress properties
                print("looping")
                loopTimer.invalidate()
                loopTimer = Timer()
                secondsToLoopCompletion = 0
                loopSecondsElapsed = 0

            case .active:
                // Starts the timer and sets all progress properties
                // to their initial values
                print("looping")
                secondsToLoopCompletion = loopLengthSeconds
                loopSecondsElapsed = 0
                startLoop()


            case .paused:
                // We want to pause the timer, but we
                // don't want to change the state of our progress
                // properties (secondsToCompletion and progress)
                print("looping")
                loopTimer.invalidate()

            case .resumed:
                // Resumes the timer
                print("looping")
                startLoop()
            }
        }
    }

    private func startLoop() {
        loopTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: { [weak self] _ in
            guard let self else { return }
            

            self.secondsToLoopCompletion -= 1
            self.loopSecondsElapsed += 1
            if self.secondsToLoopCompletion < 0 {
                // this is what causes dumb ass muting during timer announcements
                self.audio.playSilentAudio(soundName: "empty")
                withAnimation {
                    self.loopState = .ended
                    self.looping = true
                }
            }
            switch UIApplication.shared.applicationState {
            case .background:
              let timeRemaining = UIApplication.shared.backgroundTimeRemaining
              if timeRemaining < Double.greatestFiniteMagnitude {
                let secondsRemaining = String(format: "%.1f seconds remaining", timeRemaining)
                print("App is backgrounded - \(secondsRemaining)")
              }
            default:
              break
            }
        })
    }
    
    private func startSession() {
        sessionTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: { [weak self] _ in
            guard let self else { return }

            self.secondsToSessionCompletion -= 1
            self.sessionSecondsElapsed += 1
            withAnimation{
                self.sessionProgress = Float(self.secondsToSessionCompletion) / Float(self.sessionLengthSeconds)
            }
            if self.secondsToSessionCompletion < 0 {
                self.sessionState = .ended
            }
            withAnimation {
                self.gameProgress = Float(self.secondsToGameCompletion) / Float(self.gameLengthSeconds)
            }
            print("\(self.secondsToGameCompletion) seconds left")
            
            if !buffering {
                self.secondsToGameCompletion -= 1
                if frequencySelection == "low"{
                    handleGameUpdatesLow()
                }
                if frequencySelection == "medium"{
                    handleGameUpdatesMedium()
                }
                if frequencySelection == "high"{
                    handleGameUpdatesHigh()
                }
                if self.secondsToGameCompletion == 9 && self.countdown {
                    print("10 second countdown")
                    self.audio.playAudio(soundName: "10_countdown")
                }
            }
            if tips {
                sendCaptainNotification()
            }
        })
    }
    
    func handleGameUpdatesLow(){
        if self.secondsToGameCompletion == 90 {
            print("90 second warning")
            self.audio.playAudio(soundName: "90_sec_\(voiceSelection)")
        }
        if self.secondsToGameCompletion == 30 {
            print("30 second warning")
            self.audio.playAudio(soundName: "30_sec_\(voiceSelection)")
        }
        if self.secondsToGameCompletion <= 0 {
            self.gameProgress = 0
            self.buffering = true
            self.audio.playAudio(soundName: "final_whistle")
        }
    }
    func handleGameUpdatesMedium(){
        if self.secondsToGameCompletion == 120 {
            print("2 minute warning")
            self.audio.playAudio(soundName: "2_min_\(voiceSelection)")
        }
        if self.secondsToGameCompletion == 60 {
            print("2 minute warning")
            self.audio.playAudio(soundName: "1_min_\(voiceSelection)")
        }
        if self.secondsToGameCompletion == 30 {
            print("30 second warning")
            self.audio.playAudio(soundName: "30_sec_\(voiceSelection)")
        }
        if self.secondsToGameCompletion <= 0 {
            self.gameProgress = 0
            self.buffering = true
            self.audio.playAudio(soundName: "final_whistle")

        }
    }
    func handleGameUpdatesHigh(){
        if self.secondsToGameCompletion == 180 {
            print("3 minute warning")
            self.audio.playAudio(soundName: "3_min_\(voiceSelection)")
        }
        if self.secondsToGameCompletion == 120 {
            print("2 minute warning")
            self.audio.playAudio(soundName: "2_min_\(voiceSelection)")
        }
        if self.secondsToGameCompletion == 90 {
            print("90 second warning")
            self.audio.playAudio(soundName: "90_sec_\(voiceSelection)")
        }
        if self.secondsToGameCompletion == 60 {
            print("2 minute warning")
            self.audio.playAudio(soundName: "1_min_\(voiceSelection)")
        }
        if self.secondsToGameCompletion == 30 {
            print("30 second warning")
            self.audio.playAudio(soundName: "30_sec_\(voiceSelection)")
        }
        if self.secondsToGameCompletion <= 0 {
            self.gameProgress = 0
            self.buffering = true
            self.audio.playAudio(soundName: "final_whistle")

        }
    }
    func beginPauseTask() {
      isTaskExecuting.toggle()
      if isTaskExecuting {
      } else {
        endBackgroundTaskIfActive()
      }
    }
    func registerBackgroundTask() {
        print("Registering background task")
      backgroundTask = UIApplication.shared.beginBackgroundTask { [weak self] in
        print("iOS has signaled time has expired")
        self?.endBackgroundTaskIfActive()
      }
    }
    func endBackgroundTaskIfActive() {
      let isBackgroundTaskActive = backgroundTask != .invalid
      if isBackgroundTaskActive {
        print("Background task ended.")
        UIApplication.shared.endBackgroundTask(backgroundTask)
        backgroundTask = .invalid
      }
    }
    func onChangeOfScenePhase(_ newPhase: ScenePhase) {
      switch newPhase {
      case .background:
          let isTaskUnregistered = backgroundTask == .invalid

          if isTaskUnregistered {
            registerBackgroundTask()
          }
          self.lastObserved = Date()
          self.secondsLeftInGame = secondsToLoopCompletion
      case .active:
          endBackgroundTaskIfActive()
          let currentDate = Date()
          let currentAccumulatedTime = currentDate.timeIntervalSince(lastObserved ?? Date())
          print("time since")
          print(currentAccumulatedTime)
      default:
        break
      }
    }
    func sendCaptainNotification(){
        let content = UNMutableNotificationContent()
         
        if self.secondsToSessionCompletion == Int(Double(self.sessionLengthSeconds) * 0.75) {
            content.title = "How's the game? 👀"
            content.body = "make sure all teams are balanced in skill level!"
            content.sound = UNNotificationSound.default
        }
        if self.secondsToSessionCompletion == Int(Double(self.sessionLengthSeconds) * 0.50) {
            content.title = "Halfway there! ⏳"
            content.body = "make sure all players are checked in!"
            content.sound = UNNotificationSound.default
        }
        if self.secondsToSessionCompletion == Int(Double(self.sessionLengthSeconds) * 0.20) {
            content.title = "Have another session? ⚽️"
            content.body = "players should be rolling in."
            content.sound = UNNotificationSound.default
        }
        
        // show this notification five seconds from now
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        // choose a random identifier
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        // add our notification request
        UNUserNotificationCenter.current().add(request)
    }
    private func updateCompletionDate() {
        completionDate = Date.now.addingTimeInterval(Double(secondsToSessionCompletion))
    }
}
extension Int {
    var asShortTimestamp: String {

        let minute = self / 60 % 60
        let second = self % 60

        return String(format: "%02i:%02i", minute, second)
    }
    var asLongTimestamp: String {
        let hour = self / 3600
        let minute = self / 60 % 60
        let second = self % 60

        return String(format: "%02i:%02i:%02i",hour, minute, second)
    }
}

