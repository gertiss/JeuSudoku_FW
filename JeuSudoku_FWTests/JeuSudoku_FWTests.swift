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
        
        XCTAssertEqual(puzzle.contraintes(Cellule(nom: "Aa")), [Presence([1], dans: [Cellule(0, 0)])])
        
        XCTAssertEqual(puzzle.contraintes(Cellule(nom: "Ab")), [Presence([2, 3], dans: [Cellule(0, 1)])])
        
        XCTAssertEqual(puzzle.contraintes(Cellule(nom: "Ba")), [Presence([4], dans: [Cellule(1, 0), Cellule(1, 1)])])
        
        XCTAssertEqual(puzzle.contraintes(Cellule(nom: "Bb")), [Presence([4], dans: [Cellule(1, 0), Cellule(1, 1)])])
        
        XCTAssertEqual(puzzle.contraintes(Cellule(nom: "Ca")), [Presence([5, 6], dans: [Cellule(2, 1), Cellule(2, 0)])])
        
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
    
    
}
