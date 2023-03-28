//
//  Coup.swift
//  JeuSudoku_FW
//
//  Created by Gérard Tisseau on 27/03/2023.
//

import Foundation
import Modelisation_FW

enum Coup {
    case derniereCellule(Coup_DerniereCellule)
    case eliminationDirecte(Coup_EliminationDirecte)
    case eliminationIndirecte(Coup_EliminationIndirecte)
    case paire2(Coup_Paire2)
    case triplet3(Coup_Triplet3)
    case derniereValeur(Coup_DerniereValeur)
}

public enum Coup_: UnLitteral {
    case derniereCellule(Coup_DerniereCellule_)
    case eliminationDirecte(Coup_EliminationDirecte_)
    case eliminationIndirecte(Coup_EliminationIndirecte_)
    case paire2(Coup_Paire2_)
    case triplet3(Coup_Triplet3_)
    case derniereValeur(Coup_DerniereValeur_)
    
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
        case .derniereValeur(let litteral):
            return "Coup_.derniereValeur(\(litteral.codeSwift))"
        }
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
        case .derniereValeur(let coup_DerniereValeur):
            return .derniereValeur(coup_DerniereValeur.litteral)
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
        case .derniereValeur(let litteral):
            self = .derniereValeur(Coup_DerniereValeur(litteral: litteral))
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
        case .derniereValeur(let objet):
            return "Coup.derniereValeur(\(objet))"
        }
    }
    
    public var description: String {
        codeSwift
    }

    
}
