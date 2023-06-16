//
//  SoundBoardView.swift
//  GameClock
//
//  Created by Christian Rodriguez on 6/2/23.
//

import SwiftUI

struct SoundBoardView: View {
//    private var favSounds: [String] = ["SIUUU"]
    @EnvironmentObject var model : TimerViewModel
    @AppStorage("favoriteSounds") private var favoriteData : Data = Data()
    @State var favoriteSounds : [String] = [String]()
    
    @State var editingFavorites = false
    @State var showingFavorites = true
    @State var showingGoal = true
    @State var showingCrowd = true
    @State var showingCommentary = true
    @State var showingOther = true
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                ScrollView(.vertical){
                    soundPanel(editingFavorites: $editingFavorites, toggleVal: $showingFavorites, favoriteSounds: $favoriteSounds, header: "Favorites", soundSet: favoriteSounds, iconName: "star")
                    soundPanel(editingFavorites: $editingFavorites, toggleVal: $showingGoal, favoriteSounds: $favoriteSounds, header: "Goal", soundSet: goalSounds, iconName: "soccerball")
                    soundPanel(editingFavorites: $editingFavorites, toggleVal: $showingCommentary, favoriteSounds: $favoriteSounds, header: "Commentary", soundSet: commentarySounds, iconName: "music.mic")
                    soundPanel(editingFavorites: $editingFavorites, toggleVal: $showingCrowd, favoriteSounds: $favoriteSounds, header: "Crowd", soundSet: crowdSounds, iconName: "sportscourt.fill")
                    soundPanel(editingFavorites: $editingFavorites, toggleVal: $showingOther, favoriteSounds: $favoriteSounds, header: "Other", soundSet: otherSounds, iconName: "person.wave.2.fill")
                }
            }
            .navigationTitle("Sound Board")
            .onChange(of: favoriteSounds) { favs in
                print(favoriteSounds)
                guard let favorites = try? JSONEncoder().encode(favs) else { return }
                print("encoding and saving")
                self.favoriteData = favorites
                print(favoriteSounds)
            }
            .onAppear {
                guard let decodedRatings = try? JSONDecoder().decode([String].self, from: favoriteData) else { return }
                print(decodedRatings)
                self.favoriteSounds = decodedRatings

            }
        }
    }
}
struct soundPanel: View{
    @Binding var editingFavorites : Bool
    @Binding var toggleVal : Bool
    @Binding var favoriteSounds : [String]
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
                        if header == "Favorites"{
                            VStack {
                            Button {
                                let impact = UIImpactFeedbackGenerator(style: .medium)
                                impact.impactOccurred()
                                withAnimation {
                                    editingFavorites.toggle()
                                }
                            }label: {
                                Image(systemName: editingFavorites ? "xmark" : "square.and.pencil")
                            }
                            .buttonStyle(PlusEdit())
                            .padding(.horizontal).padding(.top)
                            Text(editingFavorites ? "save" : "edit").fontWeight(.light).font(.custom(
                                "RobotoRound",
                                fixedSize: 15)).padding(.bottom)
                        }}
                        ForEach(values: soundSet) { sound in
                            soundButton(soundName: sound, editingFavorites: $editingFavorites, favoriteSounds: $favoriteSounds)
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
    @Binding var editingFavorites : Bool
    @Binding var favoriteSounds : [String]
    
    var body: some View{
        VStack {
            Button {
                let impact = UIImpactFeedbackGenerator(style: .medium)
                impact.impactOccurred()
                if editingFavorites && favoriteSounds.contains(soundName) {
                    let temp = favoriteSounds.filter { $0 != soundName }
                    favoriteSounds = temp
                }
                if editingFavorites && !(favoriteSounds.contains(soundName)){
                    favoriteSounds.append(soundName)
                }else{
                    model.audio.playAudio(soundName: soundName)
                }
            }label: {
                if favoriteSounds.contains(soundName) && editingFavorites {
                    Image(systemName:"minus")
                }else{
                    Image(systemName: editingFavorites && !(favoriteSounds.contains(soundName)) ? "plus" : "waveform.circle")}
            }
            .buttonStyle(SoundButtonStyle1())
            .padding(.horizontal).padding(.top)
            Text(soundName).fontWeight(.light).font(.custom(
                "RobotoRound",
                fixedSize: 15)).padding(.bottom)
        }
    }
}
let goalSounds = ["GOAL", "SIUUU", "GolGolGol"]
let crowdSounds = ["Defense-chant", "OleOleOle", "Booing", "Victory-chant"]
let commentarySounds = ["Martin-Tyler1", "Martin-Tyler2", "Ankara-Messi", "What-a-Save"]
let otherSounds = ["Sirens"]

struct SoundBoardView_Previews: PreviewProvider {
    static var previews: some View {
        SoundBoardView()
    }
}
