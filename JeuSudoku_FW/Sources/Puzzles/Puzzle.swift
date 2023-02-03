//
//  Puzzle.swift
//  JeuSudoku_FW
//
//  Created by Gérard Tisseau on 02/02/2023.
//

import Foundation

/// Un Puzzle est défini par un ensemble de bijections et le problème à résoudre est de réduire cet ensemble à un ensemble équivalent de singletons.
/// Ces bijections incluent les 27 bijections sur les zones.
public struct Puzzle: Hashable, Codable {
    
    public let bijections: Set<Bijection>
    
    public init(bijections: Set<Bijection>) {
        self.bijections = bijections
    }
    
}

public extension Puzzle {
    
    /// Les 27 bijections toujours associées implicitement aux zones
    static var bijectionsZones: Set<Bijection> {
        Grille.zones.map { zone in
            Bijection(zone.cellules, (1...9).map { $0 }.ensemble)
        }.ensemble
    }
    
    var singletons: Set<Bijection> {
        bijections.filter { $0.cardinal == 1 }.ensemble
    }
    
    var paires: Set<Bijection> {
        bijections.filter { $0.cardinal == 2 }.ensemble
    }
    
    var triplets: Set<Bijection> {
        bijections.filter { $0.cardinal == 3 }.ensemble
    }
    
    /// L'unique bijection dont l'ensemble de cellules est le singleton [cellule]
    /// Peut échouer, retourne alors nil.
    func leSingleton(cellule: Cellule) -> Bijection? {
        singletons.filter { singleton in singleton.cellules.contains(cellule) }
            .uniqueValeur
        }


}

// MARK: - Codage
public extension Puzzle {
    
    /// Le code est une ligne de la banque de grilles
    /// publiée sur Sudoku Exchange "Puzzle Bank"
    /// https://sudokuexchange.com
    init(_ code: String) {
        let codage = CodagePuzzle(code)
        let chiffres = codage.chiffres
        var ensemble = Set<Bijection>()
        for indexLigne in 0...8 {
            for indexColonne in 0...8 {
                let chiffre = chiffres[indexLigne * 9 + indexColonne]
                if chiffre != 0 { ensemble.insert(Bijection([Cellule(indexLigne, indexColonne)], [chiffre]))}
            }
        }
        self = Self(bijections: ensemble.union(Puzzle.bijectionsZones))
    }
        
    var json: Result<String, String> {
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(self)
            guard let texte = String(data: data, encoding: .utf8) else {
                return .failure("Codage json : Impossible de créer data")
            }
            return .success(texte)
        } catch {
            return .failure("Erreur de décodage json : \(error)")
        }
    }
    
    static func avecJson(_ code: String) -> Result<Puzzle, String> {
        let decoder = JSONDecoder()
        guard let data = code.data(using: .utf8) else {
            return .failure("Decodage: Impossible de créer data. Le code est censé être du json valide en utf8")
        }
        do {
            let instance = try decoder.decode(Puzzle.self, from: data)
            return .success(instance)
        } catch {
            return .failure("Erreur de décodage json : \(error)")
        }
    }

    
    
}

