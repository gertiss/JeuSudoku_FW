//
//  Regles.swift
//  JeuSudoku_FW
//
//  Created by Gérard Tisseau on 11/03/2023.
//

import Foundation
import Modelisation_FW

/// Le `singleton` peut être détecté parce que les `eliminations` éliminent sa cellule
/// pour toutes les valeurs sauf une
struct Coup_DerniereValeur {
    let singleton: Presence
    let eliminations: [EliminationDirecte]
}

public struct Coup_DerniereValeur_:  UnLitteral {
    public let singleton: Presence_ // Presence
    public let eliminations: [EliminationDirecte_]
    
    public var codeSwift: String {
        "Coup_DerniereValeur_(singleton: \(singleton.codeSwift), eliminations: \(eliminations.codeSwift))"
    }
}

extension Coup_DerniereValeur: CodableEnLitteral {
    typealias Litteral = Coup_DerniereValeur_

    var litteral: Coup_DerniereValeur_ {
        Self.Litteral(singleton: singleton.litteral, eliminations: eliminations.litteral)
    }
    
    init(litteral: Coup_DerniereValeur_) {
        singleton = Presence(litteral: litteral.singleton)
        eliminations = [EliminationDirecte](litteral: litteral.eliminations)
    }
}

// MARK: - Requêtes

extension Coup_DerniereValeur {
    static func instances(zone: AnyZone, dans: Puzzle) -> [Self] {
        return []
    }
}
