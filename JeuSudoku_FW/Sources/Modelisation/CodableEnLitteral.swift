//
//  CodableEnLitteral.swift
//  JeuSudoku_FW
//
//  Created by Gérard Tisseau on 10/03/2023.
//

import Foundation


/// Un type CodableEnLitteral possède une propriété `litteral` conforme au protocole UnLitteral.
/// Cela permet de lui faire profiter de certaines fonctions de UnLitteral,
/// en particulier la conformité aux protocoles de UnLitteral.
public protocol CodableEnLitteral: Hashable, Identifiable, CustomStringConvertible, Comparable, CodableEnJson {
    associatedtype Litteral: UnLitteral
    
    var litteral: Litteral { get }
    
    init(litteral: Litteral)
}

public extension CodableEnLitteral {
    
    var id: Litteral {
        litteral
    }
    
    var description: String {
        litteral.codeSwift
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
    
    static func avec(litteral: Litteral) -> Self {
        Self(litteral: litteral)
    }
    
    var jsonResult: Result<String, String> {
        litteral.jsonResult
    }
    
    static func avecJsonResult(_ json: String) -> Result<Self, String> {
        let essai = Self.Litteral.avecJsonResult(json)
        switch essai {
        case .success(let litteral):
            return .success(Self(litteral: litteral))
        case .failure(let erreur):
            return .failure(erreur)
        }
    }
    
    
}

