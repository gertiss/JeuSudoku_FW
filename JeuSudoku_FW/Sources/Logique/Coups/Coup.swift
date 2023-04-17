//
//  Coup.swift
//  JeuSudoku_FW
//
//  Created by Gérard Tisseau on 27/03/2023.
//

import Foundation
import Modelisation_FW

enum Coup: Equatable, UnCoup {
    
    
    case derniereCellule(Coup_DerniereCellule)
    case eliminationDirecte(Coup_EliminationDirecte)
    case eliminationIndirecte(Coup_EliminationIndirecte)
    case paire2(Coup_Paire2)
    case triplet3(Coup_Triplet3)
    
    static func == (lhs: Coup, rhs: Coup) -> Bool {
        lhs.codeSwift == rhs.codeSwift
    }
    
    /// Toutes les valeurs associées vérifient le protocole `UnCoup`.
    /// C'est une façon de simuler la délégation, et cela de manière statique :
    /// une instance de `Coup` peut déléguer les méthodes du protocole à sa `valeur`
    /// et donc Coup peut être rendu conforme au protocole.
    var valeur: any UnCoup {
        switch self {
        case .derniereCellule(let coup_DerniereCellule):
            return coup_DerniereCellule
        case .eliminationDirecte(let coup_EliminationDirecte):
            return coup_EliminationDirecte
        case .eliminationIndirecte(let coup_EliminationIndirecte):
            return coup_EliminationIndirecte
        case .paire2(let coup_Paire2):
            return coup_Paire2
        case .triplet3(let coup_Triplet3):
            return coup_Triplet3
        }
    }
    
    // Délégations à la valeur, sans switch
    
    var typeZone: TypeZone { valeur.typeZone }
    var zone: AnyZone { valeur.zone }
    var eliminatrices: [Presence] { valeur.eliminatrices}
    var singleton: Presence { valeur.singleton }
    var signature: SignatureCoup { valeur.signature }
    var typeCoup: TypeCoup { valeur.typeCoup }
    
    var indirecte: EliminationIndirecte? { valeur.indirecte }
    var paire2: DetectionPaire2? { valeur.paire2 }
    var triplet3: DetectionTriplet3? { valeur.triplet3 }
    var explication: String { valeur.explication }
}

public enum Coup_: UnLitteral, Equatable {
    case derniereCellule(Coup_DerniereCellule_)
    case eliminationDirecte(Coup_EliminationDirecte_)
    case eliminationIndirecte(Coup_EliminationIndirecte_)
    case paire2(Coup_Paire2_)
    case triplet3(Coup_Triplet3_)
    
    public var codeSwift: String {
        switch self {
        case .derniereCellule(let litteral):
            return "Coup_.derniereCellule(\(litteral.codeSwift))"
        case .eliminationDirecte(let litteral):
            return "Coup_.eliminationDirecte(\(litteral.codeSwift))"
        case .eliminationIndirecte(let litteral):
            return "Coup_.eliminationIndirecte(\(litteral.codeSwift))"
        case .paire2(let litteral):
            return "Coup_.paire2(\(litteral.codeSwift))"
        case .triplet3(let litteral):
            return "Coup_.triplet3(\(litteral.codeSwift))"
        }
    }
    
    public static func == (lhs: Coup_, rhs: Coup_) -> Bool {
        lhs.codeSwift == rhs.codeSwift
    }
    
}

// MARK: Méthodes issues du protocole UnCoup

// Permettent de voir toutes ces méthodes sans faire de switch et de les adapter aux littéraux.

public extension Coup_ {
    
    
    var typeCoup: TypeCoup {
        Coup(litteral: self).typeCoup
    }
    
    var typeZone: TypeZone {
        Coup(litteral: self).typeZone
    }
    
    var zone: String {
        Coup(litteral: self).zone.litteral
    }
    
    var singleton: Presence_ {
        Coup(litteral: self).singleton.litteral
    }
    
    var eliminatrices: [Presence_ ] {
        Coup(litteral: self).eliminatrices.litteral
    }
    
    var signature: SignatureCoup {
        Coup(litteral: self).signature
    }
    
    var indirecte: EliminationIndirecte_? {
        Coup(litteral: self).indirecte?.litteral
    }
    
    var paire2: DetectionPaire2_? {
        Coup(litteral: self).paire2?.litteral
    }
    
    var triplet3: DetectionTriplet3_? {
        Coup(litteral: self).triplet3?.litteral
    }
    
    var explication: String {
        Coup(litteral: self).explication
    }
    
    /// Rôle d'une cellule dans l'explication d'un coup
    enum RoleCellule: String, UnLitteral, CustomStringConvertible {
        
        case cible
        case eliminee
        case eliminatrice
        case auxiliaire
        
        public var codeSwift: String {
            "Coup_.RoleCellule.\(rawValue)"
        }
        
        public var description: String {
            ".\(rawValue)"
        }

    }
    
    var rolesCellules: [Cellule_: Coup_.RoleCellule] {
        Coup(litteral: self).valeur.rolesCellules
    }
    
}

extension Coup: CodableEnLitteral {
    typealias Litteral = Coup_
    
    var litteral: Coup_ {
        switch self {
        case .derniereCellule(let coup_DerniereCellule):
            return .derniereCellule(coup_DerniereCellule.litteral)
        case .eliminationDirecte(let coup_EliminationDirecte):
            return .eliminationDirecte(coup_EliminationDirecte.litteral)
        case .eliminationIndirecte(let coup_EliminationIndirecte):
            return .eliminationIndirecte(coup_EliminationIndirecte.litteral)
        case .paire2(let coup_Paire2):
            return .paire2(coup_Paire2.litteral)
        case .triplet3(let coup_Triplet3):
            return .triplet3(coup_Triplet3.litteral)
        }
    }
    
    init(litteral: Coup_) {
        switch litteral {
        case .derniereCellule(let litteral):
            self = .derniereCellule(Coup_DerniereCellule(litteral: litteral))
        case .eliminationDirecte(let litteral):
            self = .eliminationDirecte(Coup_EliminationDirecte(litteral: litteral))
        case .eliminationIndirecte(let litteral):
            self = .eliminationIndirecte(Coup_EliminationIndirecte(litteral: litteral))
        case .paire2(let litteral):
            self = .paire2(Coup_Paire2(litteral: litteral))
        case .triplet3(let litteral):
            self = .triplet3(Coup_Triplet3(litteral: litteral))
        }
    }
    
    public var codeSwift: String {
        // On suppose que l'interpolation \(objet) donne ce qu'on attend,
        // ce qui n'est pas évident
        switch self {
        case .derniereCellule(let objet):
            return "Coup.derniereCellule(\(objet))"
        case .eliminationDirecte(let objet):
            return "Coup.eliminationDirecte(\(objet))"
        case .eliminationIndirecte(let objet):
            return "Coup.eliminationIndirecte(\(objet))"
        case .paire2(let objet):
            return "Coup.paire2(\(objet))"
        case .triplet3(let objet):
            return "Coup.triplet3(\(objet))"
        }
    }
    
    public var description: String {
        codeSwift
    }
    
    
}
