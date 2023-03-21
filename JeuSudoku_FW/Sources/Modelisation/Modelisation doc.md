#  Modelisation doc

La modélisation d'un domaine se fait à l'aide de deux sortes de types Swift :

- Les types littéraux, conformes à `UnLitteral`
- les types objets, conformes à `CodableEnLitteral`

Les littéraux concernent la représentation "syntaxique" et les types objets la représentation "sémantique"

## Types littéraux

Un littéral peut êre de trois formes :

- Une String
- Un Array de littéraux dont les éléments sont distincts
- Une struct dont les variables stockées sont des littéraux

De plus, pour déclarer qu'il est littéral, un type doit être conforme au protocole UnLitteral

    public protocol UnLitteral: Hashable, Comparable, Identifiable, CustomStringConvertible, CodableEnJson  {
    
        var codeSwift: String { get }
    }
   
Il y a une seule méthode à implémenter : `codeSwift` : le code Swift (une String) qui permet la recréation du littéral. Ce code sert d'identificateur pour le protocole `Identifiable`. Il peut être recopié dans un code source Swift pour recréer le littéral, ce qui permet de mémoriser des littéraux obtenus par calcul, par exemple dans des tests.
    
Les nombreux protocoles Swift sont là pour rendre ces littéraux pratiques et manipulables dans tous les contextes. La description associée à `CustomStringConvertible` est le `codeSwift`. Donc quand on fait `print(x)` pour un littéral `x`, on voit son `codeSwift`. Et la variable `id`de `Identifiable` est le `codeSwift`. Grâce à `Comparable`, les Array de littéraux peuvent être ordonnés par la méthode `sorted()`, qui ordonne suivant l'ordre alphabétique des `codeSwift`.

Le protocole `CodableEnJson` est là pour permettre l'import-export en Json, là aussi de manière pratique dans différents contextes de traitement d'erreurs :

    public protocol CodableEnJson: Codable {
    
        // Fonctions directes avec fatalError si échec
    
        var json: String { get }
        static func avecJson(_ json: String) -> Self
    
        // Fonctions avec Result
    
        var jsonResult: Result<String, String> { get }
        static func avecJsonResult(_ json: String) -> Result<Self, String>
    
        // fonctions avec try
    
        func jsonThrows() throws -> String
        static func avecJsonThrows(_ json: String) throws -> Self
    }

Le protocole `UnLitteral` est destiné à servir de protocole de communication entre différents modules bien séparés qui ne connaissent rien de leurs implémentations respectives, par exemple un framework et une interface.

## Types objets

Un "type objet" est un type Swift qui admet une représentation en littéral, suivant le protocole `CodableEnLitteral` :

    public protocol CodableEnLitteral: Hashable, Identifiable, CustomStringConvertible, Comparable {
        associatedtype Litteral: UnLitteral
        
        var litteral: Litteral { get }
        init(litteral: Litteral)
    }

On peut reconstituer l'objet d'après son littéral.

Un protocole spécialisé qui hérite de `CodableEnLitteral` est `InstanciableParNom`. C'est le cas où le littéral est une String, qu'on appelle le "nom" de l'objet :

    public protocol InstanciableParNom: CodableEnLitteral {
        
        var nom: String { get }
        init(nom: String)
    }

Ce type d'objet instanciable par nom est vu comme "atomique", les autres étant "composés".

On peut sauvegarder un objet sur un fichier en sauvegardant son littéral en Json. A la lecture, on relit le littéral avec `avecJson(json:)` puis on reconstitue l'objet à partir du littéral avec `init(litteral:)`

## Types prédicats, faits

Certains types objet composés peuvent être considérés comme des "prédicats" exprimant une relation entre différents objets. Une instance d'un type prédicat est vue comme un "fait". C'est un point de vue qui s'apparente aux bases de données relationnelles et aux langages logiques comme Prolog.

Un type prédicat possède différentes `static func` surcharges de `instances` vues comme des requêtes permettant d'effectuer des recherches. Chacune rend une liste de faits instances du prédicat : les faits qui satisfont les conditions de la requête. Chaque type de prédicat a ses requêtes particulières. Il n'y a pas de requête générique automatique, il faut programmer chaque requête.

La seule chose qui distingue un type prédicat d'un autre type objet est l'existence de fonctions requêtes `instances`, et cela ne peut pas être exprimé par un protocole car il n'y a rien de générique. Tout tient seulement dans l'interprétation que le programmeur en fait.

Dans cette vision "langage logique relationnel" du modèle, certains objets sont considérés comme des entités (des choses qui existent) et d'autres comme des faits (des phrases qui relient des entités et éventuellement d'autres faits). Mais ce n'est pas explicitement formalisé en Swift, c'est juste un point de vue du programmeur.
