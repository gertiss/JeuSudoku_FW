//
//  Coup_Paire2.swift
//  JeuSudoku_FW
//
//  Created by Gérard Tisseau on 20/03/2023.
//

import Foundation
import Modelisation_FW

/// Le singleton est détecté parce qu'il est la dernière cellule restante dans la zone en dehors des éliminées, des occupées.et de la paire2.
struct Coup_Paire2: UnCoup {
    
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
    
    // On ne garde que les cellules éliminées qui ne sont pas dans la paire
    var eliminees: [Cellule] {
        eliminationsDirectes
            .filter { !paire.region.contains($0.eliminee) }
            .map { $0.eliminee }
            .ensemble.array.sorted()
    }
    
    var paire: Presence {
        detectionPaire2.paire2
    }
    
    // On ne garde que les éliminatrices directes des cellules qui ne sont pas dans la paire
    var eliminatrices: [Presence] {
        eliminationsDirectes
            .filter { !paire.region.contains($0.eliminee) }
            .map { $0.eliminatrice }
            .ensemble.array.sorted()
    }

    var nombreDeCellulesVides: Int {
        9 - occupees.count
    }
    
    var signature: SignatureCoup {
        .init(typeCoup: .paire2, typeZone: zone.type.rawValue, nbDirects: eliminatrices.count, nbIndirects: 0, nbPaires2: 1, nbTriplets3: 0)
    }

    var typeCoup: TypeCoup { .paire2 }
    
    var typeZone: TypeZone { zone.type }

    var paire2: DetectionPaire2? { detectionPaire2 }
    
    var explication: String {
"""
On joue \(singleton.litteral) dans \(zone.texteLaZone).
En effet :
\(paire2!.explication)
De plus on élimine \(eliminationsDirectes.map { $0.eliminee.litteral }) par \(eliminationsDirectes.map { $0.eliminatrice.litteral }.ensemble.array.sorted()).
La seule cellule libre restante pour \(valeur) dans \(zone.texteLaZone) est \(singleton.region.uniqueElement.litteral).
"""
        
    }
    
    var rolesCellules: [Cellule_: Coup_.RoleCellule] {
        var dico = [Cellule_: Coup_.RoleCellule]()
        // Eliminations directes
        for elimineeDirecte in eliminationsDirectes.map({ $0.eliminee }) {
            dico[elimineeDirecte.litteral] = .eliminee
        }
        for eliminatriceDirecte in eliminatrices.map({ $0.uniqueCellule }) {
            dico[eliminatriceDirecte.litteral] = .eliminatrice
        }
        // Paire2. Eliminations pour détecter la paire
        for eliminee in detectionPaire2.eliminees {
            dico[eliminee.litteral] = .eliminee
        }
        let eliminatricesPourPaire = detectionPaire2.pairesEliminatrices.flatMap { couple in
            couple.map { $0.uniqueCellule }
        }
        for eliminatrice in eliminatricesPourPaire {
            dico[eliminatrice.litteral] = .eliminatrice
        }
        for auxiliaire in detectionPaire2.paire2.region {
            dico[auxiliaire.litteral] = .auxiliaire
        }
        // A faire à la fin parce que cette cellule était considérée comme éliminée
        // pour trouver la paire2
        dico[singleton.uniqueCellule.litteral] = .cible
        return dico
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
                        /// On a bien trouvé un `singleton` dans la `zone` pour la `valeur`, à partir de la `paire2` trouvée dans `detection`.
                        /// Il faut construire le coup
                        /// On ne s'intéresse qu'aux éliminations directes avec des eliminees en dehors de la paire2, c'est-à-dire à cellulesComplementaires
                        let eliminationsDirectes = EliminationDirecte.instances(valeur: valeur, zone: zone, dans: puzzle)
                            .filter { !detection.paire2.region.contains($0.eliminee) }
                        print("eliminationsDirectes: \(eliminationsDirectes.litteral)")
                        let cibles = cellulesComplementaires.subtracting([singleton.uniqueCellule])
                        print("cibles: \(cibles.litteral.compact)")
                        let eliminationsDirectesSuffisantes = eliminationsDirectes.avecMinimisation(cibles: cibles, dans: puzzle)
                        print("suffisantes: \(eliminationsDirectesSuffisantes.litteral)")
                        
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

public struct Coup_Paire2_: UnLitteral, Equatable {
    public let singleton: Presence_
    public let zone: AnyZone_
    public let occupees: [Cellule_]
    public let eliminationsDirectes: [EliminationDirecte_]
    public let detectionPaire2: DetectionPaire2_
    
    public var codeSwift: String {
        """
Coup_Paire2_ (
    singleton: \(singleton.codeSwift),
    zone: \(zone.codeSwift),
    occupees: \(occupees.codeSwift),
    eliminationsDirectes: \(eliminationsDirectes.codeSwift),
    detectionPaire2: \(detectionPaire2.codeSwift))
"""
    }
}

public extension Coup_Paire2_ {
    
    var eliminees: [Cellule_] {
        Coup_Paire2(litteral: self).eliminees.map { $0.litteral }.sorted()
    }
    
    var eliminatrices: [Presence_] {
        Coup_Paire2(litteral: self).eliminatrices.map { $0.litteral }.sorted()
    }
    
    var signature: SignatureCoup {
        Coup_Paire2(litteral: self).signature
    }


}
