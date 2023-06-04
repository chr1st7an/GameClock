//
//  ContentView.swift
//  GameClock
//
//  Created by Christian Rodriguez on 4/28/23.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var model = TimerViewModel()
    var body: some View {
            ZStack{
                if model.sessionState == .ended {
                    HomeView()
                }else{
                    TimerView()
                }
            }
            .environmentObject(model)
    }
}
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
