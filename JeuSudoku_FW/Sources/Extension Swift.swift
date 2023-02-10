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

public extension Dictionary {
    
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

public extension Set {
    
    /// Lorsque l'ensemble est un singleton, on retourne l'unique element.
    /// Erreur sinon
    var uniqueElement: Element {
        assert(count == 1)
        return map{$0}[0]
    }
    
    var uniqueValeur: Element? {
        if count != 1 { return nil }
        let liste: [Element] = self.map { $0 }
        return liste[0]
    }

    var array: [Element] {
        map { $0 }
    }
}

extension Set<Int>  {
    
    /// On suppose que chaque caractère du nom est un chiffre
    /// et que les chiffres sont tous distincts
    /// "123" -> [1, 2, 3]
    public init(nom: String) {
        let chiffres = nom.map { Int(String($0))! }.ensemble
        assert(chiffres.count == nom.count)
        self = chiffres
    }
    
    /// [3, 1, 4, 2] -> "1234"
    public var nom: String {
        assert(allSatisfy{ $0 >= 0 && $0 <= 9 })
        return self.array.sorted().map { $0.description }.joined()
    }
    
}

extension Set<Cellule>  {
    
    /// "AaAb" -> [C(0,0), C(0,1)]
    /// On suppose les noms syntaxiquement valides et tous distincts
    public init(nom: String) {
        var cellules = [Cellule]()
        assert(nom.count.isMultiple(of: 2))
        let nbCellules = nom.count / 2
        let caracteres = nom.map { String($0) }
        for index in  0...(nbCellules - 1) {
            let (li, co) = (caracteres[index * 2], caracteres[index * 2 + 1])
            cellules.append(Cellule(nom: li + co))
        }
        let ensemble = cellules.ensemble
        assert(ensemble.count == nbCellules)
        self = ensemble
    }
    
    /// [C(0,0), C(0,1)] -> "AaAb"
    public var nom: String {
        return self.array.map { $0.nom }.sorted().joined()
    }
    
    /// La ligne éventuelle qui contient toutes les cellules de self
    public var ligneCommune: Ligne? {
        map { $0.ligne }.ensemble.uniqueValeur
    }
    
    /// La colonne éventuelle qui contient toutes les cellules de self
    public var colonneCommune: Colonne? {
        map { $0.colonne }.ensemble.uniqueValeur
    }
    
    public var carreCommun: Carre? {
        map { $0.carre }.ensemble.uniqueValeur
    }
    
    
}



public extension String {
    
    func avecSuppression(de caracteres: String) -> String {
        var copie = self
        copie.removeAll { caracteres.contains($0) }
        return copie
    }
    
    var avecSuppressionEspacesTabsNewlines: String {
        avecSuppression(de: " \t\n")
    }
}


