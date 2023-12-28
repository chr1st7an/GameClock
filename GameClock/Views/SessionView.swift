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
    var body: some View {
        NavigationStack{
            ZStack{
                ColorPalette.primaryBackground.ignoresSafeArea()
                TabView(selection: $selectedTab){
                    TimerView().tag(SessionTab.timer)
                    SoundBoardView().tag(SessionTab.soundBoard)
                    // add settings, rules, etc
                }.tabViewStyle(.page(indexDisplayMode: .always)).ignoresSafeArea(edges: .bottom)
            }.toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button{
                        withAnimation{
                            sessionModel.sessionState = .ended
                            sessionModel.gameState = .paused
                            sessionModel.endGame()
                            sessionModel.transitionState = .pause
                        }
                    }label: {
                        Rectangle().stroke(lineWidth: 1.5).frame(width: 150, height: 40).foregroundStyle(.foreground).overlay {
                            Text("End Session").foregroundStyle(.red)
                        }
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    HStack{
                        Button{
                            // show app infographic, suggested rules
                        }label: {
                            Image(systemName: "info.circle").resizable().frame(width: 25, height: 25).foregroundStyle(ColorPalette.primaryText)
                        }
                        Button{
                            // show in-session settings
                        }label: {
                            Image(systemName: "gear").resizable().frame(width: 25, height: 25).foregroundStyle(ColorPalette.primaryText)
                        }
                    }
                }
            }
        }
        .onChange(of: scenePhase) { newPhase in
                        if newPhase == .inactive {
                            print("Inactive")
                        } else if newPhase == .active {
                            print("Active")
                        } else if newPhase == .background {
                            print("Background")
                        }
                    }
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
                Text(sessionModel.gameState == .restarting ? sessionModel.transitionSecondsRemaining.asTimestamp : sessionModel.gameSecondsRemaining.asTimestamp).font(Font.custom("Play-Bold", size: 30)).foregroundStyle(ColorPalette.primaryText)
            }
            TimerControls()
        }.padding()
    }
    
    @ViewBuilder
    func TimerControls() -> some View{
            ZStack{
                Rectangle().frame(width: .infinity, height: 75).foregroundStyle(ColorPalette.primaryBackground).shadow(color: ColorPalette.secondaryText, radius: 8, x: 0, y: 5)
                HStack(spacing:5){
                    Button{
                        withAnimation {
                            sessionModel.gameSecondsRemaining -= 10
                        }
                    }label: {
                        Rectangle().stroke(ColorPalette.primaryText, lineWidth: 5).overlay {
                            Text("-10").font(Font.custom("Play-Bold", size: 30)).foregroundStyle(.red)
                        }
                    }
                    Button{
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
                        withAnimation {
                            sessionModel.gameSecondsRemaining += 10
                        }
                    }label: {
                        Rectangle().stroke(ColorPalette.primaryText, lineWidth: 5).overlay {
                            Text("+10").font(Font.custom("Play-Bold", size: 30)).foregroundStyle(ColorPalette.secondaryBackground)
                        }
                    }
                }.frame(width: .infinity, height: 75)
            }.offset(y: 225).padding(.horizontal, 40)

    }
    
    @ViewBuilder
    func SoundBoardView() -> some View {
        ZStack{
            ColorPalette.secondaryBackground.ignoresSafeArea()
            Text("Soundboard here")
        }
    }
}

enum SessionTab {
    case timer
    case soundBoard
}
#Preview {
    SessionView().environmentObject(SessionViewModel())
}
