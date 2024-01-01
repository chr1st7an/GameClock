//
//  ContentView.swift
//  GameClock
//
//  Created by Christian Rodriguez on 4/28/23.
//

import SwiftUI
import UserNotifications

struct ContentView: View {
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
            .environmentObject(sessionModel).environmentObject(settings)
            .onReceive(NotificationCenter.default.publisher(for: UIApplication.willTerminateNotification)) { _ in
                        // App is about to terminate
                        // Add your code here to execute a function before termination
                        print("App is about to terminate")
                        sessionModel.cancelAllNotifications()
                    }
    }
}
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
