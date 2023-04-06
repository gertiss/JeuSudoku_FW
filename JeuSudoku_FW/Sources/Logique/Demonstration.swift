//
//  Demonstration.swift
//  JeuSudoku_FW
//
//  Created by Gérard Tisseau on 09/03/2023.
//

import Foundation
import Modelisation_FW

/// Les faits nécessaires à la démonstration du coup `presence`.
/// Quel que soit le puzzle, si ces faits sont vérifiés, alors le coup est démontré.
/// Donc il s'agit d'une sorte de pattern, de règle.
public struct Demonstration: CodableEnLitteral {
    
    /// La présence détectée
    public var presence: Presence
    public var zone: any UneZone
    public var occupees: [Cellule]
    public var eliminatrices: [Presence]
    public var eliminees: [Cellule]
    public var auxiliaires: [Auxiliaire]
    
    public init(presence: Presence, zone: any UneZone, occupees: [Cellule],eliminatrices: [Presence], eliminees: [Cellule],  auxiliaires: [Auxiliaire]) {
        self.presence = presence
        self.zone = zone
        self.occupees = occupees
        self.eliminatrices = eliminatrices
        self.eliminees = eliminees
        self.auxiliaires = auxiliaires
    }
    
    public init(litteral: DemonstrationLitterale) {
        self.presence = Presence(nom: litteral.presence)
        self.zone = Grille.laZone(nom: litteral.zone)
        self.occupees = litteral.occupees.map { Cellule(nom: $0) }.sorted()
        self.eliminatrices = litteral.eliminatrices.map { Presence(nom: $0) }.sorted()
        self.eliminees = litteral.eliminees.map { Cellule(nom: $0) }.sorted()
        self.auxiliaires = litteral.auxiliaires.map { Auxiliaire(litteral: $0) }
    }
    
    public var litteral: DemonstrationLitterale {
        .init(
            presence: presence.nom,
            zone: zone.nom,
            occupees: occupees.map { $0.nom }.sorted(),
            eliminatrices: eliminatrices.map { $0.nom }.sorted(),
            eliminees: eliminees.map { $0.nom }.sorted(),
            auxiliaires: auxiliaires.map { $0.litteral })
    }
    
}

public struct Auxiliaire: CodableEnLitteral {
    /// La présence détectée
    public var presence: Presence
    public var zone: any UneZone
    public var occupees: [Cellule]
    public var eliminatrices: [Presence]
    public var eliminees: [Cellule]
    
    public init(litteral: AuxiliaireLitteral) {
        self.presence = Presence(nom: litteral.presence)
        self.zone = Grille.laZone(nom: litteral.zone)
        self.occupees = litteral.occupees.map { Cellule(nom: $0) }.sorted()
        self.eliminatrices = litteral.eliminatrices.map { Presence(nom: $0) }.sorted()
        self.eliminees = litteral.eliminees.map { Cellule(nom: $0) }.sorted()
    }
    
    public var litteral: AuxiliaireLitteral {
        .init(
            presence: presence.nom,
            zone: zone.nom,
            occupees: occupees.map { $0.nom }.sorted(),
            eliminees: eliminees.map { $0.nom }.sorted(),
            eliminatrices: eliminatrices.map { $0.nom }.sorted())
    }
    
}

extension Puzzle {
    
    
    /// Etant donnée une Demonstration instanciée, est-elle applicable ?
    /// Pour une vérification ou une recherche avec des essais.
    func patternEstApplicable(_ pattern: Demonstration) -> Bool {
        guard pattern.presence.type == .singleton1 else {
            fatalError()
        }
        // La présence a bien une valeur unique et une cellule unique
        guard let valeurTrouvee = pattern.presence.valeurs.uniqueValeur else {
            return false
        }
        guard let celluleTrouvee = pattern.presence.region.uniqueValeur else {
            return false
        }
       // La cellule trouvée est bien dans la zone
        guard pattern.zone.cellules.contains(celluleTrouvee) else {
            return false
        }
        // La cellule trouvée est bien vide
        guard !celluleEstResolue(celluleTrouvee) else {
            return false
        }
        // Les cellules occupées sont bien résolues
        guard (pattern.occupees.allSatisfy { celluleEstResolue($0) }) else {
            return false
        }
        // Les cellules occupées sont bien dans la zone
        guard (pattern.occupees.allSatisfy { pattern.zone.cellules.contains($0) }) else {
            return false
        }
        // Les présences éliminatrices sont bien éliminantes pour valeurTrouvee
        guard (pattern.eliminatrices.allSatisfy { contrainteEstEliminante($0, pour: valeurTrouvee) }) else {
            return false
        }
       // Les cellules éliminées sont effectivement celles qui sont éliminées dans la zone par les éliminatrices
        // Ici "éliminées" dans le pattern n'inclut pas les cellules occupées.
        var elimineesDansZone = Region()
        for eliminatrice in pattern.eliminatrices {
            elimineesDansZone = elimineesDansZone.union(cellulesEliminees(par: eliminatrice, pour: valeurTrouvee)).intersection(pattern.zone.cellules)
        }
        guard elimineesDansZone == pattern.eliminees.ensemble.union(pattern.occupees) else {
            return false
        }
        // Il ne reste plus qu'une seule cellule libre après élimination
        let restantes = pattern.zone.cellules.subtracting(pattern.occupees.ensemble.union(pattern.eliminees.ensemble))
        guard restantes.count == 1 else {
            return false
        }
        if pattern.auxiliaires.isEmpty { return true }
        fatalError("à terminer: auxiliaires")
    }
    
}


