//
//  Routes.swift
//  GameClock
//
//  Created by Christian Rodriguez on 12/18/23.
//

import Foundation
import SwiftUI

class Routes: ObservableObject {
    @Published var navigation: [NavDestination] = []
}

enum NavDestination : Hashable {
    case session
    case settings
}
