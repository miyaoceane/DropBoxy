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

Des scripts d'insertion permettent de peupler les tables avec des données de test.

### 3.2. Procédures stockées et transactions

**Dépôt d'un colis**

Une procédure stockée permet d'enregistrer le dépôt d'un colis. Elle doit notamment :

- vérifier l'existence du client ;
- vérifier que le point relais existe et est actif ;
- rechercher un casier disponible et compatible avec le colis ;
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

Cette fonction calcule le coût de stockage d'un colis à partir de son poids et de sa durée de stockage(heure), selon une règle tarifaire définie dans le projet.


**Fonction retournant une table : recherche des colis**

Cette fonction permet de rechercher les colis selon plusieurs critères facultatifs :

- point relais ;
- statut du colis ;
- taille ;
- date minimale de dépôt ;
- date maximale de dépôt.

Elle peut être utilisée directement dans une requête `SELECT`, ce qui facilite l'exploitation des données.

### 3.4. Curseur d'analyse des points relais

Un curseur permet de parcourir les points relais et de calculer le nombre d'incidents enregistrés pendant une période définie.

Un niveau de surveillance est ensuite attribué selon les règles suivantes :

| Nombre d'incidents | Niveau de surveillance |
|---|---|
| 0 | NORMAL |
| De 1 à 3 | SURVEILLANCE |
| Plus de 3 | PRIORITAIRE |

Le traitement affiche le nom du point relais, le nombre d'incidents et son niveau de surveillance.

Une alternative sans curseur, fondée sur des opérations ensemblistes SQL, est également étudiée afin de comparer les deux approches.

### 3.5. Triggers

**Historisation des changements de statut**

Un trigger associé à la table `COLIS` enregistre automatiquement les changements de statut dans la table `HISTORIQUE_COLIS`.

Les informations conservées sont :

- l'identifiant du colis ;
- la date de modification ;
- l'ancien statut ;
- le nouveau statut.

Cette historisation permet de suivre les changements de statut au cours du temps.

**Contrôle métier des retraits**

Un trigger associé à la table `RETRAIT` empêche l'enregistrement d'un retrait lorsque le colis concerné possède un statut qui n'autorise pas cette opération.

En cas de tentative non autorisée, l'opération est bloquée et un message explicite est retourné.

## 4. Organisation des fichiers SQL

Les scripts sont organisés afin de faciliter leur lecture, leur exécution et leur maintenance.

Exemple d'organisation du projet :

```text
DropBoxy/
│
├── README.md
│
├── sql/
│   ├── creation_tables.sql
│
└── documentation/
    └── dossier_technique.pdf
```

*Remarque : cette arborescence est une proposition. Les noms des fichiers doivent être adaptés à l'organisation réelle du projet.*

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

Les tests ont pour objectif de vérifier le bon fonctionnement des opérations métier et le respect des règles de gestion.

Les scénarios suivants sont à exécuter et à valider avant la livraison.

### Tests des procédures stockées

- Dépôt d'un colis avec un client existant et un point relais actif.
- Tentative de dépôt avec un client inexistant.
- Tentative de dépôt dans un point relais inactif.
- Tentative de dépôt sans casier disponible ou compatible.
- Retrait d'un colis existant avec un code valide.
- Tentative de retrait avec un code incorrect.
- Tentative de retrait d'un colis dont le statut ne permet pas le retrait.
- Vérification de l'annulation des modifications en cas d'erreur.

### Tests des fonctions

- Vérification du prix de stockage pour différents poids et différentes durées.
- Recherche des colis avec un seul critère.
- Recherche des colis avec plusieurs critères.
- Vérification du résultat lorsque certains critères sont absents.

### Tests du curseur

- Vérification du niveau NORMAL pour un point relais sans incident.
- Vérification du niveau SURVEILLANCE pour un point relais ayant entre un et trois incidents.
- Vérification du niveau PRIORITAIRE pour un point relais ayant plus de trois incidents.
- Vérification de la période utilisée pour le comptage des incidents.

### Tests des triggers

- Vérification de l'ajout d'une ligne dans `HISTORIQUE_COLIS` après un changement de statut.
- Vérification de la conservation de l'ancien et du nouveau statut.
- Tentative d'enregistrement d'un retrait non autorisé.
- Vérification que les opérations refusées ne laissent pas de modifications incohérentes.

*Les résultats de chaque test doivent être renseignés après exécution effective des scripts.*

## 7. Difficultés rencontrées

Les principales difficultés susceptibles d'être rencontrées lors de la réalisation du projet concernent :

- la gestion des transactions et des erreurs avec `TRY...CATCH`, `COMMIT` et `ROLLBACK` ;
- la sélection d'un casier compatible et disponible ;
- le maintien de la cohérence entre le statut du colis, le retrait et la disponibilité du casier ;
- la gestion des critères facultatifs dans une fonction retournant une table ;
- la compréhension du fonctionnement des curseurs et la recherche d'une alternative ensembliste ;
- la gestion des anciennes et nouvelles valeurs dans les triggers ;
- le respect de l'ordre de création des objets SQL et la préparation des jeux de données de test.

Cette section devra être complétée avec les difficultés réellement rencontrées et les solutions mises en œuvre.

## 8. Limites et améliorations possibles

Plusieurs améliorations pourraient être apportées à la solution :

- ajouter une gestion plus détaillée des erreurs et des messages retournés par les procédures ;
- renforcer la gestion de la concurrence pour éviter qu'un même casier soit attribué simultanément à plusieurs colis ;
- ajouter des contraintes `CHECK`, `UNIQUE` et `NOT NULL` lorsque cela est pertinent ;
- optimiser les recherches grâce à des index adaptés ;
- remplacer le curseur par une requête ensembliste utilisant des jointures, des agrégations et une expression `CASE` ;
- enrichir l'historisation avec l'identification de l'utilisateur à l'origine de la modification ;
- ajouter des tests automatisés pour les cas nominaux, les erreurs et les situations limites ;
- améliorer la sécurité grâce à une gestion des rôles et des permissions SQL Server.

## 9. Membres et répartition des tâches

**Membres du binôme :**

- Membre 1 : [Nom et prénom]
- Membre 2 : [Nom et prénom]

**Répartition du travail :**

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

Ce projet permet de mettre en pratique les principales fonctionnalités de Transact-SQL sous Microsoft SQL Server : création et peuplement d'une base de données, procédures stockées, transactions, fonctions, curseurs et triggers.

La solution proposée vise à fiabiliser les opérations de dépôt et de retrait, à faciliter la recherche des colis, à analyser les incidents des points relais et à conserver une trace des changements de statut.

Elle constitue une base d'amélioration du système d'information de DropBoxy, qui pourra être complétée par des optimisations, des tests automatisés et des mécanismes de sécurité supplémentaires.
