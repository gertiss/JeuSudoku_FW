//
//  VueGT.swift
//  JeuSudoku_FW
//
//  Created by Gérard Tisseau on 07/03/2023.
//

import Foundation
import SwiftUI


/// Retourne une vue représentant différentes informations concernant un puzzle.
/// `puzzle` est le code du puzzle sous forme de 81 chiffres.
/// Cette vue n'est connectée à aucun ObservableObject qui lui serait externe.
/// mais elle peut très bien avoir un StateObject privé.
/// Les informations sont calculées exclusivement par `JeuSudoku_FW`
public func vueGT(puzzle: String) -> VueGT {
    VueGT(puzzle: puzzle)
}

public struct VueGT: View {
    
    var puzzle: String
    
    var lePuzzle: Puzzle {
        Puzzle(chiffres: puzzle)
    }

    public var body: some View {
        HStack {
            Text("VueGT")
        }

    }
}
