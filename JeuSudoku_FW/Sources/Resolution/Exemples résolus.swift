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
        
        // fatalError si saisie invalide
        let code = CodagePuzzle.codeDepuisSaisie(saisie)
        // à tester : validité sémantique (unicités)
        let puzzle = Puzzle(code)
        return ExempleResolu(
            puzzle: puzzle,
            rapport: RapportDeRecherche(
                decouvertes: [
                    DecouverteDeContrainte(
                        contrainte: ExistenceBijection(domaine: [Cellule(nom: "Id")].ensemble,
                            valeurs: [5]),
                        strategie: .rechercheDeDomaines(RechercheDeDomaines(
                            contexte: [Cellule(nom: "Gd"), Cellule(nom: "Ge"), Cellule(nom: "Hd"), Cellule(nom: "Id")],
                            valeurs: [5]
                        )))]))
        
    }
}
