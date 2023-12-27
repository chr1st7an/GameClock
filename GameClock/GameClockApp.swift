//
//  GameClockApp.swift
//  GameClock
//
//  Created by Christian Rodriguez on 4/28/23.
//

import SwiftUI

@main
struct GameClockApp: App {
    @AppStorage("isDarkMode") private var isDarkMode = false
    
    var body: some Scene {
        WindowGroup {
            ContentView().preferredColorScheme(isDarkMode ? .dark : .light)
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
