//
//  API.swift
//  JeuSudoku_FW
//
//  Created by Gérard Tisseau on 28/02/2023.
//

import Foundation
import SwiftUI

public func suiteDesCoups(presences: String) -> Result<String, String> {
    let puzzle = Puzzle(chiffres: presences)
    guard puzzle.estValide else {
        return .failure("L'état initial n'est pas valide")
    }
    let coups = puzzle.suiteDeCoups()
    return .success(coups.map { $0.nom }.joined(separator: "\n"))
}

public func vueGT(presences: String) -> VueGT {
    VueGT(presences: presences)
}

public struct VueGT: View {
    
    var presences: String

    public var body: some View {
        HStack {
            Text("VueGT")
            if presences.count < 100 {
                Text(String(presences.prefix(10)))
            } else {
                Text("?")
            }
        }

    }
}
