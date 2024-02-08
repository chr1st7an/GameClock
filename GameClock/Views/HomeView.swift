//
//  HomeView.swift
//  GameClock
//
//  Created by Christian Rodriguez on 12/26/23.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var sessionModel : SessionViewModel
    @EnvironmentObject var settings : SettingsViewModel
    @State var showSettings = false

    var body: some View {
        ZStack{
            ColorPalette.secondaryBackground.ignoresSafeArea()
            VStack(spacing:50){
                Spacer()
                TitleBanner()
                Spacer()
                StartButton()
                UserAgreement()
            }.safeAreaInset(edge: .bottom) {
                Banner(bannerID: homeBanner1, width: 400)
            }
            .safeAreaInset(edge: .top) {
                Banner(bannerID: homeBanner2, width: 400)
            }
        }.sheet(isPresented: $showSettings, content: {
            SettingsSheet()
        })
    }
    @ViewBuilder
    func TitleBanner() -> some View {
        VStack(spacing:10){
            Text("Game Clock").font(Font.custom("Orbitron-Regular", size: 50)).foregroundStyle(ColorPalette.primaryText)
            Image("LightIcon").resizable().frame(width: 80, height: 95)
        }
    }
        
    @ViewBuilder
    func StartButton() -> some View {
        VStack(spacing:15){
            Button{
                let impactFeedbackGenerator = UIImpactFeedbackGenerator(style: .heavy)
                impactFeedbackGenerator.prepare()
                impactFeedbackGenerator.impactOccurred()
                let config = SessionConfig(sessionLength: settings.sessionLength, gameLength: settings.gameLength, transitionLength: settings.transitionLength, countDown: settings.countDown, colorPreference: settings.colorPreference)
                withAnimation {
                    sessionModel.sessionState = .start(config)
                    sessionModel.gameState = .start
                }
            }label: {
                Rectangle().stroke(lineWidth: 5).frame(width: .infinity, height: 50).foregroundStyle(ColorPalette.primaryText).overlay {
                        Text("Start Session").font(Font.custom("Play-Bold", size: 23)).foregroundStyle(ColorPalette.primaryText)
                }.background(ColorPalette.primaryBackground.opacity(0.8))
                    .padding(.horizontal, 85)
            }
            SettingsButton()
        }
    }
    @ViewBuilder
    func UserAgreement() -> some View {
        HStack{
            Image(systemName: "info.circle").resizable().frame(width: 22, height: 22).foregroundStyle(ColorPalette.secondaryText)
            Text("By starting a session you are agreeing to receiving notifications over the course of the session length that emit audio announcements.").font(Font.custom("Play-Regular", size: 10)).foregroundStyle(ColorPalette.secondaryText)            }.padding()

    }
    
    @ViewBuilder
    func SettingsButton() -> some View {
        Button{
            withAnimation {
                showSettings = true
            }
        }label: {
            HStack{
                Image(systemName: "gear").resizable().frame(width: 25, height: 25)
                Text("Settings").font(Font.custom("Play-Regular", size: 20))
            }.foregroundStyle(ColorPalette.secondaryForeground)
        }
    }
    
    @ViewBuilder
    func SettingsSheet() -> some View {
        Form{
            Section {
                Picker("Session Length", selection: $settings.sessionLength) {
                    Text("1 hour").tag(3600)
                    Text("1.5 hours").tag(5400)
                    Text("2 hours").tag(7200)
                }
                Picker("Game Length", selection: $settings.gameLength) {
                    Text("3 minutes").tag(180)
                    Text("4 minutes").tag(240)
                    Text("5 minutes").tag(300)
                    Text("6 minutes").tag(360)
                }
                Stepper(value: $settings.transitionLength, in: 5...30) {
                    Text("\(settings.transitionLength) seconds between games")
                }
                Toggle(isOn: $settings.countDown, label: {
                    Text("10 second end of game count down")
                })
            } header: {
                Text("Session Settings")
            }
            Section {
                Picker("Color Palette", selection: $settings.colorPreference) {
                    Text("System").tag("system")
                    Text("Light").tag("light")
                    Text("Dark").tag("dark")
                }.pickerStyle(.segmented)
            } header: {
                Text("Appearance")
            }
        }
    }
    
    
    
}

#Preview {
    HomeView().environmentObject(SessionViewModel()).environmentObject(SettingsViewModel())
}
