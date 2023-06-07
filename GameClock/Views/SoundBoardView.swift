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
    @State var showingCommentary = true
    @State var showingOther = true
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                ScrollView(.vertical){
                    soundPanel(toggleVal: $showingGoal, header: "Goal", soundSet: goalSounds, iconName: "soccerball")
                    soundPanel(toggleVal: $showingCommentary, header: "Commentary", soundSet: commentarySounds, iconName: "music.mic")
                    soundPanel(toggleVal: $showingCrowd, header: "Crowd", soundSet: crowdSounds, iconName: "sportscourt.fill")
                    soundPanel(toggleVal: $showingOther, header: "Other", soundSet: otherSounds, iconName: "person.wave.2.fill")
                }
            }
            .navigationTitle("Sound Board")
        }
    }
}
struct soundPanel: View{
    @Binding var toggleVal : Bool
    var header: String
    var soundSet : [String]
    var iconName: String
    var body: some View{
        VStack(spacing: 20){
            HStack{
                Text(header).font(.custom(
                    "RobotoRound",
                    fixedSize: 28))
                Image(systemName: iconName)
                Spacer()
                Button {
                    withAnimation(.easeIn) {
                        toggleVal.toggle()
                    }
                } label: {
                    Text(toggleVal ? "hide" : "show").foregroundColor(STFCpink)
                }
            }.padding(.horizontal, 25)
            Divider().padding(.horizontal)
            if toggleVal{
                ScrollView(.horizontal){
                    HStack{
                        ForEach(values: soundSet) { sound in
                            soundButton(soundName: sound)
                        }
                    }
                }
            }
            
        }.padding()
    }
}
struct soundButton: View {
    @EnvironmentObject var model : TimerViewModel
    var soundName: String
    var body: some View{
        
        VStack {
            Button {
                let impact = UIImpactFeedbackGenerator(style: .medium)
                impact.impactOccurred()
                model.audio.playAudio(soundName: soundName)
            }label: {
                Image(systemName: "waveform.circle")
            }
            .buttonStyle(SoundButtonStyle1())
            .padding(.horizontal).padding(.top)
            Text(soundName).fontWeight(.light).font(.custom(
                "RobotoRound",
                fixedSize: 15)).padding(.bottom)
        }
    }
}
let goalSounds = ["GOAL", "AGUEROOO", "GolGolGol"]
let crowdSounds = ["Defense-chant", "OleOleOle", "Booing", "Victory-chant"]
let commentarySounds = ["Martin-Tyler1", "Martin-Tyler2", "Ankara-Messi", "What-a-Save"]
let otherSounds = ["SIUUU", "Sirens"]

struct SoundBoardView_Previews: PreviewProvider {
    static var previews: some View {
        SoundBoardView()
    }
}
