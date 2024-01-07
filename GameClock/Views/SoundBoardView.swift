//
//  SoundBoardView.swift
//  GameClock
//
//  Created by Christian Rodriguez on 6/2/23.
//

import SwiftUI

struct SoundBoardView: View {
//    private var favSounds: [String] = ["SIUUU"]
    @EnvironmentObject var sessionModel : SessionViewModel
    @AppStorage("favoriteSounds") private var favoriteData : Data = Data()
    @State var favoriteSounds : [String] = [String]()
    
    @State var editingFavorites = false
    @State var showingFavorites = true
    @State var showingGoal = true
    @State var showingCrowd = true
    @State var showingCommentary = true
    @State var showingOther = true
    
    var body: some View {

            VStack(spacing: 0) {
                
                ScrollView(.vertical){
                    soundPanel(editingFavorites: $editingFavorites, toggleVal: $showingFavorites, favoriteSounds: $favoriteSounds, header: "Favorites", soundSet: favoriteSounds, iconName: "star")
                    soundPanel(editingFavorites: $editingFavorites, toggleVal: $showingGoal, favoriteSounds: $favoriteSounds, header: "Goal", soundSet: goalSounds, iconName: "soccerball")
                    soundPanel(editingFavorites: $editingFavorites, toggleVal: $showingCommentary, favoriteSounds: $favoriteSounds, header: "Commentary", soundSet: commentarySounds, iconName: "music.mic")
                    soundPanel(editingFavorites: $editingFavorites, toggleVal: $showingCrowd, favoriteSounds: $favoriteSounds, header: "Crowd", soundSet: crowdSounds, iconName: "sportscourt.fill")
                    soundPanel(editingFavorites: $editingFavorites, toggleVal: $showingOther, favoriteSounds: $favoriteSounds, header: "Other", soundSet: otherSounds, iconName: "person.wave.2.fill")
                }
            }
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
struct soundPanel: View{
    @Binding var editingFavorites : Bool
    @Binding var toggleVal : Bool
    @Binding var favoriteSounds : [String]
    var header: String
    var soundSet : [String]
    var iconName: String
    var body: some View{
        VStack(spacing: 10){
            HStack{
                Text(header).font(Font.custom("Play-Regular", size: 20))
                Image(systemName: iconName)
                Spacer()
                Button {
                    withAnimation(.easeIn) {
                        toggleVal.toggle()
                    }
                } label: {
                    Text(toggleVal ? "hide" : "show").font(Font.custom("Play-Bold", size: 13)).foregroundStyle(ColorPalette.secondaryText)
                }
            }.padding(.horizontal, 5)
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
                                .padding(.horizontal).padding(.top)
                                Text(editingFavorites ? "save" : "edit").font(Font.custom("Play-Regular", size: 15))
                            }.foregroundStyle(ColorPalette.primaryText)
                        }
                        ForEach(soundSet, id: \.self) { sound in
                            soundButton(soundName: sound, editingFavorites: $editingFavorites, favoriteSounds: $favoriteSounds)
                        }
        
                    }
                }
            }
            
        }.padding()
    }
}
struct soundButton: View {
    @EnvironmentObject var sessionModel : SessionViewModel
    var soundName: String
    @Binding var editingFavorites : Bool
    @Binding var favoriteSounds : [String]
    
    var body: some View{
        VStack {
            Button {
                let impact = UIImpactFeedbackGenerator(style: .medium)
                impact.impactOccurred()
                if editingFavorites{
                    if favoriteSounds.contains(soundName) {
                        withAnimation {
                            favoriteSounds = favoriteSounds.filter { $0 != soundName }
                        }
                    }else{
                        withAnimation{
                            favoriteSounds.append(soundName)
                        }
                    }
                }else{
                    sessionModel.audio.playAudio(soundName: soundName, fileType: "mp3")
                }
            }label: {
                ZStack{
                    Circle().stroke(ColorPalette.secondaryForeground, lineWidth: 2).frame(width: 50).overlay{
                        Circle().foregroundStyle(ColorPalette.secondaryBackground).frame(width: 50)
                    }
                    if editingFavorites{
                        if favoriteSounds.contains(soundName) {
                            Image(systemName:"minus")
                        }else{
                            Image(systemName:"plus")
                        }
                    }else{
                        Image(systemName: "waveform")
                    }
                }.foregroundStyle(.white)
            }
            .padding(.horizontal).padding(.top)
            Text(soundName).fontWeight(.light).font(Font.custom("Orbitron-Regular", size: 10)).padding(5)
        }.foregroundStyle(ColorPalette.primaryText)
    }
}
let goalSounds = ["aguero","stadium-goal","GOAL", "SIUUU", "GolGolGol"]
let crowdSounds = ["champions-league","Defense-chant", "OleOleOle", "Booing", "Victory-chant"]
let commentarySounds = ["astonishing", "breathtaking","oh-yes", "dream", "Ankara-Messi", "What-a-Save"]
let otherSounds = ["Sirens", "zlatan", "lebron-james", "jose-mourinho", "anime-wow", "bobo", "womp-womp", "airhorn"]

struct SoundBoardView_Previews: PreviewProvider {
    static var previews: some View {
        SoundBoardView()
    }
}
