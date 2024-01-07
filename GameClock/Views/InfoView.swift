//
//  InfoView.swift
//  GameClock
//
//  Created by Christian Rodriguez on 1/5/24.
//

import SwiftUI

struct InfoView: View {
    @EnvironmentObject var sessionModel : SessionViewModel
    @EnvironmentObject var settings : SettingsViewModel
    
    var body: some View {
        VStack{
            VStack(spacing:10){
                Text("You are currently running a \(settings.sessionLength / 60) minute session with \(settings.gameLength / 60) minute games and \(settings.transitionLength) second transitions.").font(Font.custom("Play-Bold", size: 20)).foregroundStyle(ColorPalette.primaryText).frame(maxWidth: .infinity, alignment: .leading)
                
                Text("Listen out for timer updates.").font(Font.custom("Play-Regular", size: 15)).foregroundStyle(ColorPalette.primaryText).frame(maxWidth: .infinity, alignment: .leading)
                Text("Use the sound board for an immersive experience.").font(Font.custom("Play-Regular", size: 20)).foregroundStyle(ColorPalette.primaryText).frame(maxWidth: .infinity, alignment: .leading)
            }.padding()
            Divider()
            Text("For an ideal Experience").font(Font.custom("Orbitron-Regular", size: 25))
                VStack(spacing: 5){
                    Text("1. Ensure your device is sufficiently charged and volume is raised.")
                        .font(Font.custom("Play-Regular", size: 15))
                        .frame(maxWidth: .infinity, alignment: .leading)

                    Text("2. Enable notifications and disable device auto lock to keep display on.")
                        .font(Font.custom("Play-Regular", size: 15))
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Text("Settings>Display & Brightness>Auto Lock")
                        .font(Font.custom("Play-Bold", size: 10))
                        .padding(.leading, 15)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Text("3. Keep the app open for as much of the session as possible.")
                        .font(Font.custom("Play-Regular", size: 15))
                        .frame(maxWidth: .infinity, alignment: .leading)

                }.foregroundStyle(ColorPalette.secondaryText)
                    .padding()
            
            Divider()
            Text("Troubleshooting").font(Font.custom("Orbitron-Regular", size: 25))
            ScrollView(.vertical){
                VStack(spacing:10){
                    HStack{
                        Image(systemName: "magnifyingglass")
                        Text("Why aren't the announcements sounding?").font(Font.custom("Play-Bold", size: 15))
                    }.foregroundStyle(ColorPalette.secondaryText)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Text("Either your device's volume is too low or muted")
                        .font(Font.custom("Play-Regular", size: 13))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.bottom)
                    HStack{
                        Image(systemName: "magnifyingglass")
                        Text("Why don't I receive any timer update when my phone is off or not on the app.").font(Font.custom("Play-Bold", size: 15))
                    }.foregroundStyle(ColorPalette.secondaryText)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Text("Enable notifications from this app in your device's settings. Settings>Notifications>Game Clock>Allow Notifications")
                        .font(Font.custom("Play-Regular", size: 13))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.bottom)

                    HStack{
                        Image(systemName: "magnifyingglass")
                        Text("Im getting timer notifications, but I cant hear the sounds.").font(Font.custom("Play-Bold", size: 15))
                    }.foregroundStyle(ColorPalette.secondaryText).frame(maxWidth: .infinity, alignment: .leading)
                    Text("Check your device's Focus Mode. Notification sounds may be muted if it is enabled.")
                        .font(Font.custom("Play-Regular", size: 13))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.bottom)
                }.padding()
            }
        }
    }
}

#Preview {
    InfoView().environmentObject(SessionViewModel()).environmentObject(SettingsViewModel())
}
