# DropBoxy — Conception et exploitation d'une base de données SQL Server

## 1. Contexte du projet

DropBoxy est une entreprise qui exploite un réseau de points relais et de casiers connectés permettant aux particuliers de déposer et de retirer des colis.

Dans le cadre de ce projet, nous intervenons en tant qu'administrateurs SQL Server juniors afin d'améliorer la gestion et l'exploitation de la base de données de l'entreprise.

L'objectif est de mettre en place des mécanismes permettant d'automatiser les opérations métier, de sécuriser les modifications de données, de faciliter les recherches et de conserver un historique des changements importants.

Le projet porte notamment sur la gestion des points relais, des casiers, des clients, des colis, des retraits, des incidents techniques et des techniciens.

## 2. Technologies utilisées

- **Outil de développement et d'administration :** SQL Server Management Studio (SSMS)
- **Langage :** Transact-SQL (T-SQL)
- **Automatisation et contrôle :** procédures stockées, fonctions et triggers

## 3. Fonctionnalités

### 3.1. Création et peuplement de la base de données

Création des tables nécessaires au fonctionnement de DropBoxy, avec leurs clés primaires et étrangères pour assurer la cohérence des relations entre les données.

Les tables principales sont :

- `POINT_RELAIS` : informations sur les points relais.
- `CASIER` : caractéristiques et disponibilité des casiers.
- `CLIENT` : informations relatives aux clients.
- `COLIS` : données concernant les colis déposés.
- `RETRAIT` : informations sur les retraits effectués.
- `TECHNICIEN` : informations sur les techniciens.
- `INCIDENT` : incidents techniques associés aux points relais et aux casiers.
- `HISTORIQUE_COLIS` : l'historique des changement de statut de chaque colis.

Le modèle intègre des clés primaires et étrangères ainsi que des contraintes permettant de contrôler les statuts, les tailles et l'unicité de certaines données.

Le jeu de données de test contient des points relais, des casiers, des clients, des colis, des retraits et des incidents techniques.


### 3.2. Procédures stockées et transactions

**Dépôt d'un colis**

Une procédure stockée permet d'enregistrer le dépôt d'un colis. Elle doit notamment :

- vérifier l'existence du client ;
- vérifier que le point relais existe et est actif ;
- Vérifie que le casier disponible et compatible avec le colis ;
- enregistrer le colis ;
- affecter le casier au colis ;
- retourner l'identifiant du colis créé.

L'ensemble des opérations est exécuté dans une transaction afin de garantir la cohérence des données.

**Retrait d'un colis**

Une seconde procédure stockée permet de gérer le retrait d'un colis. Elle doit :

- vérifier l'existence du colis ;
- vérifier que son statut autorise le retrait ;
- contrôler le code de retrait ;
- enregistrer le retrait ;
- mettre à jour le statut du colis ;
- libérer le casier associé.

La transaction garantit que toutes les modifications sont validées ensemble ou annulées en cas d'erreur.

### 3.3. Fonctions SQL

**Fonction scalaire : calcul du prix de stockage**

fonction scalaire calculant le prix de stockage à partir du poids du colis et de la durée de stockage.

Règle tarifaire : 0,50 € par kilogramme, auxquels s'ajoutent 0,10 € par heure de stockage.


**Fonction retournant une table : recherche des colis**

fonction retournant une table permettant de filtrer les colis selon le point relais, le statut, la taille et les dates de dépôt. Les critères facultatifs peuvent être ignorés en leur passant NULL.

Les deux fonctions sont utilisées dans des requêtes SQL afin d'illustrer leur intérêt dans l'exploitation de la base.

### 3.4. Curseur d'analyse des points relais

Un curseur parcourt les points relais et affiche leur nombre d'incidents sur une période donnée ainsi que leur niveau de surveillance :

| Nombre d'incidents | Niveau de surveillance |
|---|---|
| 0 | NORMAL |
| De 1 à 3 | SURVEILLANCE |
| Plus de 3 | PRIORITAIRE |

Le traitement affiche le nom du point relais, le nombre d'incidents et son niveau de surveillance.

Une solution alternative utilisant une requête ensembliste avec LEFT JOIN, COUNT et CASE est également proposée. Les deux approches sont comparées dans le dossier technique.

### 3.5. Triggers

**Historisation des changements de statut**

Un trigger associé à la table `COLIS` enregistre automatiquement  les changements de statut des colis, en conservant l'ancien statut et le nouveau statut dans la table `HISTORIQUE_COLIS`.

Les informations conservées sont :

- l'identifiant du colis ;
- la date de modification ;
- l'ancien statut ;
- le nouveau statut.

Cette historisation permet de suivre les changements de statut au cours du temps.

**Contrôle métier des retraits**

Un trigger associé à la table `RETRAIT` empêche empêche l'insertion d'un retrait lorsque le statut du colis ne permet pas cette opération et renvoie un message explicite.

En cas de tentative non autorisée, l'opération est bloquée et un message explicite est retourné.

## 4. Organisation des fichiers SQL

Le projet est organisé en deux dossiers principaux : SQL/, qui regroupe les scripts SQL, et Documentation/, qui contient le dossier technique.

Les fichiers SQL couvrent la création et le peuplement des tables, les procédures stockées, les fonctions, l'analyse des incidents et les triggers.

Exemple d'organisation du projet :

```text
DropBoxy/
│
├── Documentation/
│   └── Dossier technique - Projet DropBoxy.pdf
│
├── SQL/
│   ├── Fonction_Scalaire_CalculerPrixStockage.sql
│   ├── Procedure_DepotColis.sql
│   ├── Tables.sql
│   ├── Fonction_Table_RechercherColis.sql
│   ├── Trigger_ControleRetraitsql
│   ├── Curseur.sql
│   ├── Procedure_RetraitColis.sql
│   └── Trigger_HistoriqueColis.sql
│
├── .gitattributes
├── .gitignore
├── Conception Base de Données.slnx
└── README.md
```



## 5. Guide d'installation et d'utilisation

### Prérequis

- Installer SQL Server Management Studio (SSMS).
- Avoir les droits nécessaires pour créer une base de données et exécuter des scripts SQL.

### Étapes de lancement

1. Ouvrir SQL Server Management Studio et se connecter à une instance SQL Server.
2. Créer ou sélectionner la base de données destinée au projet DropBoxy.
3. Exécuter le script de création des tables.
4. Exécuter le script de peuplement des données de test.
5. Créer les procédures stockées.
6. Créer les fonctions SQL.
7. Exécuter le script d'analyse des points relais avec le curseur.
8. Créer les triggers d'historisation et de contrôle métier.
9. Exécuter les scripts de test afin de vérifier le fonctionnement des différents mécanismes.

**Important :** respecter l'ordre d'exécution des scripts, car certaines procédures, fonctions et certains triggers dépendent des tables créées précédemment.

### Exemples d'utilisation

Les exemples suivants illustrent les types d'opérations à réaliser. Les noms des procédures, fonctions et paramètres sont à adapter à leur définition réelle dans les scripts.

```sql
-- Exemple de consultation des colis
SELECT *
FROM COLIS;

-- Exemple de consultation de l'historique des statuts
SELECT *
FROM HISTORIQUE_COLIS
ORDER BY DateModification DESC;
```

## 6. Tests effectués

Les tests documentés couvrent notamment :

- le dépôt valide d'un colis et le passage du casier au statut INDISPONIBLE ;
- le refus d'un nouveau dépôt dans un casier déjà indisponible ;
- le refus d'un retrait avec un colis inexistant, déjà retiré ou un code incorrect ;
- le retrait valide, avec mise à jour du colis et libération du casier ;
- le calcul du prix de stockage ;
- la recherche des colis selon différents critères ;
- le classement des points relais selon le nombre d'incidents ;
- l'historisation des changements de statut ;
- le blocage d'un retrait non autorisé.

## 7. Difficultés rencontrées

Les principales difficultés ont concerné l'harmonisation des scripts SQL, la gestion des identifiants IDENTITY, les différences de types de données pour les tailles, l'ajout du code de retrait dans la table COLIS, la gestion des transactions et la mise en place des triggers.

L'intégration des scripts a également nécessité de définir un ordre d'exécution précis et de coordonner les développements réalisés en binôme.

## 8. Limites et améliorations possibles

- Plusieurs améliorations sont envisageables :
- sélectionner automatiquement un casier compatible et disponible ;
- renforcer la gestion des dépôts simultanés ;
- utiliser DATETIME2 pour conserver précisément l'heure du dépôt ;
- sécuriser le code de retrait et limiter les tentatives ;
- ajouter des contrôles sur les valeurs négatives ou nulles dans le calcul du prix ;
- enrichir l'historique avec l'identité de l'utilisateur à l'origine de la modification ;


## 9. Membres et répartition des tâches

### Maimouna Sokhna Thiam :

- Procédure de retrait de colis
- Fonction de table
- Curseur et alternative ensembliste
- Trigger contrôle métier 
- Tests et intégration
- Documentation technique

  
### Ablan Miya Océane Kouadio :

- Creation et peuplement des tables
- Fonction Scalaire
- Procédure de dépôt de colis
- Trigger de l'historique
- Tests et intégration
- README et Documentation technique

La répartition doit refléter le travail réellement effectué. Les deux membres participent à l'intégration et aux tests et doivent être capables d'expliquer l'ensemble de la solution.

## 10. Conclusion

Ce projet met en pratique les principales fonctionnalités de Transact-SQL sous Microsoft SQL Server : procédures stockées, transactions, fonctions, curseurs et triggers.

Il vise à fiabiliser les opérations de dépôt et de retrait, à faciliter les recherches, à analyser les incidents des points relais et à conserver l'historique des changements de statut.

Le dossier technique présente les choix de conception, les tests réalisés, les difficultés rencontrées et les améliorations envisageables.
