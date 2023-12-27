//
//  HomeView.swift
//  GameClock
//
//  Created by Christian Rodriguez on 12/26/23.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var sessionModel : SessionViewModel
    @State var showSettings = false

    var body: some View {
        ZStack{
            ColorPalette.secondaryBackground.ignoresSafeArea()
            VStack(spacing:100){
                Spacer()
                TitleBanner()
                Spacer()
                StartButton()
                UserAgreement()
            }
        }.sheet(isPresented: $showSettings, content: {
            
        })
    }
    @ViewBuilder
    func TitleBanner() -> some View {
        VStack(spacing:10){
            Text("Game Clock").font(Font.custom("Orbitron-Regular", size: 50)).foregroundStyle(ColorPalette.primaryText)
            Image("LightIcon").resizable().frame(width: 75, height: 95)
        }
    }
        
    @ViewBuilder
    func StartButton() -> some View {
        VStack(spacing:15){
            Button{
                withAnimation {
                    sessionModel.sessionState = .active
                }
            }label: {
                Rectangle().stroke(lineWidth: 5).frame(width: .infinity, height: 50).foregroundStyle(ColorPalette.primaryText).overlay {
                        Text("Start Session").font(Font.custom("Play-Bold", size: 23)).foregroundStyle(ColorPalette.primaryText)
                }.background(ColorPalette.primaryBackground.opacity(0.8))
                    .padding(.horizontal, 85)
            }
            SettingsButton()
        }
    }
    @ViewBuilder
    func UserAgreement() -> some View {
        HStack{
            Image(systemName: "info.circle").resizable().frame(width: 22, height: 22).foregroundStyle(ColorPalette.secondaryText)
            Text("By starting a session you are agreeing to receiving notifications over the course of the session length that emit audio announcements.").font(Font.custom("Play-Regular", size: 10)).foregroundStyle(ColorPalette.secondaryText)            }.padding()

    }
    
    @ViewBuilder
    func SettingsButton() -> some View {
        Button{
            withAnimation {
                showSettings = true
            }
        }label: {
            HStack{
                Image(systemName: "gear").resizable().frame(width: 25, height: 25)
                Text("Settings").font(Font.custom("Play-Regular", size: 20))
            }.foregroundStyle(ColorPalette.secondaryForeground)
        }
    }
    
    
    
}

#Preview {
    HomeView().environmentObject(SessionViewModel())
}
