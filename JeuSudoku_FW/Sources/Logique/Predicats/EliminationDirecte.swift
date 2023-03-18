//
//  SujetCellule.swift
//  JeuSudoku_FW
//
//  Created by Gérard Tisseau on 13/03/2023.
//

import Foundation


/// Prédicats dont le sujet est une cellule


/// `eliminee` est une cellule vide éliminée directement par `eliminatrice` (un singleton)
/// pour la valeur du singleton
struct EliminationDirecte {
    let eliminee: Cellule
    let eliminatrice: Presence // Un singleton
}

extension EliminationDirecte {
    
    var valeur: Int {
        eliminatrice.valeurs.uniqueElement
    }
        
}

// MARK: - Requêtes

extension EliminationDirecte {
    
    /// Trouve toutes les cellules vides éliminées dans la zone par l'éliminatrice
    static func instances(zone: AnyZone, eliminatrice: Presence, dans puzzle: Puzzle) -> [Self] {
        guard puzzle.estEliminanteDirectement(eliminatrice) else {
            return []
        }
        return eliminatrice.region.cellulesDependantes.intersection(zone.cellules)
            .filter { puzzle.celluleEstVide($0) }
            .map { Self(eliminee: $0, eliminatrice: eliminatrice) }
    }
    
    /// Trouve toutes les éliminatrices qui éliminent la cellule pour une valeur donnée
    static func instances(cellule: Cellule, valeur: Int, dans puzzle: Puzzle) -> [Self] {
        return cellule.dependantes.filter {
            puzzle.valeur($0) == valeur
        }.map {
            Self(eliminee: cellule, eliminatrice: Presence([valeur], dans: [$0]))
        }
    }
    
    /// Les cellules vides éliminées directement dans la zone pour la valeur
    /// sans préciser par quelles éliminatrices
    static func instances(valeur: Int, zone: AnyZone, dans puzzle: Puzzle) -> [Self] {
        let eliminatrices = SingletonEliminateur.instances(valeur: valeur, zone: zone, dans: puzzle).map { $0.singleton }
        let eliminees = eliminatrices.flatMap {
            EliminationDirecte.instances(zone: zone, eliminatrice: $0, dans: puzzle) }
        return eliminees.map { Self(eliminee: $0.eliminee, eliminatrice: $0.eliminatrice) }
    }
}


// MARK: - Litteral


extension EliminationDirecte: CodableEnLitteral {
    
    public var litteral: Self.Litteral {
        Self.Litteral(eliminee: eliminee.nom, eliminatrice: eliminatrice.nom)
    }
    
    init(litteral: Litteral) {
        self.eliminee = Cellule(nom: litteral.eliminee)
        self.eliminatrice = Presence(nom: litteral.eliminee)
    }
    
    /// Mêmes champs, avec les noms
    public  struct Litteral: UnLitteral {
        
        let eliminee: String
        let eliminatrice: String
        
        public init(eliminee: String, eliminatrice: String) {
            self.eliminee = eliminee
            self.eliminatrice = eliminatrice
        }
        
        public var codeSwift: String {
            "EliminationDirecte.Litteral(cellule: \(eliminee), eliminatrice: \(eliminatrice))"
        }
    }
}



