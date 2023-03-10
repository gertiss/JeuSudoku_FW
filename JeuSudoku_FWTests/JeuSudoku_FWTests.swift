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
        
        var nouveauCoup = puzzle.premierCoup!
        print("détectée :", nouveauCoup.nom) // paire1 GbGc_8
        var etat = puzzle.plus(nouveauCoup.singleton)
        
        nouveauCoup = etat.premierCoup!
        print("détectée :", nouveauCoup.nom) // Df_8
        etat = puzzle.plus(nouveauCoup.singleton)
        
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
        
        let _ = puzzle.suiteDeCoups(solution: solution)
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
        let _ = puzzle.suiteDeCoups(solution: solution)
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
        let _ = puzzle.suiteDeCoups(solution: solution)
        
    }
    
    func testPartiesMoyensA() {
        // Niveau 2.0
        // 100%
        for (n, puzzle) in Puzzle.moyensA.enumerated() {
            print("\n-- moyensA[\(n)]")
            let _ = puzzle.suiteDeCoups()
        }
    }
    
    
    
    func testPartiesMoyensB() {
        // Niveau 2.0
        // 100%
        for (n, puzzle) in Puzzle.moyensB.enumerated() {
            print("\n-- moyensB[\(n)]")
            let _ = puzzle.suiteDeCoups()
        }
    }
    
    func testPartiesMoyensC() {
        // Niveau 2.0
        // 100%
        for (n, puzzle) in Puzzle.moyensC.enumerated() {
            print("\n-- moyensC[\(n)]")
            let _ = puzzle.suiteDeCoups()
        }
        
    }
    
    func testPartiesMoyensD() {
        // Niveau 2.3
        // 100%
        for (n, puzzle) in Puzzle.moyensD.enumerated() {
            print("\n-- moyensD[\(n)]")
            let _ = puzzle.suiteDeCoups()
        }
    }
    
    func testPartiesDifficilesA() {
        // Niveau 2.5
        // 100%
        for (n, puzzle) in Puzzle.difficilesA.enumerated() {
            print("\n-- difficilesA[\(n)]")
            let _ = puzzle.suiteDeCoups()
        }
        
        /*
         SudokuExchange dit que le puzzle 3 n'a pas une solution unique
         */
        
    }
    
    func testDifficileA5() {
        // Niveau 2.5
        // Demande une recherche de 3 parmi 8
        // Complexité : 56
        let puzzle = Puzzle.difficilesA[5]
        let _ = puzzle.suiteDeCoups()
    }
    
    func testPartiesDifficilesB() {
        // Niveau 2.6
        // 50%
        for (n, puzzle) in Puzzle.difficilesB.enumerated() {
            print("\n-- difficilesB[\(n)]")
            let _ = puzzle.suiteDeCoups()
        }
    }
    
    func testPartiesDifficilesC() {
        // Niveau 2.8
        for (n, puzzle) in Puzzle.difficilesC.enumerated() {
            print("\n-- difficilesC[\(n)]")
            let _ = puzzle.suiteDeCoups()
        }
    }
    
    func testPartiesDifficilesD() {
        // Niveau 3.0
        for (n, puzzle) in Puzzle.difficilesD.enumerated() {
            print("\n-- difficilesD[\(n)]")
            let _ = puzzle.suiteDeCoups()
        }
    }
    
    func testPartiesDifficilesE() {
        // Niveau 3.2
        for (n, puzzle) in Puzzle.difficilesE.enumerated() {
            print("\n-- difficilesE[\(n)]")
            let _ = puzzle.suiteDeCoups()
        }
    }
    
    func testCombinaisons2() {
        XCTAssertEqual(combinaisons2(parmi: 2).count, 1)
        XCTAssertEqual(combinaisons2(parmi: 3).count, 3)
        XCTAssertEqual(combinaisons2(parmi: 4).count, 6)
        XCTAssertEqual(combinaisons2(parmi: 5).count, 10)
        XCTAssertEqual(combinaisons2(parmi: 6).count, 15)
        XCTAssertEqual(combinaisons2(parmi: 7).count, 21)
        XCTAssertEqual(combinaisons2(parmi: 8).count, 28)

       let liste5 = combinaisons2(parmi: 5)
        XCTAssertEqual(liste5.count, 10)
        // Tuple ne peut être conforme à Equatable, donc on teste juste la description
        XCTAssertEqual(liste5.description, "[(0, 1), (0, 2), (0, 3), (0, 4), (1, 2), (1, 3), (1, 4), (2, 3), (2, 4), (3, 4)]")
        
        let liste8 = combinaisons2(parmi: 8)
        XCTAssertEqual(liste8.count, 28)
        XCTAssertEqual(liste8.description, "[(0, 1), (0, 2), (0, 3), (0, 4), (0, 5), (0, 6), (0, 7), (1, 2), (1, 3), (1, 4), (1, 5), (1, 6), (1, 7), (2, 3), (2, 4), (2, 5), (2, 6), (2, 7), (3, 4), (3, 5), (3, 6), (3, 7), (4, 5), (4, 6), (4, 7), (5, 6), (5, 7), (6, 7)]")
        
    }
    
    func testCombinaisons3() {
        XCTAssertEqual(combinaisons3(parmi: 3).count, 1)
        XCTAssertEqual(combinaisons3(parmi: 4).count, 4)
        XCTAssertEqual(combinaisons3(parmi: 5).count, 10)
        XCTAssertEqual(combinaisons3(parmi: 6).count, 20)
        XCTAssertEqual(combinaisons3(parmi: 7).count, 35)
        XCTAssertEqual(combinaisons3(parmi: 8).count, 56)

        let liste5 = combinaisons3(parmi: 5)
        XCTAssertEqual(liste5.count, 10)
        // Tuple ne peut être conforme à Equatable, donc on teste juste la description
        XCTAssertEqual(liste5.description, "[(0, 1, 2), (0, 1, 3), (0, 1, 4), (0, 2, 3), (0, 2, 4), (0, 3, 4), (1, 2, 3), (1, 2, 4), (1, 3, 4), (2, 3, 4)]")
        
        let liste8 = combinaisons3(parmi: 8)
        XCTAssertEqual(liste8.count, 56)
    }
    
    func testAPIDifficileA1() {
        let puzzle = Puzzle.difficilesA[1]
        let essai = suiteDesCoups(puzzle: puzzle.codeChiffres)
        print()
        switch essai {
        case .success(let success):
            print(success)
        case .failure(let failure):
            print(failure)
        }
    }
    
    func testAPIMoyenB0() {
        // Pour tester l'affichage des éliminations indirectes par paire1
        let puzzle = Puzzle.moyensB[0]
        let essai = suiteDesCoups(puzzle: puzzle.codeChiffres)
        print()
        
        switch essai {
        case .success(let success):
            print(success)
        case .failure(let failure):
            print(failure)
        }
    }
    
    func testDemonstration() {
        let puzzle = Puzzle.moyensA[0] // Sans coups difficiles
        
        // On extrait le premier coup par l'API
        let chiffres = puzzle.codeChiffres
        XCTAssertEqual(puzzle.codeChiffres, "002806100000090000300000007003000200600704008820000045000010000140080063030050080")
        let essai = coupSuivant(puzzle: chiffres)
        
        guard let texteCoup = essai.valeur else {
            XCTFail()
            return
        }
        XCTAssertEqual(texteCoup, "Df_8 // direct dans le carré Nn")
        
        // On extrait le premier coup par le calcul interne.
        // On vérifie que c'est cohérent avec l'API.
        // C'est un coup direct : pas d'auxiliaire.
        let coup = puzzle.premierCoup!
        XCTAssertEqual(coup.nom, texteCoup)
        
        // On prévoit la démonstration attendue.
        // Problème : choix et ordre des données.
        // On peut toujours ordonner les listes par ordre alphabétique,
        // mais il y a plusieurs démonstrations possibles.
        
        let demonstration = DemonstrationLitterale(
            presence: "Df_8",
            zone: "Nn",
            occupees: ["Ed", "Ef"],
            eliminatrices: ["Ad_8", "Ei_8", "Fa_8", "He_8"],
            eliminees: ["Dd", "De", "Ee", "Fd", "Fe", "Ff"],
            auxiliaires: [])
        
        // Mais on peut toujours vérifier qu'une démonstration donnée est bien une démonstration
        
        XCTAssert(puzzle.patternEstApplicable(Demonstration(litteral: demonstration)))
    }
}
