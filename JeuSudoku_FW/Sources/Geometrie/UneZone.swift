//
//  Zone.swift
//  EtudeSudokuGT
//
//  Created by Gérard Tisseau on 10/01/2023.
//

import Foundation
import Modelisation_FW

public typealias AnyZone = any UneZone
public typealias AnyZone_ = String // Le nom de la zone

public enum TypeZone: String, Hashable, Codable {
    case carre
    case ligne
    case colonne
    
    var visibilite: Int {
        switch self {
        case .carre:
            return 2
        case .ligne:
            return 1
        case .colonne:
            return 0
        }
    }
}

/// UneZone est une Ligne ou une Colonne ou un Carre
/// Si on veut une collection de UneZone, il faut écrire `[any UneZone]`,
/// car `Set<UneZone>` est impossible à résoudre pour l'inférence de types.
public protocol UneZone: CodableParNom {
    var nom: String { get }
    
    var cellules: Region { get }
    var type: TypeZone { get }
}

public extension UneZone {
    var texteLaZone: String {
        switch type {
        case .carre:
            return "le carré \(nom)"
        case .ligne:
            return "la ligne \(nom)"
        case .colonne:
            return "la colonne \(nom)"
        }
    }
}


public extension Grille {
    /// Peut échouer, fatalError
    static func laZone(nom: String) -> (any UneZone) {
        if Ligne.noms.contains(nom) {
            return Ligne(nom: nom)
        }
        if Colonne.noms.contains(nom) {
            return Colonne(nom: nom)
        }
        if Carre.noms.contains(nom) {
            return Carre(nom: nom)
        }
        fatalError("Nom de zone incorrect \(nom)")
    }
    
    static func laZone(litteral: AnyZone_) -> (any UneZone) {
        Grille.laZone(nom: litteral)
    }
    
}

/// Zone est un domaine de noms, non instanciable.
/// Permet d'écrire Zone.Litteral sans que Zone soit conforme à CodableEnLitteral
public enum Zone {
    public typealias Litteral = String
}
