//
//  UneContrainte.swift
//  JeuSudoku_FW
//
//  Created by Gérard Tisseau on 09/02/2023.
//

import Foundation

public enum TypeContrainte: Hashable, Codable {
    case existenceBijection
    case presenceValeur
}

public protocol UneContrainte {
    
    var type: TypeContrainte { get }
    var puzzle: Puzzle { get }
}
