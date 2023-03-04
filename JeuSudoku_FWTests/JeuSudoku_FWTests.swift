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
    
    func testNomCellule() {
        let cellule = Cellule(nom: "Ab")
        XCTAssertNotNil(cellule)
        XCTAssertEqual(cellule, Cellule(0, 1))
        XCTAssertEqual(Cellule(nom: "Ab").nom, "Ab")
    }
    
    func testNomCarre() {
        let carre = Carre(nom: "Mn")
        XCTAssertNotNil(carre)
        XCTAssertEqual(carre, Carre(0, 1))
        XCTAssertEqual(Carre(nom: "Mn").nom, "Mn")
    }
    
    func testNomLigne() {
        let ligne = Ligne(nom: "C")
        XCTAssertNotNil(ligne)
        XCTAssertEqual(ligne, Ligne(2))
        XCTAssertEqual(Ligne(nom: "C").nom, "C")
   }
    
    func testNomColonne() {
        let colonne = Colonne(nom: "c")
        XCTAssertNotNil(colonne)
        XCTAssertEqual(colonne, Colonne(2))
        XCTAssertEqual(Colonne(nom: "c").nom, "c")
   }
      
    func testPresence() {
        
        let singleton1 = Presence([1], dans:[Cellule(3, 5)])
        XCTAssertEqual(singleton1.nom, "Df_1")
        XCTAssertEqual(singleton1.type, .singleton1)
        XCTAssertEqual(Presence(nom: "Df_1").nom, "Df_1")

        let singleton2 = Presence([1, 2], dans:[Cellule(3, 5)])
        XCTAssertEqual(singleton2.nom, "Df_12")
        XCTAssertEqual(singleton2.type, .singleton2)
        XCTAssertEqual(Presence(nom: "Df_12").nom, "Df_12")

        let paire1 = Presence([1], dans:[Cellule(3, 5), Cellule(3, 6)])
        XCTAssertEqual(paire1.nom, "DfDg_1")
        XCTAssertEqual(paire1.type, .paire1)
        XCTAssertEqual(Presence(nom: "DfDg_1").nom, "DfDg_1")

        let paire2 = Presence([1, 2], dans:[Cellule(3, 5), Cellule(3, 6)])
        XCTAssertEqual(paire2.nom, "DfDg_12")
        XCTAssertEqual(paire2.type, .paire2)
        XCTAssertEqual(Presence(nom: "DfDg_12").nom, "DfDg_12")


    }
    
    func testContraintesPuzzle() {
        let puzzle = Puzzle.bootstrap1
        XCTAssertEqual(puzzle, Puzzle(contraintes: [Presence([1], dans: [Cellule(0, 0)]), Presence([2, 3], dans: [Cellule(0, 1)]), Presence([4], dans: [Cellule(1, 0), Cellule(1, 1)]), Presence([5, 6], dans: [Cellule(2, 0), Cellule(2, 1)])]))
        
        XCTAssertEqual(puzzle.contraintes(cellule: Cellule(nom: "Aa")), [Presence([1], dans: [Cellule(0, 0)])])
        
        XCTAssertEqual(puzzle.contraintes(cellule: Cellule(nom: "Ab")), [Presence([2, 3], dans: [Cellule(0, 1)])])
        
        XCTAssertEqual(puzzle.contraintes(cellule: Cellule(nom: "Ba")), [Presence([4], dans: [Cellule(1, 0), Cellule(1, 1)])])
        
        XCTAssertEqual(puzzle.contraintes(cellule: Cellule(nom: "Bb")), [Presence([4], dans: [Cellule(1, 0), Cellule(1, 1)])])
        
        XCTAssertEqual(puzzle.contraintes(cellule: Cellule(nom: "Ca")), [Presence([5, 6], dans: [Cellule(2, 1), Cellule(2, 0)])])
        
    }
    
    func testLectureCode() {
                
        let puzzle = Puzzle.moyensA[0]
        let dessin = puzzle.texteDessin
        
        XCTAssertEqual(dessin,
        """
··2 8·6 1··
··· ·9· ···
3·· ··· ··7

··3 ··· 2··
6·· 7·4 ··8
82· ··· ·45

··· ·1· ···
14· ·8· ·63
·3· ·5· ·8·
""")

        // Ce "dessin" peut être utilisé directement comme code pour le puzzle
        let puzzleBis = Puzzle(chiffres: dessin)
        XCTAssertEqual(puzzleBis, puzzle)
        
        let singletons = puzzle.contraintes.map { $0.nom }.sorted().joined(separator: " ")
        XCTAssertEqual(singletons, "Ac_2 Ad_8 Af_6 Ag_1 Be_9 Ca_3 Ci_7 Dc_3 Dg_2 Ea_6 Ed_7 Ef_4 Ei_8 Fa_8 Fb_2 Fh_4 Fi_5 Ge_1 Ha_1 Hb_4 He_8 Hh_6 Hi_3 Ib_3 Ie_5 Ih_8")
    }
    
    func testCellulesSansContrainteBijective() {
        let puzzle = Puzzle.moyensA[0]
        
        let carre = Carre(nom: "Mm")
        /*
         ··2
         ···
         3··
         */
        XCTAssertEqual(
            puzzle.cellulesSansContrainteBijective(dans: carre)
                .map { $0.nom },
            ["Aa", "Ab", "Ba", "Bb", "Bc", "Cb", "Cc"])
    }
    
    func testDetection() {
        let puzzle = Puzzle.moyensA[0]
        print(puzzle.texteDessin)
        
        XCTAssertEqual(puzzle.contraintes.count, 26)
        XCTAssertEqual(
            puzzle.contraintes.map{$0.nom},
            ["Ac_2", "Ad_8", "Af_6", "Ag_1", "Be_9", "Ca_3", "Ci_7", "Dc_3", "Dg_2", "Ea_6", "Ed_7", "Ef_4", "Ei_8", "Fa_8", "Fb_2", "Fh_4", "Fi_5", "Ge_1", "Ha_1", "Hb_4", "He_8", "Hh_6", "Hi_3", "Ib_3", "Ie_5", "Ih_8"]
        )
        
        // Etude du coup He_8
        XCTAssert(puzzle.contient(chiffre: 8))
        XCTAssertEqual(
            puzzle.contraintesEliminantes(pour: 8).map{$0.nom},
            ["Ad_8", "Ei_8", "Fa_8", "He_8", "Ih_8"]
        )
        let elimineesParHe_8 = puzzle.cellulesEliminees(par: Presence(nom: "He_8"), pour: 8)
        // Un singleton1 élimine son radar + elle-même
        XCTAssertEqual(elimineesParHe_8.count, 21)
        XCTAssertEqual(
            elimineesParHe_8.map {$0.nom}.sorted(),
            ["Ae", "Be", "Ce", "De", "Ee", "Fe", "Gd", "Ge", "Gf", "Ha", "Hb", "Hc", "Hd", "He", "Hf", "Hg", "Hh", "Hi", "Id", "Ie", "If"]
        )
        // Jeu
        
        var nouvelleContrainte = puzzle.contrainteDetectee!
        print("détectée :", nouvelleContrainte.nom) // paire1 GbGc_8
        var etat = puzzle.plus(nouvelleContrainte)
        
        nouvelleContrainte = etat.contrainteDetectee!
        print("détectée :", nouvelleContrainte.nom) // Df_8
        etat = puzzle.plus(nouvelleContrainte)

    }
    
    func testPartieMoyenA0() {
        let puzzle = Puzzle.moyensA[0]
        
        print(puzzle.texteDessin)
        
        let chiffresSolution = """
592 876 134
784 391 526
361 245 897

413 568 279
659 724 318
827 139 645

978 613 452
145 982 763
236 457 981
"""
        let solution = Puzzle(chiffres: chiffresSolution)

        let _ = puzzle.jeuAvecVerification(solution: solution)
    }
    
    func testPartieMoyenB0() {
        let puzzle = Puzzle.moyensB[0]
        print(puzzle.texteDessin)
        
        let codeSolution = """
812634579
947158263
536729481

791486325
328597146
654213798

265841937
483975612
179362854
"""
        
        let solution = Puzzle(chiffres: codeSolution)
        let _ = puzzle.jeuAvecVerification(solution: solution)
    }
    
    func testPartieMoyenC0() {
        let puzzle = Puzzle.moyensC[0]
        print(puzzle.texteDessin)
        
        let codeSolution = """
143862579
658739214
792541836

316978452
987254361
425316798

839625147
271493685
564187923
"""
        let solution = Puzzle(chiffres: codeSolution)
        let _ = puzzle.jeuAvecVerification(solution: solution)

    }
    
    func testPartieMoyenD0() {
        let puzzle = Puzzle.moyensD[0]
        print(puzzle.texteDessin)
        
        _ = puzzle.suiteDeContraintesDetectees
                
    }
    
    func testPartiesMoyens() {
        print("// moyensD")
        for puzzle in Puzzle.moyensD {
            print("\n// \(puzzle.codeChiffres)")
            let _ = puzzle.suiteDeContraintesDetectees
        }
    }
    
    func testPartiesDifficilesA() {
        print("// difficiles")
        for (n, puzzle) in Puzzle.difficilesA.enumerated() {
            print("\n-- difficilesA[\(n)]: \n\(puzzle.texteDessin)")
            print("\n// \(puzzle.codeChiffres)")
            let _ = puzzle.suiteDeContraintesDetectees
        }
        
        /*
         SudokuExchange dit que certains puzzles n'ont pas une solution unique
         3,
         */
        
    }
    
    func testMoyenD009610720() {
        let puzzle = Puzzle.moyensD[6]
        print("\n\(puzzle.texteDessin)")
        print("\n// \(puzzle.codeChiffres)")
        
        let _ = puzzle.suiteDeContraintesDetectees
    }
    
    func testDifficileA5() {
        // Niveau 2.5
        let puzzle = Puzzle.difficilesA[5]
        print("\n\(puzzle.texteDessin)")
        print("\n// \(puzzle.codeChiffres)")
        let _ = puzzle.suiteDeContraintesDetectees
        
    }
}
