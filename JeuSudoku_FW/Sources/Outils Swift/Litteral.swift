//
//  Litteral.swift
//  JeuSudoku_FW
//
//  Created by Gérard Tisseau on 10/03/2023.
//

import Foundation

/// Un Litteral est soit simple (vérifie estUnAtome), soit composé.
/// C'est un peu comme une expression syntaxique structurée utilisable facilement dans les communications et dans les tests.
/// Cette expression est un peu analogue à du JSON typé.
public protocol Litteral: Hashable, Codable, Comparable, Identifiable, CustomStringConvertible {
    
    var texte: String { get }
    var estUnAtome: Bool { get }
}

public extension Litteral {
    
    /// Protocole Identifiable
    var id: String {
        texte
    }
    
    var estUnAtome: Bool {
        self is (any Atome)
    }
    
    /// Protocole Comparable
    static func < (lhs: Self, rhs: Self) -> Bool {
        lhs.texte < rhs.texte
    }
        
}

/// Un Atome est une valeur Swift de base : String, Int, Double, Bool qui vérifie le protocole Litteral.
public protocol Atome: Litteral { }

extension String: Atome {
    public var texte: String {
        self
    }
}

extension Int: Atome {
    public var texte: String {
        String(self)
    }
}

extension Double: Atome {
    public var texte: String {
        String(self)
    }
}

extension Bool: Atome {
    public var texte: String {
        String(self)
    }
}

