//
//  HomeView.swift
//  GameClock
//
//  Created by Christian Rodriguez on 4/28/23.
//

import SwiftUI

struct HomeView: View {
    @Environment(\.colorScheme) var colorScheme
    @AppStorage("isDarkMode") private var isDarkMode = false
    
    @EnvironmentObject var model : TimerViewModel
    
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
                }
                .onAppear {
                    if model.sessionLengthSeconds == 0 {
                        model.sessionLengthSeconds = 3600
                    }
                    if model.gameLengthSeconds == 0 {
                        model.gameLengthSeconds = 240
                    }
                    if model.bufferLengthSeconds == 0 {
                        model.bufferLengthSeconds = 15
                    }

                }
            
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
