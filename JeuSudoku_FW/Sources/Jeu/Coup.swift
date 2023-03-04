//
//  Coup.swift
//  JeuSudoku_FW
//
//  Created by Gérard Tisseau on 21/02/2023.
//

import Foundation


public extension Puzzle {
    
    /// Ajout d'une contrainte
    func plus(_ contrainte: Presence) -> Puzzle {
        if contrainte.type == .singleton1 {
            assert(estSingleton1Valide(contrainte))
        }
        let nouvellesContraintes = contraintes
            .ensemble.union([contrainte]) // Pour éviter les doublons
            .array.sorted() // Pour remettre sous forme canonique
        return Puzzle(contraintes: nouvellesContraintes)
    }
    
    /// Suppression d'une contrainte
    func moins(_ contrainte: Presence) -> Puzzle {
        let nouvellesContraintes = contraintes
            .ensemble.subtracting([contrainte])
            .array.sorted()
        return Puzzle(contraintes: nouvellesContraintes)
    }
    
    // Jeu d'une partie aussi longtemps que possible
    var suiteDeContraintesDetectees: [Presence] {
        var etat = self
        var contraintes = [Presence]()
        var contrainte = etat.contrainteDetectee
        while let nouvelleContrainte = contrainte {
            contraintes.append(nouvelleContrainte)
            etat = etat.plus(nouvelleContrainte)
            assert(etat.contraintes.contains(nouvelleContrainte))
            contrainte = etat.contrainteDetectee
        }
        print("// \(etat.codeChiffres)")
        let nombreDeCellulesNonResolues = 81 - etat.cellulesResolues.count
        if nombreDeCellulesNonResolues == 0 {
            print("// Succès")
        } else {
            print("// Incomplet. Reste \(nombreDeCellulesNonResolues)")
            print(etat.texteDessin)
        }
        return contraintes
    }
    
    
    func jeuAvecVerification(solution: Puzzle) -> [Presence] {
        var etat = self
        var contraintes = [Presence]()
        var contrainte = etat.contrainteDetectee
        while let nouvelleContrainte = contrainte {
            guard contrainteEstCompatible(nouvelleContrainte, solution: solution) else {
                print("\(nouvelleContrainte.nom) incompatible avec solution")
                return []
            }
            contraintes.append(nouvelleContrainte)
            etat = etat.plus(nouvelleContrainte)
            assert(etat.contraintes.contains(nouvelleContrainte))
            contrainte = etat.contrainteDetectee
        }
        return contraintes
    }

}
