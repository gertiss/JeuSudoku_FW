//
//  Problemes.swift
//  JeuSudoku_FW
//
//  Created by Gérard Tisseau on 08/04/2023.
//

import Foundation
import Modelisation_FW

public struct Probleme: UnLitteral, Identifiable {
    
    public let chiffresPuzzle: String
    public let signature: SignatureCoup
    public let puzzle: Puzzle_
    public let id: String
    
    public init(chiffresPuzzle: String, signature: SignatureCoup) {
        self.chiffresPuzzle = chiffresPuzzle
        self.signature = signature
        self.puzzle = try! Puzzle_(chiffres: chiffresPuzzle)
        self.id = chiffresPuzzle
    }
        
    public var codeSwift: String {
        "Probleme(chiffresPuzzle: \(chiffresPuzzle.codeSwift), signature: \(signature.codeSwift))"
    }
        
}

public extension Probleme {
    
    var coup: Coup_ {
        puzzle.premierCoup()!
    }
    
    var titre: String {
        signature.titre
    }
    
}

public extension Probleme {
    static var predefinis: [Probleme] {
        [
            Probleme(
                chiffresPuzzle: "002876130000090000300040007403008200600724308820030045000010000140080063030050081",
                signature: SignatureCoup(typeCoup: .derniereCellule, typeZone: "colonne", nbDirects: 0, nbIndirects: 0, nbPaires2: 0, nbTriplets3: 0)),
            Probleme(
                chiffresPuzzle: "570060003030005060601007000053000001000080000900000270000800402080100030200040019",
                signature: SignatureCoup(typeCoup: .eliminationDirecte, typeZone: "carre", nbDirects: 3, nbIndirects: 0, nbPaires2: 0, nbTriplets3: 0)),
            Probleme(
                chiffresPuzzle: "002806100000090000300000007003000200600704008820000045000010000140080063030050080",
                signature: SignatureCoup(typeCoup: .eliminationDirecte, typeZone: "carre", nbDirects: 3, nbIndirects: 0, nbPaires2: 0, nbTriplets3: 0)),
            Probleme(
                chiffresPuzzle: "000801000005064130060700080258617493090040070476000012017489320002576941000123000",
                signature: SignatureCoup(typeCoup: .eliminationIndirecte, typeZone: "carre", nbDirects: 1, nbIndirects: 2, nbPaires2: 0, nbTriplets3: 0)),
            Probleme(
                chiffresPuzzle: "000801000005064130060700080250610493090040070406000012010489320002576901000123000",
                signature: SignatureCoup(typeCoup: .paire2, typeZone: "colonne", nbDirects: 0, nbIndirects: 0, nbPaires2: 1, nbTriplets3: 0)),
            Probleme(
                chiffresPuzzle: "952678314384521679100349258400002090200000405010400000743065900690037540020004000",
                signature: SignatureCoup(typeCoup: .paire2, typeZone: "carre", nbDirects: 2, nbIndirects: 0, nbPaires2: 1, nbTriplets3: 0)),
            Probleme(
                chiffresPuzzle: "000801000005064100060700080250000493090000070406000012010009020002570901000123000",
                signature: SignatureCoup(typeCoup: .triplet3, typeZone: "colonne", nbDirects: 0, nbIndirects: 0, nbPaires2: 0, nbTriplets3: 1))
            
        ]
    }
}
