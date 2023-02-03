//
//  Colonne.swift
//  EtudeSudokuGT
//
//  Created by Gérard Tisseau on 10/01/2023.
//

import Foundation

public struct Colonne: UneZone {
    
    public let type: TypeZone 
    
    public let index: Int // de 0 à 8
    
    public init(_ index: Int) {
        assert(index >= 0 && index <= 8)
        self.index = index
        self.type = .colonne
    }
    
    /// Exemple : `Colonne(nom: "b") -> Colonne(1)`
    /// Peut échouer, retourne alors nil.
    public init?(nom: String) {
        guard let index = Self.noms.firstIndex(of: nom) else {
            return nil
        }
        self = Self(index)
    }

    public static let noms = "abcdefghi".map { String($0) }
}

extension Colonne {
    
    /// Les 9 cellules de la colonne self
    public var cellules: Set<Cellule> {
        let ensemble = (0...8).map { Cellule($0, index) }.ensemble
        assert(ensemble.count == 9)
        return ensemble
    }
    
    /// L'unique bande verticale qui contient la colonne self
    public var bande: BandeV {
        BandeV(index / 3)
    }

    public var description: String {
        "Colonne(\(index))"
    }

    /// Le nom de la colonne self, qui sert d'id pour  le protocole Identifiable
   public var nom: String {
        Self.noms[index]
    }


}
