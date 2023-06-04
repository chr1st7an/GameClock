//
//  RuleBookView.swift
//  GameClock
//
//  Created by Christian Rodriguez on 6/2/23.
//

import SwiftUI

struct RuleBookView: View {
    @State var showingFormat = true
    @State var showingTeams = true
    @State var showingRules = true
    @State var showingNumbers = true
    @State var showingTips = true
    
    var body: some View {
        NavigationView {
            VStack{
                ScrollView(.vertical) {
                    VStack(spacing: 15){
                        HStack{
                            Text("Format").font(.custom(
                                "RobotoRound",
                                fixedSize: 28))
                            Spacer()
                            Button {
                                withAnimation(.easeIn) {
                                    showingFormat.toggle()
                                }
                            } label: {
                                Text(showingFormat ? "hide" : "show")
                            }
                        }.padding(.horizontal, 25)
                        if showingFormat{
                            ForEach(values: format) { rule in
                                ruleCard(rule: rule)
                            }
                        }
                    }.padding()
                    VStack(spacing: 15){
                        HStack{
                            Text("Rules").font(.custom(
                                "RobotoRound",
                                fixedSize: 28))
                            Spacer()
                            Button {
                                withAnimation(.easeIn) {
                                    showingRules.toggle()
                                }
                            } label: {
                                Text(showingRules ? "hide" : "show")
                            }
                        }.padding(.horizontal, 25)
                        if showingRules{
                            ForEach(values: rules) { rule in
                                ruleCard(rule: rule)
                            }
                        }
                    }.padding()
                    VStack(spacing: 15){
                        HStack{
                            Text("Teams").font(.custom(
                                "RobotoRound",
                                fixedSize: 28))
                            Spacer()
                            Button {
                                withAnimation(.easeIn) {
                                    showingTeams.toggle()
                                }
                            } label: {
                                Text(showingTeams ? "hide" : "show")
                            }
                        }.padding(.horizontal, 25)
                        if showingTeams{
                            ForEach(values: teams) { rule in
                                ruleCard(rule: rule)
                            }
                        }
                    }.padding()
                    VStack(spacing: 15){
                        HStack{
                            Text("Numbers").font(.custom(
                                "RobotoRound",
                                fixedSize: 28))
                            Spacer()
                            Button {
                                withAnimation(.easeIn) {
                                    showingNumbers.toggle()
                                }
                            } label: {
                                Text(showingNumbers ? "hide" : "show")
                            }
                        }.padding(.horizontal, 25)
                        if showingNumbers{
                            ForEach(values: numbers) { rule in
                                ruleCard(rule: rule)
                            }
                        }
                    }.padding()
                    VStack(spacing: 15){
                        HStack{
                            Text("Game Captain Tips").font(.custom(
                                "RobotoRound",
                                fixedSize: 28))
                            Spacer()
                            Button {
                                withAnimation(.easeIn) {
                                    showingTips.toggle()
                                }
                            } label: {
                                Text(showingTips ? "hide" : "show")
                            }
                        }.padding(.horizontal, 25)
                        if showingTips{
                            ForEach(values: gameCaptainTips) { rule in
                                ruleCard(rule: rule)
                            }
                        }
                    }.padding()
                      }
            }.navigationTitle("RuleBook")
        }
    }
}

struct ruleCard: View{
    let rule : String
    var body: some View{
        GeometryReader{proxy in
            HStack{
                Image(systemName: "plus")
                Text(rule)
            }.padding(.horizontal)
        }
    }
}
extension ForEach where Data.Element: Hashable, ID == Data.Element, Content: View {
    init(values: Data, content: @escaping (Data.Element) -> Content) {
        self.init(values, id: \.self, content: content)
    }
}

let format = [
    "Each match is 1 hour long", "Each game is 4 mins long","We play as many games as possible during a 1 hour match","Games end after 4 mins or after one team scores 3 goals","Winner stays on","In case of tie, newest team stays on", "No goalies","No PKs"
]
let teams = [
    "There are 3 teams per match","Each teams is made up of either 4 of 5 players (depending on court size)","Maximum of 15 players/match"
]
let rules = [
    "All goals must be scored over halfway line",

    "All stoppages are restarted with kick-ins (e.g. corners, out of bounds, handball)",

    "Kick-ins after goals should be taken from between goal posts, no further than 3 ft from goal-line",

    "Handball when ball is going into goal / foul that denies clear goal counts as a goal",

    "Killer Goal: When first goal of a game is scored with a one-touch shot / header from an aerial pass without it touching the ground, the scoring team automatically wins the game",

]
let numbers = [
    "If there are too few players to make up 3 even-sized teams, or if there is an injury / late arrival / early departure, members of team coming off (after a loss) can join the team coming on",

    "If the number of players drop, the following scenarios can happen:",

    "15 Players = 3 teams of 5",

    "12 Players = 3 teams of 4",

    "10-11 Players = 2 teams of 4, 1 incomplete team who borrows players from losing team",

    "8-9 Players = 2 Teams of 4 with 1 player being replaced from losing team by player waiting",

    "Less than 8 Players = Match is abandoned below 8 players"

]
let gameCaptainTips = [
"Start the session off by bringing players in reminding them of rules/vibe, welcome new players, congratulate players on milestones",
"When playing remember to keep an ear out for times, and be the first player to come off if needed"
]

struct SectionHeader: View {
  
  @State var title: String
  @Binding var isOn: Bool
  @State var onLabel: String
  @State var offLabel: String
  
  var body: some View {
    Button(action: {
      withAnimation {
        isOn.toggle()
      }
    }, label: {
      if isOn {
        Text(onLabel)
      } else {
        Text(offLabel)
      }
    })
    .font(Font.caption)
    .foregroundColor(.accentColor)
    .frame(maxWidth: .infinity, alignment: .trailing)
    .overlay(
      Text(title),
      alignment: .leading
    )
  }
}
struct RuleBookView_Previews: PreviewProvider {
    static var previews: some View {
        RuleBookView()
    }
}
