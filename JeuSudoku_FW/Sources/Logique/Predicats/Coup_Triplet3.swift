//
//  Coup_Triplet3.swift
//  JeuSudoku_FW
//
//  Created by Gérard Tisseau on 26/03/2023.
//

import Foundation
import Modelisation_FW

struct Coup_Triplet3 {
    let singleton: Presence
    let zone: AnyZone
    let occupees: [Cellule]
    let eliminationsDirectes: [EliminationDirecte]
    let detectionTriplet3: DetectionTriplet3
}

extension Coup_Triplet3 {
    
    var valeur: Int {
        singleton.valeurs.uniqueElement
    }
}

extension Coup_Triplet3 {
    
    /// Trouve tous les coups par paire2 pour la valeur dans la zone.
    /// Un coup au plus.
    static func instances(zone: AnyZone, parmi nombreCellulesVides: Int, dans puzzle: Puzzle) -> [Self] {

        let zonesInteressantes = puzzle.zonesClasseesParRemplissage.filter {
            puzzle.cellulesNonResolues(dans: $0).ensemble.count == nombreCellulesVides
        }
        let occupees = puzzle.cellulesResolues(dans: zone).sorted()

        for zone in zonesInteressantes {
            let cellulesVides = puzzle.cellulesNonResolues(dans: zone).ensemble
            let valeursAbsentes = puzzle.valeursAbsentes(dans: zone)
            // Vérifications paranoïaques
            assert(cellulesVides.count == nombreCellulesVides)
            assert(valeursAbsentes.ensemble.count == nombreCellulesVides)
            
            // Recherche d'un triplet3
            let combinaisonsValeurs = combinaisons3(parmi: nombreCellulesVides)
                .map { i, j, k in (valeursAbsentes[i], valeursAbsentes[j], valeursAbsentes[k]) }
            
            for (x1, x2, x3) in combinaisonsValeurs {
                let detections = DetectionTriplet3.instances(zone: zone, pour: (x1, x2, x3), dans: puzzle)
                if detections.isEmpty { continue }
                assert(detections.count == 1)
                let detection = detections[0]
                // On a trouvé une DetectionTriplet3 pour (x1, x2, x3)
                // Il faut trouver un coup avec.
                // on recherche un singleton par élimination pour une valeur
                // absente et qui n'est pas dans la paire.
                let cellulesComplementaires = cellulesVides.subtracting(detection.triplet.region)
                let valeursComplementaires =
                valeursAbsentes.ensemble.subtracting(detection.triplet.valeurs)
                for valeur in valeursComplementaires {
                    if let singleton = puzzle.singleton1DetecteParEliminationDirecte(pour: valeur, dans: cellulesComplementaires, zone: zone), puzzle.estNouveauSingletonValide(singleton) {
                        let eliminationsDirectes = EliminationDirecte.instances(valeur: valeur, zone: zone, dans: puzzle)
                        // Ici, minimiser les éliminations directes
                        // pour éliminer seulement les cellules en dehors de la paire
                        let eliminationsDirectesSuffisantes = eliminationsDirectes.avecMinimisation(cibles: cellulesComplementaires, dans: puzzle)
                        let coup = Coup_Triplet3 (
                            singleton: singleton,
                            zone: zone,
                            occupees: occupees,
                            eliminationsDirectes: eliminationsDirectesSuffisantes,
                            detectionTriplet3: detection)
                        return [coup]
                    }
                }
            }
       }
        return []
    }

}

extension Coup_Triplet3: CodableEnLitteral {
    typealias Litteral = Coup_Triplet3_
    
    var litteral: Litteral {
        Self.Litteral(
            singleton: singleton.litteral,
            zone: zone.litteral,
            occupees: occupees.map { $0.litteral },
            eliminationsDirectes: eliminationsDirectes.map { $0.litteral },
            detectionTriplet3: detectionTriplet3.litteral
        )
    }
    
    init(litteral: Litteral) {
        self.singleton = Presence(nom: litteral.singleton)
        self.zone = Grille.laZone(litteral: litteral.zone)
        self.occupees = litteral.occupees.map { Cellule(litteral: $0) }
        self.eliminationsDirectes = litteral.eliminationsDirectes.map { EliminationDirecte(litteral: $0) }
        self.detectionTriplet3 = DetectionTriplet3(litteral: litteral.detectionTriplet3)
    }


    
}

public struct Coup_Triplet3_: UnLitteral {
    public let singleton: String
    public let zone: String
    public let occupees: [String]
    public let eliminationsDirectes: [EliminationDirecte_]
    public let detectionTriplet3: DetectionTriplet3_
    
    public var codeSwift: String {
        """
Coup_Triplet3_ (
    singleton: \(singleton.debugDescription),
    zone: \(zone.debugDescription),
    occupees: \(occupees.debugDescription),
    eliminationsDirectes: \(eliminationsDirectes.debugDescription),
        detectionTriplet3: \(detectionTriplet3))
"""
    }
}
