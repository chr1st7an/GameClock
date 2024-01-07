//
//  SessionView.swift
//  GameClock
//
//  Created by Christian Rodriguez on 12/26/23.
//

import SwiftUI

struct SessionView: View {
    @Environment(\.scenePhase) var scenePhase
    @State var selectedTab : SessionTab = .timer
    @EnvironmentObject var sessionModel : SessionViewModel
    
    @State var confirmEndSession = false
    @State var confirmEndGame = false

    @State var showSettings = false
    @State var showInfo = false
    var body: some View {
        NavigationStack{
            ZStack{
                ColorPalette.primaryBackground.ignoresSafeArea()
                TabView(selection: $selectedTab){
                    TimerView().tag(SessionTab.timer)
                    SoundBoardTab().tag(SessionTab.soundBoard)
                    // add settings, rules, etc
                }.tabViewStyle(.page(indexDisplayMode: .always)).ignoresSafeArea(edges: .bottom)
            }.toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button{
                        self.confirmEndSession = true
                        let impactFeedbackGenerator = UIImpactFeedbackGenerator(style: .rigid)
                        impactFeedbackGenerator.prepare()
                        impactFeedbackGenerator.impactOccurred()
                    }label: {
                        Rectangle().stroke(lineWidth: 1.5).frame(width: 150, height: 40).foregroundStyle(.foreground).overlay {
                            Text("End Session").font(Font.custom("Orbitron-Regular", size: 18)).foregroundStyle(ColorPalette.primaryText)
                        }.background {
                            Color.red.opacity(0.8)
                        }
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    HStack{
                        Button{
                            // show app infographic, suggested rules
                            withAnimation {
                                self.showInfo = true
                            }
                        }label: {
                            Image(systemName: "info.circle").resizable().frame(width: 25, height: 25).foregroundStyle(ColorPalette.primaryText)
                        }
                        Button{
                            // show in-session settings
                            withAnimation {
                                self.showSettings = true
                            }
                        }label: {
                            Image(systemName: "gear").resizable().frame(width: 25, height: 25).foregroundStyle(ColorPalette.primaryText)
                        }
                    }
                }
            }
        }
        .alert("You sure you want to end this session?", isPresented: $confirmEndSession) {
                    Button("No", role: .cancel) { }
            Button("Yes", role: .destructive) { 
                withAnimation{
                    sessionModel.sessionState = .ended
                    sessionModel.gameState = .paused
                    sessionModel.endGame()
                    sessionModel.transitionState = .pause
                }
            }
                }
        .alert("You sure you want to end this game?", isPresented: $confirmEndGame) {
                    Button("No", role: .cancel) { }
            Button("Yes", role: .destructive) {
                withAnimation{
                    sessionModel.gameSecondsRemaining = 1
                    sessionModel.gameSecondsElapsed = sessionModel.config.gameLength - 1
                }
            }
                }
        .onChange(of: scenePhase) { newPhase in
            print("App: \(newPhase)")
            sessionModel.onChangeOfScenePhase(newPhase)
                    }
        .sheet(isPresented: $showSettings, content: {
            SettingsSheet()
        })
        .sheet(isPresented: $showInfo, content: {
            InfoView()
        })
    }
    
    @ViewBuilder
    func TimerView() -> some View {
        ZStack{
            RectangularProgressView(progress: $sessionModel.sessionProgress)
            Rectangle().frame(width: .infinity, height: 10).foregroundStyle(.gray).padding(.horizontal, 5)
            CircularProgressView(progress:
                                    sessionModel.gameState == .restarting ? $sessionModel.transitionProgress : $sessionModel.gameProgress).frame(width: 200).padding(.horizontal, 5).background {
                ColorPalette.primaryBackground
            }.overlay {
                Text(sessionModel.gameState == .restarting ? sessionModel.transitionSecondsRemaining.asTimestamp : sessionModel.gameSecondsRemaining.asTimestamp).font(Font.custom("Play-Bold", size: 55)).foregroundStyle(ColorPalette.primaryText)
            }
            TimerControls(offset: 225)
            UtilityButtons()
        }.padding()
    }
    
    @ViewBuilder
    func TimerControls(offset: CGFloat) -> some View{
            ZStack{
                Rectangle().frame(width: .infinity, height: 75).foregroundStyle(ColorPalette.primaryBackground).shadow(color: ColorPalette.secondaryText, radius: 8, x: 0, y: 5)
                switch sessionModel.gameState{
                case .active, .paused, .ended, .start:
                    HStack(spacing:5){
                        Button{
                            let impactFeedbackGenerator = UIImpactFeedbackGenerator(style: .heavy)
                            impactFeedbackGenerator.prepare()
                            impactFeedbackGenerator.impactOccurred()
                            withAnimation {
                                sessionModel.gameSecondsRemaining -= 10
                            }
                        }label: {
                            Rectangle().stroke(ColorPalette.primaryText, lineWidth: 5).overlay {
                                Text("-10").font(Font.custom("Play-Bold", size: 30)).foregroundStyle(.red)
                            }
                        }
                        Button{
                            let impactFeedbackGenerator = UIImpactFeedbackGenerator(style: .light)
                            impactFeedbackGenerator.prepare()
                            impactFeedbackGenerator.impactOccurred()
                            withAnimation{
                                switch sessionModel.gameState {
                                case .start, .paused, .restarting:
                                    sessionModel.gameState = .active
                                case .active:
                                    sessionModel.gameState = .paused
                                case .ended:
                                    sessionModel.gameState = .restarting
                                }
                            }
                        }label: {
                            if sessionModel.gameState == .active {
                                Rectangle().stroke(ColorPalette.primaryForeground, lineWidth: 5).overlay {
                                    Image(systemName:  "pause").resizable().frame(width: 30, height: 30).foregroundStyle(ColorPalette.primaryText)
                                }.foregroundStyle(ColorPalette.primaryForeground)
                            }else{
                                Rectangle().overlay {
                                    Image(systemName:  "play").resizable().frame(width: 30, height: 30).foregroundStyle(ColorPalette.primaryBackground)
                                }.foregroundStyle(ColorPalette.primaryForeground)
                            }
                            
                            
                        }
                        Button{
                            let impactFeedbackGenerator = UIImpactFeedbackGenerator(style: .heavy)
                            impactFeedbackGenerator.prepare()
                            impactFeedbackGenerator.impactOccurred()
                            withAnimation {
                                sessionModel.gameSecondsRemaining += 10
                            }
                        }label: {
                            Rectangle().stroke(ColorPalette.primaryText, lineWidth: 5).overlay {
                                Text("+10").font(Font.custom("Play-Bold", size: 30)).foregroundStyle(ColorPalette.secondaryBackground)
                            }
                        }
                    }.frame(width: .infinity, height: 75)
                case .restarting:
                    HStack(spacing:5){
                        Button{
                            let impactFeedbackGenerator = UIImpactFeedbackGenerator(style: .rigid)
                            impactFeedbackGenerator.prepare()
                            impactFeedbackGenerator.impactOccurred()
                            withAnimation {
                                sessionModel.transitionState = .ended
                            }
                        }label: {
                            Rectangle().stroke(ColorPalette.primaryText, lineWidth: 5).overlay {
                                Text("START GAME").font(Font.custom("Play-Bold", size: 30)).foregroundStyle(ColorPalette.primaryText)
                            }
                        }
                    }.frame(width: .infinity, height: 75)
                }
                
            }.offset(y: offset).padding(.horizontal, 40)

    }
    
    @ViewBuilder
    func UtilityButtons() -> some View {
        ZStack{
            switch sessionModel.gameState{
            case .active, .paused, .ended, .start:
                HStack{
                    Button{
                        let impactFeedbackGenerator = UIImpactFeedbackGenerator(style: .rigid)
                        impactFeedbackGenerator.prepare()
                        impactFeedbackGenerator.impactOccurred()
                        withAnimation {
                            self.confirmEndGame = true
                        }
                    }label: {
                        Rectangle().stroke(ColorPalette.primaryText, lineWidth: 5).overlay {
                            Text("End Game").font(Font.custom("Play-Bold", size: 30)).foregroundStyle(ColorPalette.primaryText)
                        }
                    }
                    Button{
                        let impactFeedbackGenerator = UIImpactFeedbackGenerator(style: .rigid)
                        impactFeedbackGenerator.prepare()
                        impactFeedbackGenerator.impactOccurred()
                        // play random goal sound
                        let index = Int.random(in: 0..<GoalSounds.count)
                        sessionModel.audio.playAudio(soundName: GoalSounds[index], fileType: "mp3")
                    }label: {
                        Rectangle().stroke(ColorPalette.primaryText, lineWidth: 5).overlay {
                            VStack{
                                Text("GOAL").font(Font.custom("Play-Bold", size: 25))
                                Image(systemName: "speaker.wave.3.fill")
                            }.foregroundStyle(Color.white)
                        }.background(ColorPalette.primaryForeground)
                    }
                }.frame(width: .infinity, height: 75)
            case .restarting:
                Text("Game Starts Soon").font(Font.custom("Orbitron-Regular", size: 18)).foregroundStyle(ColorPalette.primaryText)
            }
            
        }.offset(y: -225).padding(.horizontal, 40)
    }
    
    @ViewBuilder
    func SoundBoardTab() -> some View {
        ZStack{
            ColorPalette.primaryBackground.ignoresSafeArea()
            VStack{
                RectangularProgressView(progress: $sessionModel.gameProgress).frame(width: .infinity, height: 200).overlay {
                    VStack(spacing:3){
                        Text(sessionModel.gameState == .restarting ? sessionModel.transitionSecondsRemaining.asTimestamp : sessionModel.gameSecondsRemaining.asTimestamp).font(Font.custom("Play-Bold", size: 55)).foregroundStyle(ColorPalette.primaryText)
                        TimerControls(offset: 0).padding(.bottom)
                    }
                }.padding(.all, 25)
                SoundBoardView().padding(.bottom)
                
            }
            
        }
    }
    
    @ViewBuilder
    func SettingsSheet() -> some View {
        Form{
            Section {
                Picker("Game Length", selection: $sessionModel.config.gameLength) {
                    Text("3 minutes").tag(180)
                    Text("4 minutes").tag(240)
                    Text("5 minutes").tag(300)
                    Text("6 minutes").tag(360)
                }
                Stepper(value: $sessionModel.config.transitionLength, in: 5...30) {
                    Text("\(sessionModel.config.transitionLength) seconds between games")
                }
                
                Toggle(isOn: $sessionModel.config.countDown, label: {
                    Text("10 second end of game count down")
                })
                
            } header: {
                Text("Settings")
            }
        }
    }
}

enum SessionTab {
    case timer
    case soundBoard
}

var GoalSounds = ["astonishing", "oh-yes", "breathtaking", "GolGolGol", "GOAL", "SIUUU", "aguero"]

#Preview {
    SessionView().environmentObject(SessionViewModel())
}
