//
//  ExemplesPredicats.swift
//  JeuSudoku_FW
//
//  Created by Gérard Tisseau on 14/03/2023.
//

import Foundation

func testRegleCelluleElimineeDirectement() {
    
    /// Un Puzzle est vu comme une base de données.
    /// Une règle permet de résoudre des requêtes dans cette base de données
    /// grâce à ses static func `instances`.
    
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
    
    // Les éliminatrices de la valeur 5 qui éliminent la cellule Ba
    let eliminatrices = CelluleElimineeDirectement
        .instances(cellule: Cellule(nom: "Ba"), valeur: 5, dans: puzzle)
        .map { $0.eliminatrice.nom }.sorted()
    XCTAssertEqual(eliminatrices, ["Aa_5", "Bf_5"])
    
    // Les éliminées par `Bf_5` dans `Mm`
    let eliminees = CelluleElimineeDirectement
        .instances(zone: Carre(nom: "Mm"), eliminatrice: Presence(nom: "Bf_5"), dans: puzzle)
        .map { $0.cellule.nom }.sorted()
    XCTAssertEqual(eliminees, ["Ba", "Bc"])
    
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

    /// Dans `Pn` en bas au centre,  `HeHf_2`est une paire1 pour la valeur 2
    /// Parce que 2 est éliminée dans la ligne G par `Gi_2` et dans la ligne I par `Ia_2`

    XCTAssertEqual(
        SingletonEliminateur.instances(valeur: 2, zone: Carre(nom: "Pn"), dans: puzzle)
            .map { $0.singleton.nom },
        ["Gi_2", "Ia_2"]
    )
    
    XCTAssertEqual(
        Paire1.instances(valeur: 2, zone: Carre(nom: "Pn"), dans: puzzle).map { $0.paire1.nom},
        ["HeHf_2"]
    )
}


func testReglePaire2() {
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
    
    let instance = Paire2.instances(zone: Colonne(nom: "h"), pour: (5, 6), dans: puzzle)[0]
    
    XCTAssertEqual(instance.paire.nom, "AhIh_56")
    
    XCTAssertEqual(instance.occupees.map { $0.nom }, ["Bh", "Ch", "Dh", "Eh", "Fh", "Gh"])
    
    XCTAssertEqual(instance.eliminees.map { $0.cellule.nom }, ["Hh"])

    /*
     Ce qui signifie :
     
     On a trouvé une paire2 AhIh_56 en cherchant dans la colonne h les cellules éliminées pour les valeurs 5 et 6 (pour les deux valeurs à la fois, par seulement pour l'une ou l'autre).
     
     Explication :
     
     Les cases éliminées sont ["Hh"]
     Les cases occupées dans la colonne sont ["Bh", "Ch", "Dh", "Eh", "Fh", "Gh"]
     Il ne reste alors plus que les deux cellules Ah et Ih. Deux cellules pour deux valeurs, cela forme une paire2.
     
     */

    
    
    
}

