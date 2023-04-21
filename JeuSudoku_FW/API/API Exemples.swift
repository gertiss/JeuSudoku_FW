//
//  API Exemples.swift
//  JeuSudoku_FW
//
//  Created by Gérard Tisseau on 07/03/2023.
//

import Foundation

// MARK: - API Exemples

/// Chaque variable codeX est une liste de String, chacune représentant un puzzle par ses 81 chiffres.
/// Les exemples sont classés par difficulté croissante ABCDE
/// Exemples : `codeMoyensA`, `codeDifficilesB`

public enum API { }

public extension API {
    
    static var codeMoyensA = Puzzle.moyensA.map { $0.codeChiffres }
    static var codeMoyensB = Puzzle.moyensB.map { $0.codeChiffres }
    static var codeMoyensC = Puzzle.moyensC.map { $0.codeChiffres }
    static var codeMoyensD = Puzzle.moyensD.map { $0.codeChiffres }
    
    static var codeDifficilesA = Puzzle.difficilesA.map { $0.codeChiffres }
    static var codeDifficilesB = Puzzle.difficilesB.map { $0.codeChiffres }
    static var codeDifficilesC = Puzzle.difficilesC.map { $0.codeChiffres }
    static var codeDifficilesD = Puzzle.difficilesD.map { $0.codeChiffres }
    static var codeDifficilesE = Puzzle.difficilesE.map { $0.codeChiffres }
}
