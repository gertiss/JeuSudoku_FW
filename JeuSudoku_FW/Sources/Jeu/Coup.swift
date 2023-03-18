//
//  Coup.swift
//  JeuSudoku_FW
//
//  Created by Gérard Tisseau on 05/03/2023.
//

import Foundation

public enum MethodeCoup: String, CustomStringConvertible {
    case derniereCellule // dernière cellule vide dans une zone.
    case direct // dernière cellule non éliminée directement dans une zone.
    case indirect // nécessite de trouver d'autres présences d'abord.
    case uniqueValeur // unique valeur possible pour une cellule, globalement.
    
    public var description: String {
        rawValue
    }
}

/// Découverte d'un singleton1 dans une zone.
/// Avec éventuellement utilisation de presences auxiliaires (paire1, paire2, triplet3)
/// methode donne une indication sur la méthode utilisée
public struct Coup {
    public let singleton: Presence
    public let zone: any UneZone
    public let auxiliaires: [Presence]
    public let methode: MethodeCoup
    public let demonstration: Demonstration

    public init(_ singleton: Presence, zone: any UneZone, auxiliaires: [Presence] = [], methode: MethodeCoup, demonstration: Demonstration) {
        self.singleton = singleton
        self.zone = zone
        self.auxiliaires = auxiliaires
        self.methode = methode
        self.demonstration = demonstration
    }
    
    
    /// Exemples : `Be_9 // dans le carré Mn`
    public var nom: String {
        [singleton.nom, "//", texteMethode, texteZone, texteSeparateur, texteAuxiliaires].joined(separator: " ")
            .trimmingCharacters(in: .whitespaces)
    }
    
    var texteMethode: String {
        methode.rawValue
    }
    
    var texteZone: String {
        if methode == .uniqueValeur { return "" }
        return "dans \(zone.texteLaZone)"
    }
    
    var texteSeparateur: String {
        switch methode {
        case .derniereCellule:
            return ""
        case .direct:
            return ""
        case .indirect:
            return "􀋂"
        case .uniqueValeur:
            return "􀑆"
        }
    }
    
    var texteAuxiliaires: String {
        auxiliaires.map { $0.nom }.sorted().joined(separator: " ")
    }
             
}
