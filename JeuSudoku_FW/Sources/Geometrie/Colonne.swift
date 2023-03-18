//
//  Colonne.swift
//  EtudeSudokuGT
//
//  Created by Gérard Tisseau on 10/01/2023.
//

import Foundation

public struct Colonne {
    
    public let index: Int // de 0 à 8
    
    public init(_ index: Int) {
        assert(index >= 0 && index <= 8)
        self.index = index
    }
}

// MARK: - Geometrie

extension Colonne {
    
    /// L'unique bande verticale qui contient la colonne self
    public var bande: BandeV {
        BandeV(index / 3)
    }

}

// MARK: - UneZone

extension Colonne: UneZone {
    public var type: TypeZone { .colonne }

    /// Les 9 cellules de la colonne self
    public var cellules: Region {
        let ensemble = (0...8).map { Cellule($0, index) }.ensemble
        assert(ensemble.count == 9)
        return ensemble
    }
}


// MARK: - Testable

extension Colonne {
    public var description: String {
        "Colonne(\(index))"
    }
}


// MARK: - InstanciableParNom

extension Colonne: InstanciableParNom {
    
    /// InstanciableParNom
    /// Le nom de la colonne self, qui sert d'id pour  le protocole Identifiable
   public var nom: String {
        Self.noms[index]
    }
    
    /// InstanciableParNom
    /// Exemple : `Colonne(nom: "b") -> Colonne(1)`
    /// Peut échouer, fatalError.
    public init(nom: String) {
        guard let index = Self.noms.firstIndex(of: nom) else {
            fatalError()
        }
        self = Self(index)
    }

    public static let noms = "abcdefghi".map { String($0) }

}

