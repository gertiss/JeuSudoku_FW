//
//  BandeV.swift
//  JeuSudoku_FW
//
//  Created by Gérard Tisseau on 31/01/2023.
//

import Foundation

/// Une bande verticale formée de 3 colonnes
public struct BandeV: Testable {
    
    public let index: Int // de 0 à 2
    
    public init(_ index: Int) {
        assert(index >= 0 && index <= 2)
        self.index = index
    }
    
    public var description: String {
        "BandeV(\(index))"
    }
    
}

public extension BandeV {
    
    static let noms = ["m", "n", "p"]
    
    /// Le nom de la bande, qui sert d'id pour  le protocole Identifiable
    var nom: String {
        Self.noms[index]
    }

    /// les 3 colonnes de la bande
    var colonnes: Set<Colonne> {
        [Colonne(index * 3), Colonne(index * 3 + 1), Colonne(index * 3 + 2)]
    }
    
    /// Les 27 cellules de la bande : 3 colonnes x 9
    var cellules: Set<Cellule> {
        var ensemble = Set<Cellule>()
        colonnes.forEach {
            ensemble = ensemble.union($0.cellules)
        }
        assert(ensemble.count == 27)
        return ensemble
    }
    
    /// Les 3 carrés de la bande self
    var carres: Set<Carre> {
        [Carre(0, index), Carre(1, index), Carre(2, index)]
    }
    
}
