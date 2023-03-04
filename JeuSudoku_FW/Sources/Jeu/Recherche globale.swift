//
//  Detection globale.swift
//  JeuSudoku_FW
//
//  Created by Gérard Tisseau on 04/03/2023.
//

import Foundation

public extension Puzzle {
    
    /// La stratégie de recherche globale de plus haut niveau
    var contrainteDetectee: Presence? {
        
        // Niveau 1.0 : dernière cellule vide visible immédiatement.
        if let singleton = singleton1VisibleDetecte {
            print("\(singleton.nom) // dernier")
            return singleton
        }
        // Dernière cellule libre après élimination directe.
        // Niveau 1.2 dans un carré, 1.5 dans une ligne ou une colonne.
        if let singleton = singletonDetecteParEliminationDirecte {
            print("\(singleton.nom) // direct")
            return singleton
        }
        // Dernière cellule libre après élimination indirecte.
        // Niveau 1.7
        if let singleton = singletonDetecteParEliminationIndirecte {
            print("\(singleton.nom) // indirect 􀋂")
            return singleton
        }
        
        // paire dans une zone avec 3 cellules libres. Complexité 3
        if let coup = coupApresPaire2(parmi: 3) {
            print("\(coup.nom) // paire parmi 3 : 3􀋂")
            return coup
        }
        
        // triplet dans une zone avec 4 cellules libres. Complexité 4
        if let coup = coupApresTriplet3(parmi: 4) {
            if coup.type == .singleton1 {
                print("\(coup.nom) // triplet parmi 4 : 4􀋂")
            }
            return coup
        }

        // paire dans une zone avec 4 cellules libres. Complexité 6
        if let coup = coupApresPaire2(parmi: 4) {
            if coup.type == .singleton1 {
                print("\(coup.nom) // paire parmi 4 : 6􀋂")
            }
            return coup
        }
        
        // paire dans une zone avec 5 cellules libres. Niveau 2.0. Complexité 10
        if let coup = coupApresPaire2(parmi: 5) {
            if coup.type == .singleton1 {
                print("\(coup.nom) // paire parmi 5 : 10􀋂")
            }
            return coup
        }
        
        // triplet dans une zone avec 5 cellules libres. Complexité 10
        if let coup = coupApresTriplet3(parmi: 5) {
            if coup.type == .singleton1 {
                print("\(coup.nom) // triplet parmi 5 : 10􀋂")
            }
            return coup
        }

        // paire dans une zone avec 6 cellules libres. Niveau 2.6. Complexité 15
        if let coup = coupApresPaire2(parmi: 6) {
            if coup.type == .singleton1 {
                print("\(coup.nom) // paire parmi 6 : 15􀋂")
            }
            return coup
        }
                
       // triplet dans une zone avec 6 cellules libres. Complexité 20
        if let coup = coupApresTriplet3(parmi: 6) {
            if coup.type == .singleton1 {
                print("\(coup.nom) // triplet parmi 6 : 20􀋂")
            }
            return coup
        }

        // Cellule n'ayant plus qu'un seul candidat,
        // qu'on ne peut pas voir par élimination directe.
        // Pas très humain
        if let singleton = absenceInvisibleDetectee {
            assert(!contraintes.contains(singleton))
            print("\(singleton.nom) // absence invisible 􀋂􀋂􀋂􀋂")
            return singleton
        }
        
        return nil
    }
}
