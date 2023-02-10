//
//  JeuSudoku_FWTests.swift
//  JeuSudoku_FWTests
//
//  Created by Gérard Tisseau on 31/01/2023.
//

import XCTest
@testable import JeuSudoku_FW

final class JeuSudoku_FWTests: XCTestCase {
    
    override func setUpWithError() throws {
        print()
    }
    
    override func tearDownWithError() throws {
        print()
    }
    
    func testBijection() {
        let bijection = PresenceValeurs([1, 2], dans:[Cellule(3, 5), Cellule(3, 6)])
        print(bijection)
        
    }
    
    func testCodagePuzzle() {
        let codage = CodagePuzzle(CodagePuzzle.exemple1)
        XCTAssertEqual(codage.caracteres.count, 99)
        XCTAssertEqual(codage.id, "0000183b305c")
        XCTAssertEqual(codage.sourceChiffres, "050703060007000800000816000000030000005000100730040086906000204840572093000409000")
        XCTAssertEqual(codage.chiffres, [0, 5, 0, 7, 0, 3, 0, 6, 0, 0, 0, 7, 0, 0, 0, 8, 0, 0, 0, 0, 0, 8, 1, 6, 0, 0, 0, 0, 0, 0, 0, 3, 0, 0, 0, 0, 0, 0, 5, 0, 0, 0, 1, 0, 0, 7, 3, 0, 0, 4, 0, 0, 8, 6, 9, 0, 6, 0, 0, 0, 2, 0, 4, 8, 4, 0, 5, 7, 2, 0, 9, 3, 0, 0, 0, 4, 0, 9, 0, 0, 0])
        XCTAssertEqual(codage.niveau, 1.2)
        
        let nomsBijections = Puzzle(code: CodagePuzzle.exemple1).contraintes
            .map { $0.nom }
            .sorted()
        
        XCTAssertEqual(nomsBijections, ["AaAbAcAdAeAfAgAhAi_123456789", "AaAbAcBaBbBcCaCbCc_123456789", "AaBaCaDaEaFaGaHaIa_123456789", "AbBbCbDbEbFbGbHbIb_123456789", "Ab_5", "AcBcCcDcEcFcGcHcIc_123456789", "AdAeAfBdBeBfCdCeCf_123456789", "AdBdCdDdEdFdGdHdId_123456789", "Ad_7", "AeBeCeDeEeFeGeHeIe_123456789", "AfBfCfDfEfFfGfHfIf_123456789", "Af_3", "AgAhAiBgBhBiCgChCi_123456789", "AgBgCgDgEgFgGgHgIg_123456789", "AhBhChDhEhFhGhHhIh_123456789", "Ah_6", "AiBiCiDiEiFiGiHiIi_123456789", "BaBbBcBdBeBfBgBhBi_123456789", "Bc_7", "Bg_8", "CaCbCcCdCeCfCgChCi_123456789", "Cd_8", "Ce_1", "Cf_6", "DaDbDcDdDeDfDgDhDi_123456789", "DaDbDcEaEbEcFaFbFc_123456789", "DdDeDfEdEeEfFdFeFf_123456789", "De_3", "DgDhDiEgEhEiFgFhFi_123456789", "EaEbEcEdEeEfEgEhEi_123456789", "Ec_5", "Eg_1", "FaFbFcFdFeFfFgFhFi_123456789", "Fa_7", "Fb_3", "Fe_4", "Fh_8", "Fi_6", "GaGbGcGdGeGfGgGhGi_123456789", "GaGbGcHaHbHcIaIbIc_123456789", "Ga_9", "Gc_6", "GdGeGfHdHeHfIdIeIf_123456789", "GgGhGiHgHhHiIgIhIi_123456789", "Gg_2", "Gi_4", "HaHbHcHdHeHfHgHhHi_123456789", "Ha_8", "Hb_4", "Hd_5", "He_7", "Hf_2", "Hh_9", "Hi_3", "IaIbIcIdIeIfIgIhIi_123456789", "Id_4", "If_9"])
        
        XCTAssertEqual(nomsBijections.count, 57)
        
        let puzzle = codage.puzzle
        XCTAssertEqual(puzzle.contraintes.count, 57)
        XCTAssertEqual(puzzle.singletons.count, 30)
        XCTAssertEqual(puzzle.contraintesBijectionZone.count, 27)
        XCTAssertEqual(
            puzzle.leSingleton(cellule: Cellule(0, 1)),
            PresenceValeurs([5].ensemble, dans: [Cellule(0, 1)].ensemble)
        )
    }
    
    func testNomCellule() {
        let cellule = Cellule(nom: "Ab")
        XCTAssertNotNil(cellule)
        XCTAssertEqual(cellule, Cellule(0, 1))
    }
    
    func testNomCarre() {
        let carre = Carre(nom: "Mn")
        XCTAssertNotNil(carre)
        XCTAssertEqual(carre, Carre(0, 1))
    }
    
    func testNomLigne() {
        let ligne = Ligne(nom: "C")
        XCTAssertNotNil(ligne)
        XCTAssertEqual(ligne, Ligne(2))
    }
    
    func testNomColonne() {
        let colonne = Colonne(nom: "c")
        XCTAssertNotNil(colonne)
        XCTAssertEqual(colonne, Colonne(2))
    }
    
    func testSuppressionEspaces() {
        let texte = """
012 456 789

987 654 321
"""
        print(texte.avecSuppressionEspacesTabsNewlines)
        
    }
    
    func testSaisieChiffres() {
        // Le monde jeudi 2 février facile
        let saisie = """
000 000 000
000 000 008
000 003 724

000 040 005
005 002 010
008 010 207

094 007 050
051 024 096
082 039 000
"""
        
        // fatalError si saisie invalide
        let puzzle = Puzzle(chiffres: saisie)
        XCTAssertEqual(puzzle.singletons.count, 28)
        XCTAssertEqual(puzzle.contraintes.count, 55)
    }
    
    func testEliminations() {
        func test(_ nomContrainte: String, _ nomEliminations: String = "_") -> Result<Bool, String> {
            print("\n> \(nomContrainte) -> \(nomEliminations) ?")
            let contrainte = PresenceValeurs(nom: nomContrainte)
            let eliminations = contrainte.eliminations
            if eliminations.nom != nomEliminations {
                let resultat = Result<Bool, String>.failure("On attend \(eliminations.nom), \(eliminations.count) cellules")
                XCTFail("\(resultat)")
                return resultat
            }
            return .success(true)
        }
        print(test("AaAb_12", "AcAdAeAfAgAhAiBaBbBcCaCbCc"))
        
        print(test("AaAbBa_1", "AcBbBcCaCbCc"))
        print(test("AaAbBa_12", "AcBbBcCaCbCc"))
        print(test("AaAbBa_123", "AcBbBcCaCbCc"))

        print(test("AaAd_1", "AbAcAeAfAgAhAi"))

    }
    
}
