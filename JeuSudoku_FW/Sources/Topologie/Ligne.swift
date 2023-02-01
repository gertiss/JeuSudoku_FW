//
//  Ligne.swift
//  EtudeSudokuGT
//
//  Created by Gérard Tisseau on 10/01/2023.
//

import Foundation

public struct Ligne: UneZone {
    
    public let type: TypeZone 
    
    public let index: Int // de 0 à 8
    
    public init(_ index: Int) {
        assert(index >= 0 && index <= 8)
        self.index = index
        self.type = .ligne
    }

    static let noms = "ABCDEFGHI".map { String($0) }
}

public extension Ligne {
    /// Les 9 cellules de la ligne
    var cellules: Set<Cellule> {
        (0...8).map { Cellule(index, $0) }.ensemble
    }
    
    /// L'unique bande horizontale qui contient la ligne
    var bande: BandeH {
        BandeH(index / 3)
    }
    
    var description: String {
        "Ligne(\(index))"
    }

    
   /// Le nom de la ligne, qui sert d'id pour  le protocole Identifiable
    var nom: String {
        Self.noms[index]
    }
    

    
//    var nom: String {
//        return "la ligne " + Grille.nomsLignes[index]
//    }
//
//    func texte(dans grille: Grille) -> String {
//        let txtValeurs = (0...8)
//            .map { co in
//                let valeur = grille.valeur(Cellule(index, co))
//                return valeur == 0 ? "·" : "\(valeur)"
//            }
//            .joined(separator: " ")
//
//        return "\(Grille.nomsLignes[index]) \(txtValeurs)"
//
        
//    }
}
