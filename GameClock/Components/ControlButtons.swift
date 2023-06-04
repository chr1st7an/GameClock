//
//  ControlButtons.swift
//  GameClock
//
//  Created by Christian Rodriguez on 4/28/23.
//

import SwiftUI

struct SoundButtonStyle1: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(width: 80, height: 80)
            .foregroundColor(.black)
            .background(STFCgreen.opacity(0.7))
            .clipShape(Circle())
            .padding(.all, 3)
            .overlay(
                Circle()
                    .stroke(Color(.black)
                        .opacity(0.4), lineWidth: 2)
            )
    }
}
struct SoundButtonStyle2: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(width: 80, height: 80)
            .foregroundColor(.black)
            .background(STFCpink.opacity(0.7))
            .clipShape(Circle())
            .padding(.all, 3)
            .overlay(
                Circle()
                    .stroke(Color(.black)
                        .opacity(0.4), lineWidth: 2)
            )
    }
}
struct SoundButtonStyle3: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(width: 80, height: 80)
            .foregroundColor(.black)
            .background(STFCgreen.opacity(0.7))
            .clipShape(Circle())
            .padding(.all, 3)
            .overlay(
                Circle()
                    .stroke(Color(.black)
                        .opacity(0.4), lineWidth: 2)
            )
    }
}
struct ReplayButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(width: 80, height: 80)
            .foregroundColor(.black)
            .background(STFCgreen.opacity(0.7))
            .clipShape(Circle())
            .padding(.all, 3)
            .overlay(
                Circle()
                    .stroke(Color(.black)
                        .opacity(0.4), lineWidth: 2)
            )
    }
}

struct PlayButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(width: 80, height: 80)
            .foregroundColor(.black)
            .background(STFCpink.opacity(0.3))
            .clipShape(Circle())
            .padding(.all, 3)
            .overlay(
                Circle()
                    .stroke(STFCpink
                        .opacity(0.8), lineWidth: 2)
            )
    }
}
struct PauseButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(width: 80, height: 80)
            .foregroundColor(.black)
            .background(STFCgreen.opacity(0.7))
            .clipShape(Circle())
            .padding(.all, 3)
            .overlay(
                Circle()
                    .stroke(Color(.black)
                        .opacity(0.4), lineWidth: 2)
            )
    }
}
struct EndSessionButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(width: 80, height: 80)
            .foregroundColor(.red)
            .background(.red.opacity(0.3))
            .clipShape(Circle())
            .padding(.all, 3)
            .overlay(
                Circle()
                    .stroke(Color(.black)
                        .opacity(0.7), lineWidth: 2)
            )
    }
}
