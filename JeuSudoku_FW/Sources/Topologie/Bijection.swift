//
//  Bijection.swift
//  JeuSudoku_FW
//
//  Created by Gérard Tisseau on 01/02/2023.
//

import Foundation

/// Avec cellules.count == valeurs.count, parmi 1, 2, 3.
public struct Bijection: Testable {
    
    public let cellules: Set<Cellule>
    public let valeurs: Set<Int>
    public let nom: String

    public init(_ cellules: Set<Cellule>, _ valeurs: Set<Int>) {
        self.cellules = cellules
        self.valeurs = valeurs
        let nomsCellules = cellules.map { $0.nom }
            .sorted()
            .joined()
        let nomsValeurs = valeurs.map { $0.description }
            .sorted()
            .joined()
        self.nom = "\(nomsCellules)_\(nomsValeurs)"
    }
    
    /// 1, 2 ou 3
    var cardinal: Int {
        cellules.count
    }
    
    public var description: String {
        "Bijection(\(cellules), \(valeurs))"
    }

}

public typealias Etat = Set<Bijection>

public typealias CellulesImpossibles = Set<Cellule>

/// Avec cardinal 1, 2 ou 3
public typealias Focalisation = Set<Int>

public typealias Coup = Bijection


