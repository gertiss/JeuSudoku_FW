//
//  BandeV.swift
//  JeuSudoku_FW
//
//  Created by Gérard Tisseau on 31/01/2023.
//

import Foundation

/// Une bande verticale formée de 3 colonnes
public struct BandeV: Testable, InstanciableParNom {
    
    public let index: Int // de 0 à 2
    
    /// Peut échouer si données incohérentes. fatalError dans ce cas.
   public init(_ index: Int) {
        assert(index >= 0 && index <= 2)
        self.index = index
    }
    

    public var description: String {
        "BandeV(\(index))"
    }
    
}

// MARK: - Geometrie

public extension BandeV {
    
    /// les 3 colonnes de la bande self
    var colonnes: Set<Colonne> {
        [Colonne(index * 3), Colonne(index * 3 + 1), Colonne(index * 3 + 2)]
    }
    
    /// Les 27 cellules de la bande self : 3 colonnes x 9
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

public extension BandeV {
    
    static let noms = ["m", "n", "p"]
    
    /// Le nom de la bande, qui sert d'id pour  le protocole Identifiable
    var nom: String {
        Self.noms[index]
    }

    /// Exemple : `BandeV(nom: "n") -> BandeV(1)`.
    /// Peut échouer, fatalError()
    init(nom: String) {
        guard let index = Self.noms.firstIndex(of: nom) else {
            fatalError()
        }
        self = Self(index)
    }

    
}
