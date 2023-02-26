//
//  UneContrainte.swift
//  JeuSudoku_FW
//
//  Created by Gérard Tisseau on 18/02/2023.
//

import Foundation

public enum TypeContrainte: Hashable, Codable {
    case singleton1 // une cellule, une valeur
    case singleton2 // une cellule, deux valeurs
    case paire1 // deux cellules, une valeur
    case paire2 // deux cellules, deux valeurs
}

/// Une contrainte exprimant la présence obligatoire des valeurs dans la région
public protocol UneContrainte {
    var valeurs: Valeurs { get }
    var region: Region { get }
    var type: TypeContrainte { get }
    
    init(_ valeurs: Valeurs, dans region: Region)
    
    func contient(valeur: Int) -> Bool
    func contient(cellule: Cellule) -> Bool
    var estUneBijection: Bool { get }
    var alignement: (any UneZone)? { get }
    
}

public extension UneContrainte {
    
    var type: TypeContrainte {
        switch (region.count, valeurs.count) {
        case (1, 1): return .singleton1
        case (1, 2): return .singleton2
        case (2, 1): return .paire1
        case (2, 2): return .paire2
        default: fatalError("Une contrainte ne peut avoir que 1 ou 2 cellules et 1 ou 2 valeurs")
        }
    }
    
    func contient(valeur: Int) -> Bool {
        valeurs.contains(valeur)
    }
    
    func contient(cellule: Cellule) -> Bool {
        region.contains(cellule)
    }
    
    var estUneBijection: Bool {
        region.count == valeurs.count
    }
    
    var estDansUnAlignement: Bool {
        region.estDansUnAlignement
    }
    
    var alignement: (any UneZone)? {
        region.alignement
    }
}
