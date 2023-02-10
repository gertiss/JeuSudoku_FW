//
//  Exemples résolus.swift
//  JeuSudoku_FW
//
//  Created by Gérard Tisseau on 05/02/2023.
//

import Foundation

public extension Puzzle {
    
    static var exempleResolu1: ExempleResolu {
        // Le monde jeudi 2 février facile
        let saisie = """
000 000 000
000 000 008
000 003 724

000 040 005
005 002 010
008 010 207

094 007 050
051 024 096
082 039 000
"""
        
        // à tester : validité sémantique (unicités)
        let puzzle = Puzzle(chiffres: saisie)
        let focalisation: Focalisation = .surValeursDansContexte(valeurs: [5], contexte: [Cellule(nom: "Gd"), Cellule(nom: "Ge"), Cellule(nom: "Hd"), Cellule(nom: "Id")])
        let recherche = RechercheDeRegions(focalisation: focalisation)

        return ExempleResolu(
            puzzle: puzzle,
            rapport: RapportDeRecherche(
                decouverte: 
                    DecouverteDeContrainte(
                        contrainte: PresenceValeurs(nom: "Id_5"),
                        strategie: .rechercheDeRegions(recherche)
                        )
                )
            )
        
    }
}
