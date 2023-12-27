//
//  SessionView.swift
//  GameClock
//
//  Created by Christian Rodriguez on 12/26/23.
//

import SwiftUI

struct SessionView: View {
    @EnvironmentObject var sessionModel : SessionViewModel
    var body: some View {
        ZStack{
            VStack{
                Text("Session View")
                Button{
                    withAnimation{
                        sessionModel.sessionState = .ended
                    }
                }label: {
                    Rectangle().stroke(lineWidth: 1.5).frame(width: 150, height: 40).foregroundStyle(.foreground).overlay {
                        Text("End Session").foregroundStyle(.red)
                    }
                }
            }
        }
    }
}

#Preview {
    SessionView().environmentObject(SessionViewModel())
}
