//
//  SessionView.swift
//  GameClock
//
//  Created by Christian Rodriguez on 12/18/23.
//

import SwiftUI

struct SessionView: View {
    @EnvironmentObject var routes : Routes
    @EnvironmentObject var timerVm : TimerViewModel()
    var body: some View {
        NavigationStack(path: $routes.navigation) {
            VStack{
                
            }.navigationDestination(for: NavDestination.self) { destination in
                switch destination{
                    case .session:
                        SessionView()
                    case .settings:
                        SessionView()
                }
            }
        }   
    }
}

#Preview {
    SessionView()
}
