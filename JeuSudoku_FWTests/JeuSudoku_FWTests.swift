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
        // Mais aussi une recherche de paire2 parmi 6
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
    
    func testLitteral() {
        let litteral = DemonstrationLitterale(
            presence: "Ae_9",
            zone: "e",
            occupees: ["Be", "Ee", "Ge"],
            eliminatrices: ["Dd_9", "Hf_9"],
            eliminees: ["De", "He"],
            auxiliaires: [
                AuxiliaireLitteral(
                    presence: "CeFeIe_456",
                    zone: "e",
                    occupees: ["Be", "Ee", "Ge"],
                    eliminees: ["Ae", "De", "He"],
                    eliminatrices: ["AcAgAh_456", "DbDfDi_456", "HdHhHi_456"])
            ]
        )
        
        XCTAssertEqual(litteral.codeSwift, """
DemonstrationLitterale(presence: "Ae_9", zone: "e", occupees: ["Be", "Ee", "Ge"], eliminatrices: ["Dd_9", "Hf_9"], eliminees: ["De", "He"], auxiliaires: [AuxiliaireLitteral(presence: "CeFeIe_456", zone: "e", occupees: ["Be", "Ee", "Ge"], eliminatrices: ["AcAgAh_456", "DbDfDi_456", "HdHhHi_456"], eliminees: ["Ae", "De", "He"]]]
""")
        
        let demonstration = Demonstration(litteral: litteral)
        
        XCTAssertEqual(demonstration.litteral, litteral)
        XCTAssertEqual("\(litteral)", litteral.codeSwift)
        
    }
    
    func testRegleCelluleElimineeDirectement() {
        
        /// Un Puzzle est vu comme une base de données.
        /// Une règle permet de résoudre des requêtes dans cette base de données
        /// grâce à ses static func `instances`.
        
        let puzzle = Puzzle.difficilesA[0]
        print(puzzle.codeChiffres)
        print(puzzle.texteDessin)
        
        /*
         570060003030005060601007000053000001000080000900000270000800402080100030200040019
         
         57· ·6· ··3
         ·3· ··5 ·6·
         6·1 ··7 ···
         
         ·53 ··· ··1
         ··· ·8· ···
         9·· ··· 27·
         
         ··· 8·· 4·2
         ·8· 1·· ·3·
         2·· ·4· ·19
         */
        
        // Les éliminatrices de la valeur 5 qui éliminent la cellule Ba
        let eliminatrices = EliminationDirecte
            .instances(cellule: Cellule(nom: "Ba"), valeur: 5, dans: puzzle)
            .map { $0.eliminatrice.nom }.sorted()
        XCTAssertEqual(eliminatrices, ["Aa_5", "Bf_5"])
        
        // Les éliminées par `Bf_5` dans `Mm`
        let eliminees = EliminationDirecte
            .instances(zone: Carre(nom: "Mm"), eliminatrice: Presence(nom: "Bf_5"), dans: puzzle)
            .map { $0.eliminee.nom }.sorted()
        XCTAssertEqual(eliminees, ["Ba", "Bc"])
        
        /*
         coup : Eg_3 dans Np à cause de Ai_3, Dc_3, Hh_3
         */
        let coup = Coup_EliminationDirecte.instances(valeur: 3, zone: Carre(nom: "Np"), dans: puzzle)[0]
        XCTAssertEqual(
            coup.litteral,
            Coup_EliminationDirecte.Litteral (
                singleton: "Eg_3",
                zone: "Np",
                occupees: ["Di", "Fg", "Fh"],
                eliminees: ["Dg", "Dh", "Eh", "Ei", "Fi"],
                eliminatrices: ["Ai_3", "Dc_3", "Hh_3"]
            )
        )
        
        print(coup)
    }
    
    func testReglePaire1() {
        let puzzle = Puzzle.difficilesA[0]
        print(puzzle.texteDessin)
        
        /*
         57· ·6· ··3
         ·3· ··5 ·6·
         6·1 ··7 ···
         
         ·53 ··· ··1
         ··· ·8· ···
         9·· ··· 27·
         
         ··· 8·· 4·2
         ·8· 1·· ·3·
         2·· ·4· ·19
         */

        /// Dans `Pn` en bas au centre,  dans la ligne H `HeHf_2`est une paire1 pour la valeur 2
        /// Parce que 2 est éliminée dans la ligne G par `Gi_2` et dans la ligne I par `Ia_2`
        /// Les occupées sont Gd Hd Ie
        /// Les éliminatrices sont Gi Ia

        XCTAssertEqual(
            SingletonEliminateur.instances(valeur: 2, zone: Carre(nom: "Pn"), dans: puzzle)
                .map { $0.singleton.nom },
            ["Gi_2", "Ia_2"]
        )
        
        let instances = DetectionPaire1.instances(valeur: 2, zone: Carre(nom: "Pn"), dans: puzzle)
        XCTAssertEqual(instances.count, 1)
        let instance = instances[0]
        XCTAssertEqual(instance.paire1.nom, "HeHf_2")
        XCTAssertEqual(instance.occupees.map { $0.nom }, ["Gd", "Hd", "Ie"])
        XCTAssertEqual(instance.eliminees.map { $0.nom }, ["Ge", "Gf", "Id", "If"])
        XCTAssertEqual(instance.eliminatrices.map { $0.nom }, ["Gi", "Ia"])
   }
    
    func testReglePaire2Parmi3() {
        let puzzle = Puzzle(chiffres: "000801000005064130060700080250610493090040070406000012010489320002576901000123000")
        print(puzzle.texteDessin)
        /*
         ··· 8·1 ···
         ··5 ·64 13·
         ·6· 7·· ·8·

         25· 61· 493
         ·9· ·4· ·7·
         4·6 ··· ·12

         ·1· 489 32·
         ··2 576 9·1
         ··· 123 ···
         */
         
        let premierCoup = puzzle.premierCoup!
        
        XCTAssertEqual(premierCoup.singleton.nom, "Hh_4")
        XCTAssertEqual(premierCoup.zone.nom, "h")
        XCTAssertEqual(premierCoup.auxiliaires[0].nom, "AhIh_56")
        
        
        // Ce coup est trouvé grâce à une paire2 AhIh_56
        // qu'on peut découvrir et expliquer par la requête suivante
        
        let detectionPaire2 = DetectionPaire2.instances(zone: Colonne(nom: "h"), pour: (5, 6), dans: puzzle)[0]
        
        XCTAssertEqual(detectionPaire2.paire2.nom, "AhIh_56")
        
        XCTAssertEqual(detectionPaire2.occupees.map { $0.nom }, ["Bh", "Ch", "Dh", "Eh", "Fh", "Gh"])
        
        XCTAssertEqual(detectionPaire2.eliminees.map { $0.nom }, ["Hh"])
        XCTAssertEqual(detectionPaire2.pairesEliminatrices[0].map { $0.nom }, ["Hd_5", "Hf_6"])

        /*
         Ce qui signifie :
         
         On a trouvé une paire2 AhIh_56 en cherchant dans la colonne h les cellules éliminées pour les valeurs 5 et 6 (pour les deux valeurs à la fois, par seulement pour l'une ou l'autre).
         
         Explication :
         
         Les cases éliminées pour 5 et 6 à la fois sont ["Hh"]
         Les paires qui ont permis l'élimination de Hh sont [["Hd_5", "Hf_6"]]
         Les 6 cases occupées dans la colonne sont ["Bh", "Ch", "Dh", "Eh", "Fh", "Gh"]
         Il ne reste alors plus que les deux cellules Ah et Ih. Deux cellules pour deux valeurs, cela forme une paire2.
         
         */
    
        let litteralAttendu =
        DetectionPaire2.Litteral(
            paire2: "AhIh_56",
            zone: "h",
            occupees: ["Bh", "Ch", "Dh", "Eh", "Fh", "Gh"],
            eliminees: ["Hh"],
            pairesEliminatrices: [["Hd_5", "Hf_6"]])
        XCTAssertEqual(detectionPaire2.litteral, litteralAttendu)
        
        // Il y avait 3 cellules vides dans la ligne h, la paire en occupe 2,
        // il n'en reste plus qu'une Hh, pour la veleur 4.
        let coup = Coup_Paire2.instances(zone: Colonne(nom: "h"), parmi: 3, dans: puzzle)[0]
        print(coup.litteral)
        
        let coupAttendu =
        Coup_Paire2_ (
            singleton: "Hh_4",
            zone: "h",
            occupees: ["Bh", "Ch", "Dh", "Eh", "Fh", "Gh"],
            eliminationsDirectes: [],
            detectionPaire2: DetectionPaire2.Litteral(
                paire2: "AhIh_56",
                zone: "h",
                occupees: ["Bh", "Ch", "Dh", "Eh", "Fh", "Gh"],
                eliminees: ["Hh"],
                pairesEliminatrices: [["Hd_5", "Hf_6"]]))
        
        XCTAssertEqual (
            coup.litteral,
            coupAttendu
        )
    }
    

    
    func testTriplet3() {
        let puzzle = Puzzle(chiffres: "000801000005064100060700080250000493090000070406000012010009020002570901000123000")
        print(puzzle.texteDessin)
        /*
         ··· 8·1 ···
         ··5 ·64 1.·
         ·6· 7·· ·8·
         
         25· 61· 493
         ·9· ·4· ·7·
         4·6 ··· ·12
         
         ·1· 489 32·
         ··2 576 9·1
         ··· 123 ···
         
         triplet :
         triplet colonne h parmi 4 libres : AhHhIh_456
         zone : colonne h
         occupees (5) : Ch Dh Eh Fh Gh
         éliminatrices pour 4 : Bf_4
         éliminatrices pour 5 : Bc_5 Hd_5
         éliminatrices pour 6 : Be_6
         eliminees pour 456 : dans ligne B : Bh
         eliminatrices pour 456 ciblant Bh : dans ligne B : Bf_4 Bc_5 Be_6
         tripletsEliminateurs: Cellule(1, 5) pour 4, Cellule(1, 2) pour 5, Cellule(1, 4) pour 6
         restantes (après occupées, éliminées) : AhHhIh_456
         
         coup :
         valeur 3
         aucune élimination directe
         élimination indirecte par triplet, dans le triplet : (3) : [Ah, Hh, Ih]
         occupées : (5) : Ch_8 Dh_9 Eh_7 Fh_1 Gh_2
         restantes après occupées et triplet 5+3 :  (1) : Bh
         coup = Bh_3
         */
        
        
        let instance = DetectionTriplet3.instances(zone: Colonne(nom: "h"), pour: (4, 5, 6), dans: puzzle)[0]
        print()
        XCTAssertEqual(
            instance.litteral,
            DetectionTriplet3.Litteral(triplet: "AhHhIh_456", zone: "h", occupees: ["Ch", "Dh", "Eh", "Fh", "Gh"], eliminees: ["Bh"], tripletsEliminateurs: [["Bf_4", "Bc_5", "Be_6"]])
        )
        
        let coups = Coup_Triplet3.instances(zone: Colonne(nom: "h"), parmi: 4, dans: puzzle)
        XCTAssertEqual(coups.count, 1)
        let coup = coups[0]
        
        print(coup.litteral)
        print(coup.litteral.codeSwift)
        
        
        let coupAttendu =
        Coup_Triplet3_ (
            singleton: "Bh_3",
            zone: "h",
            occupees: ["Ch", "Dh", "Eh", "Fh", "Gh"],
            eliminationsDirectes: [EliminationDirecte_(eliminee: "Ih", eliminatrice: "If_3")],
            detectionTriplet3: DetectionTriplet3_(triplet: "AhHhIh_456", zone: "h", occupees: ["Ch", "Dh", "Eh", "Fh", "Gh"], eliminees: ["Bh"], tripletsEliminateurs: [["Bf_4", "Bc_5", "Be_6"]]))
        
        XCTAssertEqual(coup.litteral, coupAttendu)
        
    }
    
    func testDeuxPaires1() {
        let puzzle = Puzzle(chiffres: "000801000005064130060700080258617493090040070476000012017489320002576941000123000")
        print(puzzle.texteDessin)
        /*
         m   n   p
         abc def ghi
         A ··· 8·1 ···
         M B ··5 ·64 13·
         C ·6· 7·· ·8·
         
         D 258 617 493
         N E ·9· ·4· ·7·
         F 476 ··· ·12
         
         G ·17 489 32·
         P H ··2 576 941
         I ··· 123 ···
         
         Deux paires EaEc_3 dans Nm et AeCe_3 dans Mn
         EaEc_3 parce que ce sont les deux seules libres
         AeCe_3 à cause des éliminatrices Bh_3 et If_3
         
         permet de déduire Fd_3 dans Nn car en plus il y a une élimination directe en Ff à cause de If_3
         
         Donc 3 éliminées indirectes, 1 éliminée directe, 4 occupées, 1 seule restante.
         
         */
        
        let paires1 = DetectionPaire1.instances(valeur: 3, zone: Carre(nom: "Nm"), dans: puzzle)
        XCTAssertEqual(paires1.count,  1)
        let EaEc_3 = paires1[0]
        XCTAssertEqual(EaEc_3.paire1.nom, "EaEc_3")
        XCTAssertEqual(EaEc_3.occupees.count, 7)
        XCTAssertEqual(EaEc_3.eliminees, [])
        XCTAssertEqual(EaEc_3.eliminatrices, [])
        
        let paires2 = DetectionPaire1.instances(valeur: 3, zone: Carre(nom: "Mn"), dans: puzzle)
        XCTAssertEqual(paires2.count,  1)
        let AeCe_3 = paires2[0]
        XCTAssertEqual(AeCe_3.paire1.nom, "AeCe_3")
        XCTAssertEqual(AeCe_3.occupees.count, 5)
        XCTAssertEqual(AeCe_3.eliminees.map { $0.nom }, ["Bd", "Cf"])
        XCTAssertEqual(AeCe_3.eliminatrices.map { $0.nom }, ["Bh", "If"])
        
        XCTAssertEqual(EaEc_3.litteral, DetectionPaire1.Litteral(paire1: "EaEc_3", zone: "Nm", occupees: ["Da", "Db", "Dc", "Eb", "Fa", "Fb", "Fc"], eliminees: [], eliminatrices: []))
        XCTAssertEqual(AeCe_3.litteral, DetectionPaire1.Litteral(paire1: "AeCe_3", zone: "Mn", occupees: ["Ad", "Af", "Be", "Bf", "Cd"], eliminees: ["Bd", "Cf"], eliminatrices: ["Bh", "If"]))
        
        /*
         {"occupees":["Ad","Af","Be","Bf","Cd"],"paire1":"AeCe_3","zone":"Mn","eliminees":["Bd","Cf"],"eliminatrices":["Bh","If"]}
         */
        
        
        
        let elimination = EliminationIndirecte.instances(eliminatrices: paires1 + paires2, zone: Carre(nom: "Nn"), dans: puzzle)[0]
        print(elimination.litteral)
        //
        XCTAssertEqual(
            elimination.litteral,
            EliminationIndirecte.Litteral(
                eliminees: ["Ed", "Ef", "Fe"],
                zone: "Nn",
                eliminatrices: [
                    DetectionPaire1.Litteral(
                        paire1: "AeCe_3",
                        zone: "Mn",
                        occupees: ["Ad", "Af", "Be", "Bf", "Cd"],
                        eliminees: ["Bd", "Cf"],
                        eliminatrices: ["Bh", "If"]),
                    DetectionPaire1.Litteral(
                        paire1: "EaEc_3",
                        zone: "Nm",
                        occupees: ["Da", "Db", "Dc", "Eb", "Fa", "Fb", "Fc"],
                        eliminees: [],
                        eliminatrices: [])
                ])
        )
        XCTAssertEqual(elimination.valeur, 3)
        
        let coup = Coup_EliminationIndirecte.instances(valeur: 3, zone: Carre(nom: "Nn"), dans: puzzle)[0]
        XCTAssertEqual(coup.singleton, Presence(nom: "Fd_3"))
        
        print(coup)
        
        XCTAssertEqual(
            coup.litteral,
            Coup_EliminationIndirecte.Litteral (
                singleton: "Fd_3",
                zone: "Nn",
                occupees: ["Dd", "De", "Df", "Ee"],
                elimineesDirectement: ["Ef", "Ff"],
                elimineesIndirectement: ["Ed", "Ef", "Fe"],
                explicationDesDirectes: [
                    EliminationDirecte.Litteral(eliminee: "Ef", eliminatrice: "If_3"),
                    EliminationDirecte.Litteral(eliminee: "Ff", eliminatrice: "If_3")
                ],
                explicationDesIndirectes: [
                    EliminationIndirecte.Litteral(
                        eliminees: ["Ed", "Ef", "Fe"],
                        zone: "Nn",
                        eliminatrices: [
                            DetectionPaire1.Litteral(paire1: "AeCe_3", zone: "Mn", occupees: ["Ad", "Af", "Be", "Bf", "Cd"], eliminees: ["Bd", "Cf"], eliminatrices: ["Bh", "If"]),
                            DetectionPaire1.Litteral(paire1: "EaEc_3", zone: "Nm", occupees: ["Da", "Db", "Dc", "Eb", "Fa", "Fb", "Fc"], eliminees: [], eliminatrices: [])])
                ]
            )
        )
    }
    
    func testPaire2Parmi6() {
        let puzzle = Puzzle(chiffres: "952678314384521679100349258400002090200000405010400000743065900690037540020004000")
        /*
         Ig_7
         */
        
        let coup = Coup_Paire2.instances(zone: Carre(nom: "Pp"), parmi: 6, dans: puzzle)[0]
        print(coup.litteral)
        
        let attendu =
        Coup_Paire2.Litteral (
            singleton: "Ig_7",
            zone: "Pp",
            occupees: ["Gg", "Hg", "Hh"],
            eliminationsDirectes: [
                EliminationDirecte.Litteral(eliminee: "Gi", eliminatrice: "Ga_7"),
                EliminationDirecte.Litteral(eliminee: "Gh", eliminatrice: "Ga_7"),
                EliminationDirecte.Litteral(eliminee: "Hi", eliminatrice: "Hf_7")],
            detectionPaire2: DetectionPaire2.Litteral(
                paire2: "IhIi_36",
                zone: "Pp",
                occupees: ["Gg", "Hg", "Hh"],
                eliminees: ["Gh", "Gi", "Hi", "Ig"],
                pairesEliminatrices: [["He_3", "Ha_6"], ["Ag_3", "Bg_6"], ["Gc_3", "Ge_6"]]))
    }
    
    func testLitteralSwift() {
        XCTAssertEqual(123.litteral, "123")
        XCTAssertEqual(0.123.litteral, "0.123")
        XCTAssertEqual(true.litteral, "true")
        XCTAssertEqual(false.litteral, "false")
        XCTAssertEqual("abc".litteral, "abc")
        
        XCTAssertEqual(Int(litteral: "123"), 123)
        XCTAssertEqual(Double(litteral: "0.123"), 0.123)
        XCTAssertEqual(Bool(litteral: "true"), true)
        XCTAssertEqual(Bool(litteral: "false"), false)
        XCTAssertEqual(String(litteral: "\"abc\""), "abc")
 }
}
 
