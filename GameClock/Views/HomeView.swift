//
//  HomeView.swift
//  GameClock
//
//  Created by Christian Rodriguez on 4/28/23.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var model : TimerViewModel
    @Environment(\.colorScheme) var colorScheme
    // USER SETTINGS
    @AppStorage("isDarkMode") private var isDarkMode = false
    @AppStorage("gameMinutes") private var gameMinutes = 4
    @AppStorage("isAutoReplay") private var isAutoReplay = false
    @AppStorage("countdown") private var countdown = false
    @AppStorage("replayDelay") private var bufferLengthInSeconds = 15
    @State var notifications : Bool = false
    @State var showQuickSettings : Bool = false

    var body: some View {
                VStack(spacing: 20){
                    Spacer()
                    // Title
                    VStack{
                        Image(colorScheme == .light ? "STFC_Header_light" : "STFC_HEADER_dark").resizable().frame(width: 350,height: 60)
                        Text("GAME CLOCK").font(.custom(
                            "RobotoRound",
                            fixedSize: 44))
                    }
                    
                    Spacer()
                    // Start
                    VStack{
                        Button {
                            let impact = UIImpactFeedbackGenerator(style: .heavy)
                            model.gameLengthSeconds = gameMinutes * 60
                            impact.impactOccurred()
                            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
                                print(success ? "Authorization success" : "Authorization failed")
                                print(error?.localizedDescription ?? "")
                            }
                            withAnimation{
                                model.sessionState = .active
                                model.loopState = .active
                                model.buffering = true
                            }
                        } label: {
                            Image(systemName: "sportscourt").resizable().frame(width: 150, height: 90).foregroundColor(STFCpink).shadow(radius: 0.5)
                        }
                        Text("tap to start session").font(.custom(
                            "RobotoRound",
                            fixedSize: 15)).padding(.top)
                    }
                    
                    Spacer()
                    // Settings
                    VStack{
                        Button {
                            withAnimation{
                                showQuickSettings.toggle()
                            }
                        } label: {
                            HStack{
                                Text("Session Settings")
                                Image(systemName: showQuickSettings ? "chevron.up" : "chevron.down")
                            }.foregroundColor(STFCgreen)
                        }

                        if showQuickSettings {
                            Form{
                                Section {
                                    Picker("Session Length", selection: $model.sessionLengthSeconds) {
                                            Text("1 hour").tag(3600)
                                            Text("1.5 hours").tag(5400)
                                            Text("2 hours").tag(7200)
                                        }
                                    Stepper(value: $bufferLengthInSeconds, in: 5...30) {
                                        Text("\(bufferLengthInSeconds) seconds between games")
                                    }
                                    Stepper(value: $gameMinutes, in: 1...10) {
                                        Text("\(gameMinutes) minute games")
                                    }
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
                                    Toggle(isOn: $model.tips) {
                                        Text("Receive game captaining tips")
                                    }
                                } header: {
                                    Text("Session Settings")
                                }
    //                        footer: {
    //                                VStack(alignment: .leading) {
    //                                    Text("Low: 90 sec, 30 sec")
    //                                    Text("Medium: 2 min, 1 min, 30 sec")
    //                                    Text("High: 3 min, 2 min, 90 sec, 1 min, 30 sec")
    //                                }.fontWeight(.light)
    //                            }
                            }
                        }
                    }
                    Spacer()
                }
            
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
