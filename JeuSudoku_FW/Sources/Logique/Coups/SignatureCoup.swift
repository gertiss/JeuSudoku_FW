//
//  SignatureCoup.swift
//  JeuSudoku_FW
//
//  Created by Gérard Tisseau on 07/04/2023.
//

import Foundation
import Modelisation_FW

public enum TypeCoup: String, UnLitteral {
    
    case derniereCellule
    case eliminationDirecte
    case eliminationIndirecte
    case paire2
    case triplet3
    
    public var codeSwift: String {
        return "TypeCoup.\(rawValue)"
    }

}

/// Décrit le type de coup, avec des indications sur les faits qu'il faut détecter.
/// Chaque coup peut calculer sa signature.
public struct SignatureCoup: UnLitteral, Equatable {

    public let typeCoup: TypeCoup
    public let typeZone: String
    public let nbDirects: Int
    public let nbIndirects: Int
    public let nbPaires2: Int // 0 ou 1
    public let nbTriplets3: Int // 0 ou 1
    
    public var codeSwift: String {
        "SignatureCoup(typeCoup: \(typeCoup.codeSwift), typeZone: \(typeZone.codeSwift), nbSingletons1: \(nbDirects.codeSwift), nbPaires1: \(nbIndirects.codeSwift), nbPaires2: \(nbPaires2.codeSwift), nbTriplets3: \(nbTriplets3.codeSwift))"
    }
}

public extension SignatureCoup {
    
    var titre: String {
        let type = "\(typeCoup) dans \(typeZone)"
        var suffixe: String
        switch typeCoup {
        case .derniereCellule:
            suffixe = ""
        case .eliminationDirecte:
            suffixe = "\(nbDirects) éliminatrices"
        case .eliminationIndirecte:
            suffixe = "\(nbIndirects) paires1, \(nbDirects) éliminatrices"
        case .paire2:
            suffixe = "\(nbDirects) éliminatrices"
        case .triplet3:
            suffixe = "\(nbDirects) éliminatrices"
        }
        
        return suffixe .isEmpty ? type : "\(type) avec \(suffixe)"
    }
}
