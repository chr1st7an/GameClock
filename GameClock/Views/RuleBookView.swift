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
                    ruleSection(toggleVal:$showingFormat,header: "Format", ruleSet: format, iconName: "sportscourt.fill")
                    ruleSection(toggleVal:$showingRules,header: "Rules", ruleSet: rules, iconName: "figure.soccer")
                    ruleSection(toggleVal:$showingTeams,header: "Teams", ruleSet: teams, iconName: "person.3.sequence.fill")
                    ruleSection(toggleVal:$showingTips,header: "Captain Tips", ruleSet: gameCaptainTips, iconName: "person.badge.shield.checkmark")
                      }
            }.navigationTitle("Rule Book")
        }
    }
}
struct ruleSection: View{
    @Binding var toggleVal: Bool
    var header: String
    var ruleSet : [String]
    var iconName: String
    var body: some View{
        VStack(spacing:20){
            VStack {
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
                }.padding(.horizontal, 25).padding(.top)
                Divider().padding(.horizontal)
            }.padding(.bottom, -20)
            if toggleVal{
                ForEach(values: ruleSet) { rule in
                    ruleCard(rule: rule).padding(.vertical)
                }
            }
            
        }.padding()
    }
}
struct ruleCard: View{
    let rule : String
    var body: some View{
        GeometryReader{proxy in
            HStack{
                Image(systemName: "minus").foregroundColor(.gray)
                Text(rule).font(.custom(
                    "RobotoRound",
                    fixedSize: 14)).lineLimit(4).multilineTextAlignment(.leading).fixedSize(horizontal: false, vertical: true)
            }.padding(.horizontal).frame(width: proxy.size.width * 1, height: 50, alignment: .leading)
                .background {
                    Capsule().fill(STFCgreen.opacity(0.3)).offset(x: -(proxy.size.width * 0.09) / 2).clipped()                }
//                .background(STFCgreen.opacity(0.2), in: Capsule())
        }
    }
}

extension ForEach where Data.Element: Hashable, ID == Data.Element, Content: View {
    init(values: Data, content: @escaping (Data.Element) -> Content) {
        self.init(values, id: \.self, content: content)
    }
}

let format = [
    "Each match is 1 hour long", "Each game is 4 mins long","Games end after 4 mins or after one team scores 3 goals","Winner stays on","In case of tie, newest team stays on", "No goalies","No PKs","We play as many games as possible during a 1 hour match"
]
let teams = [
    "There are 3 teams per match","Each teams is made up of either 4 of 5 players (depending on court size)","Maximum of 15 players/match", "If there are too few players to make up 3 even teams, members of losing team can join the team coming on",
    
    "If the number of players drop, the following scenarios can happen:",

    "15 Players = 3 teams of 5",

    "12 Players = 3 teams of 4",

    "10-11 Players = 2 teams of 4, 1 incomplete team who borrows players from losing team",

    "8-9 Players = 2 Teams of 4 with 1 player being replaced from losing team by player waiting",

    "Less than 8 Players = Match is abandoned below 8 players"
]
let rules = [
    "All goals must be scored over halfway line",

    "All stoppages are restarted with kick-ins",

    "Kick-ins after goals should be taken from between goal posts",

    "Handball when ball is going into goal counts as a goal",
    
    "Foul that denies clear goal counts as a goal",
    
    "Players can score directly from corner kicks",

    "Killer Goal: if the first goal of a game is a one-touch shot / header from an aerial pass, the scoring team automatically wins the game",

]
let numbers = [
    "If there are too few players to make up 3 even teams, members of losing team can join the team coming on",

    "If the number of players drop, the following scenarios can happen:",

    "15 Players = 3 teams of 5",

    "12 Players = 3 teams of 4",

    "10-11 Players = 2 teams of 4, 1 incomplete team who borrows players from losing team",

    "8-9 Players = 2 Teams of 4 with 1 player being replaced from losing team by player waiting",

    "Less than 8 Players = Match is abandoned below 8 players"

]
let gameCaptainTips = [
"Start the session off by bringing players in to welcome new members, remind them of rules, and congratulate players on milestones",
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
