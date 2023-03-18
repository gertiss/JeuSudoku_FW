//
//  SujetPaire1.swift
//  JeuSudoku_FW
//
//  Created by Gérard Tisseau on 13/03/2023.
//

import Foundation

/// La `paire1` alignée est détectée dans la zone parce qu'il ne reste plus que deux cellules alignées
/// pour une valeur en dehors des occupées et et des éliminées
/// Attention : AnyZone empêche le protocole Codable.
struct DetectionPaire1 {

    let paire1: Presence
    
    let zone: AnyZone
    let occupees: [Cellule]
    let eliminees: [Cellule]
    let eliminatrices: [Cellule] 
    
    var valeur: Int {
        paire1.valeurs.uniqueElement
    }
}

extension DetectionPaire1 {
    /// Trouve toutes les paires1 alignées trouvées dans la zone pour la valeur donnée. Une ou zéro.
    static func instances(valeur: Int, zone: AnyZone, dans puzzle: Puzzle) -> [Self] {
        
        let occupees = zone.cellules.filter { puzzle.celluleEstResolue($0) }
        let eliminations = EliminationDirecte.instances(valeur: valeur, zone: zone, dans: puzzle)
        let eliminees = eliminations.map { $0.eliminee }.compact
        let restantes = zone.cellules.subtracting(occupees.union(eliminees))
        let eliminatrices = eliminations.map { $0.eliminatrice.region.uniqueElement }
        
        guard restantes.count == 2 else { return [] }
        return [Self(
            paire1: Presence([valeur], dans: restantes),
            zone: zone,
            occupees: occupees.array.sorted(),
            eliminees: eliminees,
            eliminatrices: eliminatrices.ensemble.array.sorted()
        )]
    }
    
    /// Trouve toutes les paires1 alignées pour la valeur donnée qui ciblent la zoneCible. Une ou zéro.
    /// On se limite aux paires1 qui éliminent au moins une cellule vide non éliminée dans la zoneCible.
    static func instances(valeur: Int, ciblant zoneCible: AnyZone, dejaEliminees: [Cellule], dans puzzle: Puzzle) -> [Self] {
        
        var resultat = [Self]()
        for zone in Grille.zones {
            let paires1 = DetectionPaire1.instances(valeur: valeur, zone: zone, dans: puzzle)
            let paires1Ciblantes = paires1.filter {
                $0.cible(zoneCible: zoneCible, valeur: valeur, dejaEliminees: dejaEliminees, dans: puzzle)
            }
            resultat = resultat + paires1Ciblantes
        }
        return resultat
    }
    
    /// Une Paire1 cible une zone pour une valeur si elle élimine  des cellules vides de la zone,
    /// non déjà éliminées
    func cible(zoneCible: AnyZone, valeur: Int,  dejaEliminees: [Cellule], dans puzzle: Puzzle) -> Bool {
        let presence = paire1
        let elimineesExternes = puzzle.cellulesExternesEliminees(par: presence, pour: valeur)
        let elimineesCiblees = elimineesExternes.filter { cellule in
            zoneCible.cellules.contains(cellule)
            && puzzle.celluleEstVide(cellule)
            && !dejaEliminees.contains(cellule)
        }
        return !elimineesCiblees.isEmpty
    }
}

// MARK: - Litteral

extension DetectionPaire1: CodableEnLitteral {
    
    var litteral: Self.Litteral {
        Self.Litteral(paire1: paire1.litteral, zone: zone.litteral, occupees: occupees.map { $0.litteral }, eliminees: eliminees.map { $0.litteral }, eliminatrices: eliminatrices.map { $0.litteral } )
    }
    
    init(litteral: Litteral) {
        self.paire1 = Presence(litteral: litteral.paire1)
        self.zone = Grille.laZone(litteral: litteral.zone)
        self.occupees = litteral.occupees.map { Cellule(litteral: $0) }
        self.eliminees = litteral.eliminees.map { Cellule(litteral: $0) }
        self.eliminatrices = litteral.eliminatrices.map { Cellule(litteral: $0) }
    }
    
    /// Les attributs de Paire1.Litteral correspondent directement aux littéraux des attributs de Paire1
    struct Litteral: UnLitteral {
        let paire1: String
        
        let zone: String
        let occupees: [String]
        let eliminees: [String]
        let eliminatrices: [String]
        
        var texte: String {
            "Paire1.Litteral(paire1: \(paire1.description), zone: \(zone.description), occupees: \(occupees.description), eliminees: \(eliminees.description), eliminatrices: \(eliminatrices.description))"
        }

    }
    
}

