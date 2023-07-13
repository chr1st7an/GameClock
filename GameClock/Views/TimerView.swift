//
//  TimerView.swift
//  GameClock
//
//  Created by Christian Rodriguez on 4/28/23.
//

import SwiftUI

struct TimerView: View {
    @Environment(\.scenePhase) var scenePhase
    @EnvironmentObject var model : TimerViewModel
    
    // USER SETTINGS
    @AppStorage("isDarkMode") private var isDarkMode = false
    @AppStorage("gameMinutes") private var gameMinutes = 4
    @AppStorage("isAutoReplay") private var isAutoReplay = false
    @AppStorage("replayDelay") private var bufferLengthInSeconds = 25
    @AppStorage("countdown") private var countdown = false

    // Session Status
    @GestureState var endSession = false
    @State var gamesLeft : Int = 15
    
    // Page Toggles
    @State var showSettings = false
    @State var showSounds = false
    @State var showRules = false
    @State var testToggle = false
    @State var showRestartAlert = false
    @State var showEndAlert = false
    
    // Loop Config
    @State var timeElapsed: Int = 3
    @State var loop : Timer.TimerPublisher = Timer.publish(every: 1, on: .main, in: .common)
    
    
    var timerControls: some View {
        ZStack{
            VStack{
                HStack(spacing: 25) {
                    switch model.sessionState {
                    case .paused:
                        Button{
                            let impact = UIImpactFeedbackGenerator(style: .medium)
                            impact.impactOccurred()
                            model.sessionState = .resumed
                        }label: {
                            Image(systemName: "play").foregroundColor(Color("text"))
                        }
                        .buttonStyle(PlayButtonStyle())
                    case .active, .resumed:
                        Button {
                            let impact = UIImpactFeedbackGenerator(style: .medium)
                            impact.impactOccurred()
                            model.sessionState = .paused
                        }label: {
                            Image(systemName: "pause").foregroundColor(Color("text"))
                        }
                        .buttonStyle(PauseButtonStyle())
                    case .ended:
                        HStack{
                        }
                    }
                }
                HStack(spacing:25){
                    Button{
                        let impact = UIImpactFeedbackGenerator(style: .medium)
                        impact.impactOccurred()
                        model.secondsToGameCompletion -= 10
                    }label: {
                        Image(systemName: "gobackward.10").foregroundColor(Color("text"))
                    }
                    .buttonStyle(PlayButtonStyle())
                    .padding(.bottom, 30)
                    Button {
                        showRestartAlert = true
                    } label: {
                        Image(systemName: "soccerball").resizable().frame(width: 35, height: 35)
                    }.buttonStyle(EndSessionButtonStyle())
                        .alert(isPresented:$showRestartAlert) {
                            Alert(
                                title: Text("Killer Goal"),
                                message: Text("Volley? Header? First Goal? New game."),
                                primaryButton: .destructive(Text("Goal")) {
                                    let impact = UIImpactFeedbackGenerator(style: .medium)
                                    impact.impactOccurred()
//                                    model.secondsToGameCompletion = 240
                                    model.gameProgress = 0
                                    withAnimation {
                                        model.buffering = true
                                    }
                                    
                                },
                                secondaryButton: .cancel()
                            )
                        }
                    Button{
                        let impact = UIImpactFeedbackGenerator(style: .medium)
                        impact.impactOccurred()
                        model.secondsToGameCompletion += 10
                    }label: {
                        Image(systemName: "goforward.10").foregroundColor(Color("text"))
                    }
                    .buttonStyle(PlayButtonStyle())
                    .padding(.bottom, 30)
                }
            }.opacity(model.buffering ? 0 : 1)
            Button {
                let impact = UIImpactFeedbackGenerator(style: .medium)
                impact.impactOccurred()
                model.secondsToBufferCompletion = 1
            } label: {
                Text("start game").overlay(
                    RoundedRectangle(cornerRadius: 25)
                        .stroke(Color("iconButton")
                            .opacity(0.4), lineWidth: 2).frame(width: 200, height: 50)
                ).foregroundColor(Color("iconButton"))
            }.opacity(model.buffering ? 1 : 0)
        }
        
    }
    
    var gameProgressView: some View {
        ZStack (alignment: .center){
            withAnimation {
                CircularProgressView(progress: $model.gameProgress)
            }
            VStack{
                if model.buffering {
                    Text("game starts in").foregroundColor(Color("text"))
                    Text("\(model.secondsToBufferCompletion) seconds ")
                        .font(.largeTitle).foregroundColor(Color("text"))
                }else{
                    Text(model.secondsToGameCompletion.asShortTimestamp)
                        .font(.largeTitle).foregroundColor(Color("text"))
                }
                HStack {
                    Image(systemName: "soccerball").foregroundColor(Color("text"))
                    Text("\(gamesLeft) games ").foregroundColor(Color("text"))
                }
            }
        }
    }
    
    var body: some View {
        NavigationStack{
            GeometryReader{proxy in
                VStack(alignment: .center){
                    gameProgressView
                        .padding(.vertical)
                        .padding(.horizontal, 40)
                        .onReceive(loop) { tick in
                            timeElapsed -= 1
                            if timeElapsed <= 0 {
                                withAnimation {
                                    model.loopState = .active
                                    model.looping = false
                                }
                            }
                        }
                        .onReceive(model.buffer) { tick in
                            model.secondsToBufferCompletion -= 1
                            print("\(model.secondsToBufferCompletion) to next game")
                            if model.secondsToBufferCompletion < 1 {
                                withAnimation {
                                    model.secondsToGameCompletion = gameMinutes * 60
                                    model.buffering = false
                                    gamesLeftUpdate()
                                }
                            }
                        }
                    timerControls
                    Spacer()
                    Text(model.secondsToSessionCompletion.asLongTimestamp)
                        .font(.title).foregroundColor(Color("text")).shadow(radius: 0.5)
                    ProgressView(value: (1 - model.sessionProgress), total: 1) {
                    }.progressViewStyle(.linear).frame(width: proxy.size.width * 0.75).tint(STFCpink)
                    Text("session until \(model.completionDate, format: .dateTime.hour().minute())").foregroundColor(Color("text"))
                }
                .padding(.vertical)
                .foregroundColor(.white)
                .onChange(of: model.secondsToGameCompletion) { timeLeft in
                    if  timeLeft < 10 && countdown {
                        // TODO : queue timer countdown...
                        if timeLeft % 2 == 1 {
                            model.audio.playAudio(soundName: "beep")
                        }
                    }
                }
                .toolbar {
                    ToolbarItemGroup(placement: .navigationBarLeading) {
                        Button {
                            showRules = true
                        } label: {
                            Image(systemName: "gamecontroller")
                        }.foregroundColor(Color("iconButton"))
                        ZStack {
                            RoundedRectangle(cornerRadius: 35).foregroundColor(.red.opacity(0.9)).frame(width: proxy.size.width * 0.3, height: proxy.size.height * 0.04)
                            Text("END SESSION").font(.custom(
                                "RobotoRound",
                                fixedSize: 12)).foregroundColor(.white)
                        }
                        .onTapGesture {
                            let impact = UIImpactFeedbackGenerator(style: .heavy)
                            impact.impactOccurred()
                            showEndAlert = true
                            
                        }.alert(isPresented:$showEndAlert) {
                            Alert(
                                title: Text("Confirm"),
                                message: Text("end the session"),
                                primaryButton: .destructive(Text("End")) {
                                    let impact = UIImpactFeedbackGenerator(style: .medium)
                                    impact.impactOccurred()
                                    model.looping = false
                                    timeElapsed = 3
                                    loop = Timer.publish(every: 1, on: .main, in: .common)
                                    withAnimation {
                                        model.inGame = false
                                        model.buffering = true
                                        model.loopState = .ended
                                        model.sessionState = .ended
                                    }
                                    
                                },
                                secondaryButton: .cancel()
                            )
                        }
                        .padding(.vertical)
                    }
                    ToolbarItemGroup(placement: .navigationBarTrailing) {
                        Button {
                            showSounds = true
                        } label: {
                            Image(systemName: "waveform").foregroundColor(Color("iconButton"))
                        }.foregroundColor(.black)
                        Button {
                            showSettings = true
                        } label: {
                            Image(systemName: "gearshape.fill").foregroundColor(.gray)
                        }
                    }
                }
            }
            .onAppear {
                gamesLeft = model.sessionLengthSeconds / model.gameLengthSeconds
                model.buffer.connect()
                model.secondsToBufferCompletion = bufferLengthInSeconds
//                model.audio.playAudio(soundName: "start")
            }
        }.sheet(isPresented: $showSettings) {
            settingsView()
        }
        .sheet(isPresented: $showRules) {
            RuleBookView()
        }
        .sheet(isPresented: $showSounds) {
            SoundBoardView()
        }.onChange(of: scenePhase) { newPhase in
            model.onChangeOfScenePhase(newPhase)
        }
        .onChange(of: model.looping){ paused in
            if paused {
                loop.connect()
            }else{
                loop.connect().cancel()
                timeElapsed = 3
                loop = Timer.publish(every: 1, on: .main, in: .common)
            }
        }
        .onChange(of: model.buffering){ buffering in
            if buffering {
                model.buffer.connect()
                model.secondsToBufferCompletion = bufferLengthInSeconds
            }else{
                model.buffer.connect().cancel()
                model.secondsToBufferCompletion = bufferLengthInSeconds
                model.buffer = Timer.publish(every: 1, on: .main, in: .common)
            }
        }
        
    }

    @ViewBuilder
    func settingsView() -> some View{
        NavigationView {
            Form {
                Section(header: Text("Notifications")) {
                    Toggle(isOn: $model.tips) {
                        Text("Receive game captaining tips")
                    }.animation(.default, value: testToggle)
                }
                Section {
                    Toggle("Dark Mode", isOn: $isDarkMode)
                } header: {
                    Text("Color Scheme")
                }


                Section(header: Text("Session")) {
//                    Stepper(value: $gameMinutes, in: 1...10) {
//                        Text("\(gameMinutes) minute games")
//                    }
                    Stepper(value: $bufferLengthInSeconds, in: 5...30) {
                        Text("\(bufferLengthInSeconds) seconds between games")
                    }
                }
                Section {
                    Picker("Voice", selection: $model.voiceSelection) {
                            Text("Male 1").tag("male1")
                            Text("Female 1").tag("female1")
                            Text("Monster").tag("monster")
                        }
                    Picker("Announcement Frequency", selection: $model.frequencySelection) {
                            Text("Low").tag("low")
                            Text("Medium").tag("medium")
                            Text("High").tag("high")
                        }
                    Toggle("10 second countdown", isOn: $countdown)
                } header: {
                    Text("Audio")
                } footer: {
                    VStack(alignment: .leading) {
                        Text("Low: 90 sec, 30 sec")
                        Text("Medium: 2 min, 1 min, 30 sec")
                        Text("High: 3 min, 2 min, 90 sec, 1 min, 30 sec")
                    }.fontWeight(.light)
                }

                Button("Restore Settings") {
                    model.voiceSelection = "male1"
                    model.frequencySelection = "medium"
                    bufferLengthInSeconds = 25
                    countdown = false
                    gameMinutes = 4
                }
            }
            .navigationBarTitle(Text("Settings"))
        }
    }
    func gamesLeftUpdate(){
        gamesLeft = model.sessionLengthSeconds / model.gameLengthSeconds
        if (gamesLeft == 1 || gamesLeft == 2 || gamesLeft == 5){
            model.audio.playAudio(soundName: "\(gamesLeft)")
            print("remember to check all players in")
        }
    }
    }


struct TimerView_Previews: PreviewProvider {
    static var previews: some View {
        TimerView().environmentObject(TimerViewModel())
    }
}
