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

public var codeMoyensA = Puzzle.moyensA.map { $0.codeChiffres }
public var codeMoyensB = Puzzle.moyensB.map { $0.codeChiffres }
public var codeMoyensC = Puzzle.moyensC.map { $0.codeChiffres }
public var codeMoyensD = Puzzle.moyensD.map { $0.codeChiffres }

public var codeDifficilesA = Puzzle.difficilesA.map { $0.codeChiffres }
public var codeDifficilesB = Puzzle.difficilesB.map { $0.codeChiffres }
public var codeDifficilesC = Puzzle.difficilesC.map { $0.codeChiffres }
public var codeDifficilesD = Puzzle.difficilesD.map { $0.codeChiffres }
public var codeDifficilesE = Puzzle.difficilesE.map { $0.codeChiffres }
