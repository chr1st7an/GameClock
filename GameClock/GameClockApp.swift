//
//  GameClockApp.swift
//  GameClock
//
//  Created by Christian Rodriguez on 4/28/23.
//

import SwiftUI

@main
struct GameClockApp: App {
//    @AppStorage("isDarkMode") private var isDarkMode = false
    init(){
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .badge, .providesAppNotificationSettings, .provisional, .sound]) { success, error in
            if success {
                print("All set!")
            } else if let error = error {
                print(error.localizedDescription)
            }
        }
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
//                .preferredColorScheme(isDarkMode ? .dark : .light)
        }
    }
}

enum ColorPalette {
    static let primaryBackground = Color("PrimaryBackground")
    static let secondaryBackground = Color("SecondaryBackground")
    static let primaryForeground = Color("PrimaryForeground")
    static let secondaryForeground = Color("SecondaryForeground")
    static let primaryText = Color("PrimaryText")
    static let secondaryText = Color("SecondaryText")

}

extension Int {
    var asTimestamp: String {
        let hour = self / 3600
        let minute = self / 60 % 60
        let second = self % 60

        return String(format: "%02i:%02i", minute, second)
    }
}

