//
//  CodableEnLitteral.swift
//  JeuSudoku_FW
//
//  Created by Gérard Tisseau on 10/03/2023.
//

import Foundation


/// Un type CodableEnLitteral possède une propriété `litteral` conforme au protocole Litteral.
/// Cela permet de lui faire profiter de certaines fonctions de Litteral,
/// en particulier la conformité aux protocoles de Litteral.
public protocol CodableEnLitteral: Hashable, Identifiable, CustomStringConvertible, Comparable {
    associatedtype L: Litteral
    
    var litteral: L { get }
    init(litteral: L)
}

public extension CodableEnLitteral {
    
    var id: L {
        litteral
    }
    
    var description: String {
        litteral.texte
    }
    
    static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.litteral == rhs.litteral
    }
    
    static func < (lhs: Self, rhs: Self) -> Bool {
        lhs.litteral < rhs.litteral
    }
    
    func hash(into hasher: inout Hasher) {
            hasher.combine(litteral)
        }
    
}

