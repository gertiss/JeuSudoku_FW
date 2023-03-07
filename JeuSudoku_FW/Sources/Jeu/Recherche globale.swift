//
//  Detection globale.swift
//  JeuSudoku_FW
//
//  Created by Gérard Tisseau on 04/03/2023.
//

import Foundation

public extension Puzzle {
    
    /// La stratégie de recherche globale de plus haut niveau :
    /// quel est le premier coup nouveau qu'on peut trouver à partir de l'état actuel ?
    /// Toutes les fonctions de recherche utilisées retournent un coup ou nil.
    /// On garantit que le coup découvre un singleton valide non encore dans l'état actuel.
    /// Classement : la méthode la moins combinatoire d'abord.
    var premierCoup: Coup? {
        
        // Niveau 1.0 : dernière cellule vide dans une zone, valeur obligée.
        // complexité 1
        if let coup = coupDerniereCellule {
            return coup
        }
        // Dernière cellule libre après élimination directe.
        // Niveau 1.2 dans un carré, 1.5 dans une ligne ou une colonne.
        // complexité 1
        if let coup = coupParEliminationDirecte {
            return coup
        }
        // Dernière cellule libre après élimination directe et indirecte.
        // Utilise une ou plusieurs paire1 auxiliaires.
        // Niveau 1.7
        // complexité ?
        if let coup = coupParEliminationIndirecte {
            return coup
        }
        // Paire2 dans une zone avec 3 cellules libres,
        // puis élimination directe dans le complémentaire.
        // Complexité 3
        if let coup = coupApresPaire(parmi: 3) {
            return coup
        }

        // Triplet3 dans une zone avec 4 cellules libres,
        // puis élimination directe dans le complémentaire.
        // Complexité 4
        if let coup = coupApresTriplet(parmi: 4) {
            return coup
        }
        // Paire2 dans une zone avec 4 cellules libres,
        // puis élimination directe dans le complémentaire.
        // Complexité 6
        if let coup = coupApresPaire(parmi: 4) {
            return coup
        }
        // Paire2 dans une zone avec 5 cellules libres,
        // puis élimination directe dans le complémentaire.
        // Niveau 2.0. Complexité 10
        if let coup = coupApresPaire(parmi: 5) {
            return coup
        }
        // Triplet3 dans une zone avec 5 cellules libres,
        // puis élimination directe dans le complémentaire.
        // Complexité 10
        if let coup = coupApresTriplet(parmi: 5) {
            return coup
        }
        // Paire2 dans une zone avec 6 cellules libres,
        // puis élimination directe dans le complémentaire.
        // Niveau 2.6. Complexité 15
        if let coup = coupApresPaire(parmi: 6) {
            return coup
        }
        // Triplet3 dans une zone avec 6 cellules libres,
        // puis élimination directe dans le complémentaire.
        // Complexité 20
        if let coup = coupApresTriplet(parmi: 6) {
            return coup
        }
        // Paire2 dans une zone avec 7 cellules libres,
        // puis élimination directe dans le complémentaire.
        // Complexité 21
        if let coup = coupApresPaire(parmi: 7) {
            return coup
        }
        // Paire2 dans une zone avec 8 cellules libres,
        // puis élimination directe dans le complémentaire.
        // Complexité 28
        if let coup = coupApresPaire(parmi: 8) {
            return coup
        }
        // Triplet3 dans une zone avec 7 cellules libres,
        // puis élimination directe dans le complémentaire.
        // Complexité 35
        if let coup = coupApresTriplet(parmi: 7) {
            return coup
        }
        // Paire2 dans une zone avec 9 cellules libres,
        // puis élimination directe dans le complémentaire.
        // Complexité 36
        if let coup = coupApresPaire(parmi: 9) {
            return coup
        }
        //
        // Triplet3 dans une zone avec 8 cellules libres,
        // puis élimination directe dans le complémentaire.
        // Complexité 56
        if let coup = coupApresTriplet(parmi: 8) {
            return coup
        }

        
        // Cellule n'ayant plus qu'un seul candidat,
        // qu'on ne peut pas voir par élimination directe.
        // Recherche combinatoire globale ne correspondant pas à une perception humaine.
        // C'est un coup "joker" quand on ne trouve rien d'autre.
        if let coup = coupUniqueValeurCandidate {
            return coup
        }
        
        return nil
    }
    
}
