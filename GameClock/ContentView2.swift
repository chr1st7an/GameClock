//
//  ContentView2.swift
//  GameClock
//
//  Created by Christian Rodriguez on 12/18/23.
//

import SwiftUI

struct ContentView2: View {
    @StateObject private var timerVm = TimerViewModel()
    @StateObject private var routes = Routes()

    var body: some View {
        VStack{
            Text("GAME CLOCK").font(.custom(
                "RobotoRound",
                fixedSize: 44))
            Button {
                routes.navigation.append(.session)
            } label: {
                VStack{
                    Image(systemName: "sportscourt").resizable().frame(width: 150, height: 90).foregroundColor(.black).shadow(radius: 0.5)
                    Text("tap to start session").font(.custom(
                        "RobotoRound",
                        fixedSize: 15))
                }
            }
        }

    }
}

#Preview {
    ContentView2().environmentObject(Routes()).environmentObject(TimerViewModel())
}
