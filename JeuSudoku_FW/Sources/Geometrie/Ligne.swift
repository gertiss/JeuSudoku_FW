//
//  Ligne.swift
//  EtudeSudokuGT
//
//  Created by Gérard Tisseau on 10/01/2023.
//

import Foundation
import Modelisation_FW

public struct Ligne {
    
    public let index: Int // de 0 à 8
    
    public init(_ index: Int) {
        assert(index >= 0 && index <= 8)
        self.index = index
    }
}

// MARK: - Geometrie

public extension Ligne {
    
    /// L'unique bande horizontale qui contient la ligne
    var bande: BandeH {
        BandeH(index / 3)
    }
    
}

// MARK: - UneZone

extension Ligne: UneZone {
    
    public var type: TypeZone { .ligne }
    
    /// Les 9 cellules de la ligne
    public var cellules: Region {
        (0...8).map { Cellule(index, $0) }.ensemble
    }
}


// MARK: - Testable

extension Ligne {
    
    public var description: String {
        "Ligne(\(index))"
    }
}



// MARK: - CodableParNom

public typealias Ligne_ = String

extension Ligne: CodableParNom {
 
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

    

