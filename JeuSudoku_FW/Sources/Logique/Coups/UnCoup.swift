//
//  UnCoup.swift
//  JeuSudoku_FW
//
//  Created by Gérard Tisseau on 09/04/2023.
//

import Foundation

/// Permet de mettre à plat de manière unifiée les méthodes des différents types de coups
protocol UnCoup {
    
    var typeCoup: TypeCoup { get }
    var typeZone: TypeZone { get }
    var zone: AnyZone { get }
    var singleton: Presence { get }
    var eliminatrices: [Presence] { get }
    var signature: SignatureCoup { get }
    var explication: String { get }

    var indirecte: EliminationIndirecte? { get }
    var paire2: DetectionPaire2? { get }
    var triplet3: DetectionTriplet3? { get }
    var rolesCellules: [Cellule_: Coup_.RoleCellule] { get }
}

extension UnCoup {
    // Seuls les types concrets concernés redéfinissent ces méthodes
    // En fait, un type ne redéfinit au maximum qu'une seule de ces méthodes.
    var indirecte: EliminationIndirecte? { nil }
    var paire2: DetectionPaire2? { nil }
    var triplet3: DetectionTriplet3? { nil }
    
    var rolesCellules: [Cellule_: Coup_.RoleCellule] {
        [Cellule_: Coup_.RoleCellule]()
    }

}
