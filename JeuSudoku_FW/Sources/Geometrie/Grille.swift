//
//  Grille.swift
//  JeuSudoku_FW
//
//  Created by Gérard Tisseau on 01/02/2023.
//

import Foundation

/// Un domaine de noms static, implémenté comme enum sans cas (c'est la technique Apple)
/// Ce n'est qu'un recueil de constantes, calculées une fois pour toutes au démarrage.
public enum Grille { }

public extension Grille {
    
    /// Les éléments géométriques pouvant être calculés statiquement sont stockés
    static let cellules: Set<Cellule> = calculCellules
    static let lignes: Set<Ligne> = calculLignes
    static let colonnes: Set<Colonne> = calculColonnes
    static let carres: Set<Carre> = calculCarres
    static let bandesH: Set<BandeH> = calculBandesH
    static let bandesV: Set<BandeV> = calculBandesV
    
    /// Les lignes, colonnes, carrés
    static let zones: [any UneZone] = calculZones
}

// MARK: - Private

// Calcul des éléments géométriques statiques
// Ne sera effectué qu'une fois

extension Grille {
    
    private static var calculCellules: Set<Cellule> {
        var ensemble = Set<Cellule>()
        for ligne in 0...8 {
            for colonne in 0...8 {
                ensemble.insert(Cellule(ligne, colonne))
            }
        }
        return ensemble
    }

    private static var calculCarres: Set<Carre> {
        var ensemble = Set<Carre>()
        for indexBandeH in 0...2 {
            for indexBandeV in 0...2 {
                ensemble.insert(Carre(indexBandeH, indexBandeV))
            }
        }
        return ensemble
    }
    
    private static var calculLignes: Set<Ligne> {
        (0...8).map { Ligne($0) }.ensemble
    }
    
    private static var calculColonnes: Set<Colonne> {
        (0...8).map { Colonne($0) }.ensemble
    }
    
    private static var calculZones: [any UneZone] {
        let carres = calculCarres.array as [any UneZone]
        let lignes = calculLignes.array as [any UneZone]
        let colonnes = calculColonnes.array as [any UneZone]
        return carres + colonnes + lignes
    }
    
    private static var calculBandesH: Set<BandeH> {
        [BandeH(0), BandeH(1), BandeH(2)]
    }
    
    private static var calculBandesV: Set<BandeV> {
        [BandeV(0), BandeV(1), BandeV(2)]
    }
    
}
