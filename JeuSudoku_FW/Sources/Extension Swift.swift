//
//  Extension Swift.swift
//  LaboSudoku_FW
//
//  Created by Gérard Tisseau on 12/01/2023.
//

import Foundation

extension String: Error { }

public extension Result where Failure == String {
    
    var estSucces: Bool {
        switch self {
        case .success: return true
        case .failure: return false
        }
    }
    
    var estEchec: Bool {
        switch self {
        case .success: return false
        case .failure: return true
        }

    }
    
    /// description de la valeur ou message d'erreur
    var texte: String {
        switch self {
        case .success(let v): return "\(v)"
        case .failure(let message): return message
        }
    }

    var valeur: Success? {
        switch self {
        case .success(let v): return v
        case .failure: return nil
        }
    }

    var erreur: String? {
        switch self {
        case .success: return nil
        case .failure(let message): return message
        }
    }

}


public extension Array where Element: Hashable {
    var ensemble: Set<Element> {
        Set(self)
    }
}

public extension Set {
    
    var uniqueValeur: Element? {
        if count != 1 { return nil }
        let liste: [Element] = self.map { $0 }
        return liste[0]
    }
}

extension Dictionary {
    
    /// On ajoute l'élément à la valeur de la clé, lorsque cette valeur est un ensemble
    mutating func ajouter<E>(_ element: E, a cle: Key) where Value == Set<E> {
        guard var ensemble = self[cle] else {
            self[cle] = [element]
            return
        }
        ensemble.insert(element)
        self[cle] = ensemble
    }
}

extension Set {
    
    /// Lorsque l'ensemble est un singleton, on retourne l'unique element.
    /// Erreur sinon
    var uniqueElement: Element {
        assert(count == 1)
        return map{$0}[0]
    }
    
    var array: [Element] {
        map { $0 }
    }
}

