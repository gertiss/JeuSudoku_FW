//
//  Jeu.swift
//  JeuSudoku_FW
//
//  Created by Gérard Tisseau on 21/02/2023.
//

import Foundation



public extension Puzzle {
    
    /// Ajout d'une contrainte
    /// Vérifie sa validité si c'est un singleton (fatalError sinon)
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
    
    
    /// Jeu d'une partie aussi longtemps que possible. Retourne une liste de coups.
    /// Le paramètre `solution` est l'état final du puzzle résolu, si on le connaît.
    /// S'arrête dès qu'un coup n'est pas conforme à la solution connue, et rend alors `[]`
    /// Affichages de debug dans la console.
    func suiteDeCoups(solution: Puzzle? = nil) -> [Coup] {
        var etatCourant = self
        var resultat = [Coup]()
        print("-- \(etatCourant.codeChiffres)")
        while let nouveauCoup = etatCourant.premierCoup, estNouveauSingletonValide(nouveauCoup.singleton) {
            if let solution {
                guard contrainteEstCompatible(nouveauCoup.singleton, solution: solution) else {
                    print("-- Erreur : \(nouveauCoup.singleton.nom) incompatible avec solution")
                    return []
                }
            }
            resultat.append(nouveauCoup)
            etatCourant = etatCourant.plus(nouveauCoup.singleton)
        }
        print("-- \(etatCourant.codeChiffres)")
        let nombreDeCellulesNonResolues = 81 - etatCourant.cellulesResolues.count
        if nombreDeCellulesNonResolues == 0 {
            print("-- Succès")
        } else {
            print("-- Incomplet. Reste \(nombreDeCellulesNonResolues)")
        }
        return resultat
    }
    
    /// Rend `presence` si c'est un singleton valide non encore présent, nil sinon.
    func nouveauSingletonValide(_ presence: Presence) -> Presence? {
        estNouveauSingletonValide(presence) ? presence : nil
    }
    
    /// Vérifie si `presence` est un  c'est un singleton valide non encore présent.
    func estNouveauSingletonValide(_ presence: Presence) -> Bool {
        !contraintes.contains(presence) && estSingleton1Valide(presence)
    }
}
