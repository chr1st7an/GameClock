//
//  SoundBoardView.swift
//  GameClock
//
//  Created by Christian Rodriguez on 6/2/23.
//

import SwiftUI

struct SoundBoardView: View {
    @EnvironmentObject var model : TimerViewModel
    @State var showingGoal = true
    @State var showingCrowd = true
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                ScrollView(.vertical){
                    VStack(spacing: 15){
                        HStack{
                            Text("Goal").font(.custom(
                                "RobotoRound",
                                fixedSize: 28))
                            Spacer()
                            Button {
                                withAnimation(.easeIn) {
                                    showingGoal.toggle()
                                }
                            } label: {
                                Text(showingGoal ? "hide" : "show")
                            }
                        }.padding(.horizontal, 25)
                        if showingGoal{
                            ScrollView(.horizontal){
                                HStack{
                                    ForEach(values: goalSounds) { name in
                                        soundButton(soundName: name)
                                    }
                                }
                            }
                        }
                    }.padding()
                    VStack(spacing: 15){
                        HStack{
                            Text("Crowd").font(.custom(
                                "RobotoRound",
                                fixedSize: 28))
                            Spacer()
                            Button {
                                withAnimation(.easeIn) {
                                    showingCrowd.toggle()
                                }
                            } label: {
                                Text(showingCrowd ? "hide" : "show")
                            }
                        }.padding(.horizontal, 25)
                        if showingCrowd{
                            ScrollView(.horizontal){
                                HStack{
                                    ForEach(values: crowdSounds) { name in
                                        soundButton(soundName: name)
                                    }
                                }
                            }
                        }
                    }.padding()
                }
            }
            .navigationTitle("Sound Board")
        }
    }
}
struct soundButton: View {
    @EnvironmentObject var model : TimerViewModel
    var soundName: String
    var body: some View{
        
        Button {
            let impact = UIImpactFeedbackGenerator(style: .medium)
            impact.impactOccurred()
            model.audio.playAudio(soundName: soundName)
        }label: {
            Image(systemName: "waveform.circle")
        }
        .buttonStyle(SoundButtonStyle1())
        .padding()
    }
}
let goalSounds = ["goal", "aguero"]
let crowdSounds = ["defense_chant", "ole"]

struct SoundBoardView_Previews: PreviewProvider {
    static var previews: some View {
        SoundBoardView()
    }
}
