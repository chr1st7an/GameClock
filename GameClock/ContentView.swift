//
//  ContentView.swift
//  GameClock
//
//  Created by Christian Rodriguez on 4/28/23.
//

import SwiftUI
import UserNotifications

struct ContentView: View {
    @Environment(\.colorScheme) private var scheme
    @StateObject private var sessionModel = SessionViewModel()
    @StateObject private var settings = SettingsViewModel()

    var body: some View {
            ZStack{
                if sessionModel.sessionState == .ended {
                    HomeView().transition(.move(edge: .leading))
                }else{
                    SessionView().transition(.move(edge: .bottom))
                }
            }
            .preferredColorScheme(getPreferredColorScheme())
            .environmentObject(sessionModel).environmentObject(settings)
    }
    
    private func getPreferredColorScheme() -> ColorScheme? {
        switch settings.colorPreference {
        case "light":
            return .light
        case "dark":
            return .dark
        default:
            return nil
        }
    }
    
}
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
