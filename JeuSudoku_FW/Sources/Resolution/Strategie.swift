//
//  Strategie.swift
//  JeuSudoku_FW
//
//  Created by Gérard Tisseau on 04/02/2023.
//

import Foundation

public enum Focalisation: Testable {
    case surValeursDansContexte(valeurs: Set<Int>, contexte: Set<Cellule>)
    case surRegion(Set<Cellule>)
    
    public var description: String {
        switch self {
        case .surValeursDansContexte(let valeurs, let contexte):
            return ".surValeursDansContexte(valeurs: \(valeurs), contexte: \(contexte))"
        case .surRegion(let set):
            return ".surRegion(\(set))"
        }
    }

}

/// Compte rendu de la stratégie utilisée pour trouver une contrainte
public enum Strategie: Testable {
    case rechercheDeRegions(RechercheDeRegions)
    case rechercheDeValeurs(RechercheDeValeurs)
    
    public var description: String {
        switch self {
        case .rechercheDeRegions(let rechercheDeRegions):
            return rechercheDeRegions.description
        case .rechercheDeValeurs(let rechercheDeValeurs):
            return rechercheDeValeurs.description
        }
    }

}

/// On cherche dans le `contexte`, une sous-region contenant obligatoirement  l'ensemble des `valeurs` qui a servi de focalisation.
public struct RechercheDeRegions: Testable {
    public var contexte: Set<Cellule>
    public var valeurs: Set<Int>
    
    
    public init(focalisation: Focalisation) {
        switch focalisation {
        case .surValeursDansContexte(let valeurs, let contexte):
            self.contexte = contexte
            self.valeurs = valeurs
        case .surRegion(_):
            fatalError()
        }
    }
    
    public var description: String {
        let texteValeurs = valeurs.map { $0.description }.sorted()
            .joined()
        return "Recherche(focalisation: \(texteValeurs), dans: \(contexte)"
    }
    
    public var focalisation: Focalisation {
        .surValeursDansContexte(valeurs: valeurs, contexte: contexte)
    }
    
}


/// On cherche  l'ensemble des valeurs obligatoirement présentes dans la`region` sur laquelle on se focalise
public struct RechercheDeValeurs: Testable {
    
    public var region: Set<Cellule>
    
    public init(focalisation: Focalisation) {
        switch focalisation {
        case .surValeursDansContexte(_, _):
            fatalError()
        case .surRegion(let set):
            region = set
        }
    }
    
    public var description: String {
        "RechercheDeValeurs(focalisation: \(focalisation))"
    }
    
    public var focalisation: Focalisation {
        .surRegion(region)
    }
}
