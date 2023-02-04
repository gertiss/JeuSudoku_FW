//
//  Ligne.swift
//  EtudeSudokuGT
//
//  Created by Gérard Tisseau on 10/01/2023.
//

import Foundation

public struct Ligne {
    
    public let index: Int // de 0 à 8
    
    public init(_ index: Int) {
        assert(index >= 0 && index <= 8)
        self.index = index
    }
    
}

// MARK: - Testable

extension Ligne: Testable {
    
    public var description: String {
        "Ligne(\(index))"
    }
}

// MARK: - UnDomaine

extension Ligne: UnDomaine {

    public var estUnDomaine: Bool { true }
    
    /// Les 9 cellules de la ligne
    public var cellules: Set<Cellule> {
        (0...8).map { Cellule(index, $0) }.ensemble
    }
}

// MARK: - InstanciableParNom

extension Ligne: InstanciableParNom {
 
    /// Le nom de la ligne, qui sert d'id pour  le protocole Identifiable
    public var nom: String {
         Self.noms[index]
     }

    /// Exemple : `Ligne(nom: "B") -> Ligne(1)`.
    /// Peut échouer, fatalError
    public init(nom: String) {
        guard let index = Self.noms.firstIndex(of: nom) else {
            fatalError()
        }
        self = Self(index)
    }

    public static let noms = "ABCDEFGHI".map { String($0) }
}

// MARK: - Geometrie

public extension Ligne {
    
    /// L'unique bande horizontale qui contient la ligne
    var bande: BandeH {
        BandeH(index / 3)
    }
    
    
}
