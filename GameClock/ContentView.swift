//
//  ContentView.swift
//  GameClock
//
//  Created by Christian Rodriguez on 4/28/23.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var sessionModel = SessionViewModel()
    
    var body: some View {
            ZStack{
                
                if sessionModel.sessionState == .ended {
                    HomeView()
                }else{
                    SessionView()
                }
            }
            .environmentObject(sessionModel)
    }
}
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
