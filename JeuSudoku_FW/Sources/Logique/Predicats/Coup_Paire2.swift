//
//  Coup_Paire2.swift
//  JeuSudoku_FW
//
//  Created by Gérard Tisseau on 20/03/2023.
//

import Foundation
import Modelisation_FW

/// Le singleton est détecté parce qu'il est la dernière cellule restante dans la zone en dehors des éliminées, des occupées.et de la paire2.
struct Coup_Paire2 {
        
    let singleton: Presence
    let zone: AnyZone
    let occupees: [Cellule]
    let eliminationsDirectes: [EliminationDirecte]
    let detectionPaire2: DetectionPaire2
}

extension Coup_Paire2 {
    
    var valeur: Int {
        singleton.valeurs.uniqueElement
    }
}

// MARK: - Requêtes

extension Coup_Paire2 {
    
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
            
            // Recherche d'une paire2
            let combinaisonsValeurs = combinaisons2(parmi: nombreCellulesVides)
                .map { i, j in (valeursAbsentes[i], valeursAbsentes[j]) }
            
            for (x1, x2) in combinaisonsValeurs {
                let detections = DetectionPaire2.instances(zone: zone, pour: (x1, x2), dans: puzzle)
                if detections.isEmpty { continue }
                assert(detections.count == 1)
                let detection = detections[0]
                // On a trouvé une DetectionPaire2 pour (x1, x2)
                // Il faut trouver un coup avec.
                // on recherche un singleton par élimination pour une valeur
                // absente et qui n'est pas dans la paire.
                let cellulesComplementaires = cellulesVides.subtracting(detection.paire2.region)
                let valeursComplementaires =
                valeursAbsentes.ensemble.subtracting(detection.paire2.valeurs)
                for valeur in valeursComplementaires {
                    if let singleton = puzzle.singleton1DetecteParEliminationDirecte(pour: valeur, dans: cellulesComplementaires, zone: zone), puzzle.estNouveauSingletonValide(singleton) {
                        let eliminationsDirectes = EliminationDirecte.instances(valeur: valeur, zone: zone, dans: puzzle)
                        // Ici, minimiser les éliminations directes
                        // pour éliminer seulement les cellules en dehors de la paire
                        let eliminationsDirectesSuffisantes = eliminationsDirectes.avecMinimisation(cibles: cellulesComplementaires, dans: puzzle)
                        let coup = Coup_Paire2(
                            singleton: singleton,
                            zone: zone,
                            occupees: occupees,
                            eliminationsDirectes: eliminationsDirectesSuffisantes,
                            detectionPaire2: detection)
                        return [coup]
                    }
                }
                
            }

       }
        return []
    }
    
}

extension Coup_Paire2: CodableEnLitteral {
    typealias Litteral = Coup_Paire2_

    var litteral: Litteral {
        Self.Litteral(
            singleton: singleton.litteral,
            zone: zone.litteral,
            occupees: occupees.map { $0.litteral },
            eliminationsDirectes: eliminationsDirectes.map { $0.litteral },
            detectionPaire2: detectionPaire2.litteral
        )
    }
    
    init(litteral: Litteral) {
        self.singleton = Presence(litteral: litteral.singleton)
        self.zone = Grille.laZone(litteral: litteral.zone)
        self.occupees = litteral.occupees.map { Cellule(litteral: $0) }
        self.eliminationsDirectes = litteral.eliminationsDirectes.map { EliminationDirecte(litteral: $0) }
        self.detectionPaire2 = DetectionPaire2(litteral: litteral.detectionPaire2)
    }
}

public struct Coup_Paire2_: UnLitteral {
    public let singleton: String
    public let zone: String
    public let occupees: [String]
    public let eliminationsDirectes: [EliminationDirecte_]
    public let detectionPaire2: DetectionPaire2_
    
    public var codeSwift: String {
        """
Coup_Paire2_ (
    singleton: \(singleton.debugDescription),
    zone: \(zone.debugDescription),
    occupees: \(occupees.debugDescription),
    eliminationsDirectes: \(eliminationsDirectes.debugDescription),
    detectionPaire2: \(detectionPaire2))
"""
    }
}
