//
//  API.swift
//  JeuSudoku_FW
//
//  Created by Gérard Tisseau on 28/02/2023.
//

import Foundation

// MARK: - API coups

/// Le premier coup trouvé à partir d'un `puzzle` donné par ses 81 chiffres en String.
/// Si succès : un coup représenté par une ligne. Exemple :
/// `"Hb_8 // indirect dans le carré Pm 􀋂 DcEc_8 GdGe_8"`
/// Echecs possibles : `Etat initial invalide` ou `Pas de coup suivant`.
public func coupSuivant(puzzle: String) -> Result<String, String> {
    let puzzle = Puzzle(chiffres: puzzle)
    guard puzzle.estValide else {
        return .failure("Etat initial invalide")
    }
    guard let coup = puzzle.premierCoup else {
        return .failure("Pas de coup suivant")
    }
    return .success(coup.nom)
}

/// La suite des coups trouvés à partir d'un `puzzle` donné par ses 81 chiffres en String.
/// Si succès : la suite des coups représentée par un texte multiligne. Exemple :
/// `"Id_3 // derniereCellule dans la colonne d\nDa_7 // direct dans le carré Nm"`
/// Echecs possibles :  : `Etat initial invalide`, `Pas de coup suivant`
/// La suite de coups ne donne pas forcément un puzzle entièrement résolu.
public func suiteDesCoups(puzzle: String) -> Result<String, String> {
    let puzzle = Puzzle(chiffres: puzzle)
    guard puzzle.estValide else {
        return .failure("Etat initial invalide")
    }
    guard puzzle.premierCoup != nil else {
        return .failure("Pas de coup suivant")
    }
    let coups = puzzle.suiteDeCoups()
    return .success(coups.map { $0.nom }.joined(separator: "\n"))
}


// MARK: - API Demonstration

public struct DemonstrationLitterale: UnLitteral, CustomStringConvertible {

    public var codeSwift: String {
        "DemonstrationLitterale(presence: \(presence.debugDescription), zone: \(zone.debugDescription), occupees: \(occupees), eliminatrices: \(eliminatrices), eliminees: \(eliminees), auxiliaires: [\(auxiliaires.map { $0.codeSwift }.joined(separator: ", "))]"
    }
    
    public var presence: String
    public var zone: String
    public var occupees: [String]
    public var eliminatrices: [String]
    public var eliminees: [String]
    public var auxiliaires: [AuxiliaireLitteral]
        
    public var description: String {
        codeSwift
    }
}

public struct AuxiliaireLitteral: UnLitteral, CustomStringConvertible {
        
    public var codeSwift: String {
        "AuxiliaireLitteral(presence: \(presence.debugDescription), zone: \(zone.debugDescription), occupees: \(occupees), eliminatrices: \(eliminatrices), eliminees: \(eliminees)]"
    }
    
/// La présence détectée
    public var presence: String
    public var zone: String
    public var occupees: [String]
    public var eliminees: [String]
    public var eliminatrices: [String]
    
    public var description: String {
        codeSwift
    }

}



