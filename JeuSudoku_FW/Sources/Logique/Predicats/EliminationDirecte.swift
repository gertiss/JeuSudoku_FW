//
//  SujetCellule.swift
//  JeuSudoku_FW
//
//  Created by Gérard Tisseau on 13/03/2023.
//

import Foundation
import Modelisation_FW




/// `eliminee` est une cellule vide éliminée directement par `eliminatrice` (un singleton)
/// pour la valeur du singleton
struct EliminationDirecte: Hashable {
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
            .sorted { e1, e2 in
                e1.eliminee < e2.eliminee
            }
    }
    
    /// Trouve toutes les éliminatrices qui éliminent la cellule pour une valeur donnée
    static func instances(cellule: Cellule, valeur: Int, dans puzzle: Puzzle) -> [Self] {
        return cellule.dependantes.filter {
            puzzle.valeur($0) == valeur
        }.map {
            Self(eliminee: cellule, eliminatrice: Presence([valeur], dans: [$0]))
        }
        .sorted { e1, e2 in
            e1.eliminee < e2.eliminee
        }
    }
    
    /// Les cellules vides éliminées directement dans la zone pour la valeur
    /// sans préciser par quelles éliminatrices
    static func instances(valeur: Int, zone: AnyZone, dans puzzle: Puzzle) -> [Self] {
        let eliminatrices = SingletonConnu.instances(valeur: valeur, zone: zone, dans: puzzle).map { $0.singleton }
        let eliminees = eliminatrices.flatMap {
            EliminationDirecte.instances(zone: zone, eliminatrice: $0, dans: puzzle) }
        return eliminees.map { Self(eliminee: $0.eliminee, eliminatrice: $0.eliminatrice) }
            .sorted { e1, e2 in
                e1.eliminee < e2.eliminee
            }
    }

}


// MARK: - Litteral


extension EliminationDirecte: CodableEnLitteral {
    typealias Litteral = EliminationDirecte_
    
    public var litteral: Self.Litteral {
        Self.Litteral(eliminee: eliminee.nom, eliminatrice: eliminatrice.nom)
    }
    
    init(litteral: Litteral) {
        self.eliminee = Cellule(nom: litteral.eliminee)
        self.eliminatrice = Presence(nom: litteral.eliminatrice)
    }
    
    /// Mêmes champs, avec les noms

}


extension [EliminationDirecte] {
    
    /// Minimise l'ensemble des éliminations pour éliminer seulement les cibles.
    /// On suppose que les éliminations éliminent effectivement les cibles au départ.
    func avecMinimisation(cibles: Region, dans puzzle: Puzzle) -> [EliminationDirecte] {
//        assert(estSuffisantPourElimination(cibles: cibles, dans: puzzle))
        
        // On ordonne les eliminatrices suivant leurs pouvoirs éliminateurs
        // pour les cibles.
        let eliminationsClassees = self.sorted { e1, e2 in
            let pouvoir1 = puzzle.pouvoirEliminateur(singleton: e1.eliminatrice, cibles: cibles)
            let pouvoir2 = puzzle.pouvoirEliminateur(singleton: e2.eliminatrice, cibles: cibles)
            return pouvoir1 > pouvoir2
        }
        // On actionne chaque éliminatrice dans l'ordre jusqu'à éliminer toutes les cibles
        var eliminationsSuffisantes = [EliminationDirecte]()
        var ciblesRestantes = cibles
        var dejaEliminees = Region()
        for e in eliminationsClassees {
            if dejaEliminees.contains(e.eliminee) {
                continue
            }
            if eliminationsSuffisantes.estSuffisantPourElimination(cibles: cibles, dans: puzzle) {
                return eliminationsSuffisantes
            }
            eliminationsSuffisantes.append(e)
            ciblesRestantes = ciblesRestantes.subtracting([e.eliminee])
            dejaEliminees.insert(e.eliminee)
        }
        return eliminationsSuffisantes
    }
    
    func estSuffisantPourElimination(cibles: Region, dans puzzle: Puzzle) -> Bool {
        let eliminees = self.eliminees(dans: puzzle)
        return cibles.intersection(eliminees).count == cibles.count
    }
    
    /// l'ensemble des éliminations suffit-il pour éliminer toutes les cibles sauf une ?
    func estSuffisantPourDetectionSingleton(cibles: Region, dans puzzle: Puzzle) -> Bool {
        let eliminees = self.eliminees(dans: puzzle)
        return cibles.intersection(eliminees).count == cibles.count - 1
    }
    
    /// Les cellules éliminées par l'ensemble des éliminations
    func eliminees(dans puzzle: Puzzle) -> Region {
        map { $0.eliminee }.ensemble
    }
    
}

public struct EliminationDirecte_: UnLitteral, Equatable {
    
    public let eliminee: Cellule_
    public let eliminatrice: Presence_ 
    
    public init(eliminee: String, eliminatrice: String) {
        self.eliminee = eliminee
        self.eliminatrice = eliminatrice
    }
    
    public var codeSwift: String {
        "EliminationDirecte_(eliminee: \(eliminee.codeSwift), eliminatrice: \(eliminatrice.codeSwift))"
    }
}
