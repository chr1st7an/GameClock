//
//  HomeView.swift
//  GameClock
//
//  Created by Christian Rodriguez on 4/28/23.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var model : TimerViewModel
    var body: some View {
            ZStack{
                VStack{
                    Spacer()
                    Image("STFC_Header").resizable().frame(width: 350,height: 60)
                    Text("GAME CLOCK").font(.custom(
                        "RobotoRound",
                        fixedSize: 34))
                    Spacer()
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
                        }
                    } label: {
                        Image(systemName: "sportscourt").resizable().frame(width: 150, height: 90).foregroundColor(STFCpink).shadow(radius: 0.5)
                    }
                    Text("tap to start session").font(.custom(
                        "RobotoRound",
                        fixedSize: 15)).padding(.top)
                    Spacer()
                }
            }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
