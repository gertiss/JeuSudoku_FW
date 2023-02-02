//
//  BandeH.swift
//  JeuSudoku_FW
//
//  Created by Gérard Tisseau on 31/01/2023.
//

import Foundation

public struct BandeH: Testable {
    
    public let index: Int // de 0 à 2
    
    public init(_ index: Int) {
        assert(index >= 0 && index <= 2)
        self.index = index
    }
    
    public var description: String {
        "BandeH(\(index))"
    }
}

public extension BandeH {
    
    static let noms = ["M", "N", "P"]
    
    /// Le nom de la bande, qui sert d'id pour  le protocole Identifiable
    var nom: String {
        Self.noms[index]
    }
    
    /// Les 3 lignes de la bande
    var lignes: Set<Ligne> {
        [Ligne(index * 3), Ligne(index * 3 + 1), Ligne(index * 3 + 2)]
    }
    
    /// Les 27 cellules de la bande : 3 lignes x 9
    var cellules: Set<Cellule> {
        var ensemble = Set<Cellule>()
        lignes.forEach {
            ensemble = ensemble.union($0.cellules)
        }
        assert(ensemble.count == 27)
        return ensemble
    }
    
    /// Les 3 carrés de la bande self
    var carres: Set<Carre> {
        [Carre(index, 0), Carre(index, 1), Carre(index, 2)]
    }

    
}
