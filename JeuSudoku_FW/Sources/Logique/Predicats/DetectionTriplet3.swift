//
//  SujetPaire3.swift
//  JeuSudoku_FW
//
//  Created by Gérard Tisseau on 13/03/2023.
//

import Foundation

/// Il existe un `triplet` détecté dans la `zone` parce qu'il ne reste plus que deux cellules
/// pour 2 valeurs en dehors des `occupees` et des `eliminees`.
/// `tripletsEliminateurs` est l'ensemble des triplets de singletons qui permettent de trouver les éliminées
struct DetectionTriplet3 {
    // Sujet
    let triplet: Presence
    // Parametres
    let zone: AnyZone
    let occupees: [Cellule]
    let eliminees: [Cellule]
    let tripletsEliminateurs: [[Presence]]
}


extension DetectionTriplet3 {
    
    var valeurs: [Int] {
        triplet.valeurs.array.sorted()
    }
    
    var cellules: [Cellule] {
        triplet.region.array.sorted()
    }
}

// MARK: - Requetes
    
extension DetectionTriplet3 {
    
    /// Les triplet3 bijectifs découverts (un ou zéro) dans la zone pour le triplet de valeurs.
    static func instances(zone: AnyZone, pour valeurs: (Int, Int, Int), dans puzzle: Puzzle) -> [Self] {
        
        let eliminations = eliminations(zone: zone, pour: valeurs, dans: puzzle)
        let eliminees = eliminees(zone: zone, par: eliminations, dans: puzzle)
        let tripletsEliminateurs = tripletsEliminateurs(pour: valeurs, eliminations: eliminations, eliminees: eliminees, dans: puzzle)
        let occupees = zone.cellules.filter { puzzle.celluleEstResolue($0) }
        
        guard let triplet3 = triplet3(zone: zone, valeurs: valeurs, eliminees: eliminees, occupees: occupees.array) else {
            return []
        }
        
        return [DetectionTriplet3(triplet: triplet3, zone: zone, occupees: occupees.array.sorted(), eliminees: eliminees.sorted(), tripletsEliminateurs: tripletsEliminateurs)]
    }

    // MARK: Utilitaires pour requêtes
    
    /// Retourne un dico valeur -> [CelluleElimineeDirectement(eliminee, eliminatrice)]
    static func eliminations(zone: AnyZone, pour valeurs: (Int, Int, Int), dans puzzle: Puzzle) -> [Int: [EliminationDirecte]] {
        let (x1, x2, x3) = valeurs
        
        let elimination1 = EliminationDirecte.instances(valeur: x1, zone: zone, dans: puzzle)
        let elimination2 = EliminationDirecte.instances(valeur: x2, zone: zone, dans: puzzle)
        let elimination3 = EliminationDirecte.instances(valeur: x3, zone: zone, dans: puzzle)
        return [x1: elimination1, x2: elimination2, x3: elimination3]

    }

    /// les cellules de la zone qui sont éliminées pour les 3 valeurs à la fois
    /// On donne un dico : valeur -> éliminations (celluleEliminee, singletonEliminateur) trouvées pour cette valeur
    static func eliminees(zone: AnyZone, par eliminations: [Int: [EliminationDirecte]], dans puzzle: Puzzle) -> [Cellule] {

        var ensemble = zone.cellules
        for (_, celluleEliminee) in eliminations {
            let eliminees = celluleEliminee.map { $0.eliminee }.ensemble
            ensemble = ensemble.intersection(eliminees)
        }
        return  ensemble.array.sorted()
    }
    
    /// Les triplets de singletons présents qui éliminent les 3 valeurs à la fois
    static func tripletsEliminateurs(pour valeurs: (Int, Int, Int), eliminations: [Int: [EliminationDirecte]], eliminees: [Cellule], dans puzzle: Puzzle) -> [[Presence]] {
        let (x1, x2, x3) = valeurs
        let (elimination1, elimination2, elimination3) = (eliminations[x1]!, eliminations[x2]!, eliminations[x3]!)
        var tripletsEliminateurs = [[Presence]]()
        for eliminee in eliminees {
            let e1 = elimination1.filter { $0.eliminee == eliminee }.map { $0.eliminatrice.region.uniqueElement }[0]
            let e2 = elimination2.filter { $0.eliminee == eliminee }.map { $0.eliminatrice.region.uniqueElement }[0]
            let e3 = elimination3.filter { $0.eliminee == eliminee }.map { $0.eliminatrice.region.uniqueElement }[0]
            let tripletEliminateur = [Presence([x1], dans: [e1]), Presence([x2], dans: [e2]), Presence([x3], dans: [e3])]
            tripletsEliminateurs.append(tripletEliminateur)
        }
        return tripletsEliminateurs
    }
    
    /// Le triplet3 bijectif découvert
    static func triplet3(zone: AnyZone, valeurs: (Int, Int, Int), eliminees: [Cellule], occupees: [Cellule]) -> Presence? {
        let (x1, x2, x3) = valeurs
       let cellulesRestantes = zone.cellules.subtracting(eliminees.ensemble.union(occupees))
        if cellulesRestantes.count != 3 {
            return nil
        }
        return Presence([x1, x2, x3], dans: cellulesRestantes)
    }

        
}

// MARK: - Litteral


extension DetectionTriplet3 {
    
    struct Litteral: UnLitteral {
        
        let triplet: String
        let zone: String
        let occupees: [String]
        let eliminees: [String]
        let tripletsEliminateurs: [[String]]
        
        var codeSwift: String {
            "Triplet3.Litteral(triplet: \(triplet), zone: \(zone), occupees: \(occupees), eliminees: \(eliminees), tripletsEliminateurs: \(tripletsEliminateurs))"
        }
    }

}

extension DetectionTriplet3: CodableEnLitteral {
    
    var litteral: Self.Litteral {
        Self.Litteral(triplet: triplet.nom, zone: zone.nom, occupees: occupees.map { $0.nom }, eliminees: eliminees.map { $0.litteral }, tripletsEliminateurs: tripletsEliminateurs.map { t in t.map { $0.nom }})
    }
    
    init(litteral: Litteral) {
        self.triplet = Presence(nom: litteral.triplet)
        self.zone = Grille.laZone(nom: litteral.zone)
        self.occupees = litteral.occupees.map { Cellule(nom: $0) }
        self.eliminees = litteral.eliminees.map { Cellule(nom: $0) }
        self.tripletsEliminateurs = litteral.tripletsEliminateurs.map { t in t.map { Presence(nom: $0) }}
    }
}
