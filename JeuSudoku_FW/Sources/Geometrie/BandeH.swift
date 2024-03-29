//
//  BandeH.swift
//  JeuSudoku_FW
//
//  Created by Gérard Tisseau on 31/01/2023.
//

import Foundation
import Modelisation_FW


public struct BandeH: Codable {
    
    public let index: Int // de 0 à 2
    
    /// Peut échouer si les données sont incohérentes. fatalError  dans ce cas.
    public init(_ index: Int) {
        assert(index >= 0 && index <= 2)
        self.index = index
    }
}

// MARK: - Geometrie

extension BandeH {

    /// Les 3 lignes de la bande
    var lignes: Set<Ligne> {
        [Ligne(index * 3), Ligne(index * 3 + 1), Ligne(index * 3 + 2)]
    }
    
    /// Les 27 cellules de la bande : 3 lignes x 9
    var cellules: Region {
        var ensemble = Region()
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

// MARK: - Testable

extension BandeH {
    
    public var description: String {
        "BandeH(\(index))"
    }
}

// MARK: - CodableParNom

public typealias BandeH_ = String

extension BandeH: CodableParNom {
    
    static let noms = ["M", "N", "P"]
    
    /// Le nom de la bande, qui sert d'id pour  le protocole Identifiable
    public var nom: String {
        Self.noms[index]
    }
    
    /// Exemple : `BandeH(nom: "N") -> BandeH(1)`.
    /// Peut échouer, fatalError()
    public init(nom: String) {
        guard let index = Self.noms.firstIndex(of: nom) else {
            fatalError()
        }
        self = Self(index)
    }
}

