# Stock Management

Application mobile Flutter de gestion de stock pour petites entreprises : produits, fournisseurs, mouvements de stock et tableau de bord, conçue pour fonctionner hors ligne.

Auteur : **Hamza Elrhadiouini**

---

## L'histoire du projet

Tout commence par une scène banale dans une petite boutique. Un client demande un article, le gérant se tourne vers l'étagère et découvre qu'il n'en reste plus. Le carnet où les entrées et les sorties étaient notées n'a pas été mis à jour depuis plusieurs jours, la commande au fournisseur n'a pas été passée et la vente est perdue.

Ce problème n'a rien de technique : c'est un problème d'information. Le stock existe, mais personne ne sait exactement ce qu'il contient, ce qu'il vaut ni quand il faut le réapprovisionner.

**Stock Management** est né de ce constat. L'objectif était de construire un outil qui tienne dans la poche du gérant, qui fonctionne même sans connexion internet et qui réponde immédiatement à trois questions :

1. Qu'est-ce que j'ai en stock, et combien cela vaut-il ?
2. Qu'est-ce qui est sur le point de manquer ?
3. Que s'est-il passé dans mon stock, quand et pourquoi ?

Chaque fonctionnalité de l'application découle de l'une de ces questions.

## Ce que fait l'application

### Un accès personnel
L'utilisateur crée un compte puis se connecte. La session est conservée localement : à la réouverture de l'application, il retrouve directement son tableau de bord.

### Un catalogue de produits maîtrisé
Chaque produit est décrit par son nom, sa description, son prix, sa quantité en stock et un **seuil d'alerte** propre. Un produit peut être rattaché à un fournisseur. Création, consultation, modification et suppression sont disponibles depuis un seul écran.

### Des fournisseurs identifiés
Les fournisseurs sont enregistrés avec leurs coordonnées complètes (nom, email, téléphone, adresse), ce qui permet de savoir immédiatement qui contacter lorsqu'un produit passe sous son seuil.

### Une traçabilité de chaque mouvement
Chaque entrée (réception, réapprovisionnement) et chaque sortie (vente, perte, casse) est enregistrée avec sa quantité, sa date et un motif. La quantité du produit est mise à jour automatiquement, et une sortie supérieure au stock disponible est refusée. L'historique devient le journal de bord du stock.

### Une vue d'ensemble en un coup d'oeil
Le tableau de bord rassemble les indicateurs essentiels :

- nombre total de produits ;
- produits disponibles et produits en rupture ;
- valeur totale du stock ;
- répartition visuelle sous forme de graphique circulaire ;
- liste des produits à réapprovisionner en priorité.

### Pensée pour le terrain
Les données sont stockées localement avec Hive : l'application reste pleinement utilisable sans réseau. La couche réseau (Dio) est déjà prête à communiquer avec une API REST lorsque celle-ci sera disponible. L'interface suit Material Design 3 et s'adapte automatiquement au thème clair ou sombre de l'appareil.

## Architecture

Le projet applique la **Clean Architecture**, organisée par fonctionnalité. Chaque module métier est découpé en trois couches indépendantes :

```
lib/
├── core/                     Briques transverses
│   ├── di/                   Injection de dépendances (GetIt)
│   ├── network/              Client HTTP (Dio) et intercepteurs
│   ├── storage/              Stockage local (Hive)
│   ├── theme/                Thèmes clair et sombre
│   └── utils/                Constantes et routes
│
└── features/
    ├── auth/                 Inscription, connexion, session
    ├── products/             Catalogue produits
    ├── suppliers/            Fournisseurs
    ├── stock/                Mouvements et statistiques
    └── dashboard/            Tableau de bord
        │
        ├── data/             Sources de données, modèles, implémentations
        ├── domain/           Entités, contrats de repository, cas d'utilisation
        └── presentation/     BLoC (événements, états) et écrans
```

Le flux d'une action utilisateur est toujours le même :

```
Écran -> BLoC (Event) -> Use Case -> Repository -> Source distante / Source locale
```

Le repository tente d'abord la source distante ; en cas d'échec réseau, il bascule sur les données locales. La logique métier reste ainsi indépendante du framework, de l'API et de la base de données.

Une description détaillée est disponible dans [docs/ARCHITECTURE.md](docs/ARCHITECTURE.md).

## Stack technique

| Domaine | Technologies |
|---|---|
| Framework | Flutter, Dart (SDK >= 3.0) |
| Gestion d'état | flutter_bloc, equatable |
| Injection de dépendances | get_it |
| Réseau | dio, connectivity_plus |
| Persistance locale | hive, hive_flutter, shared_preferences |
| Visualisation | fl_chart |
| Utilitaires | intl, uuid |
| Interface | Material Design 3 |

## Démarrage

### Prérequis

- Flutter SDK 3.x
- Android Studio ou VS Code avec l'extension Flutter
- Un émulateur ou un appareil physique

### Installation

```bash
git clone https://github.com/<votre-compte>/stock-Management.git
cd stock-Management
flutter pub get
flutter run
```

### Première utilisation

1. Sur l'écran de connexion, créer un compte via **Inscription**.
2. Une fois connecté, ajouter un ou plusieurs **fournisseurs**.
3. Créer les **produits** en leur attribuant un prix, une quantité initiale et un seuil d'alerte.
4. Enregistrer les **entrées et sorties** de stock au fil de l'activité.
5. Suivre l'état global depuis le **tableau de bord**.

Navigation : la barre inférieure donne accès au tableau de bord, aux produits, aux fournisseurs et à l'historique. Un appui simple sur un élément permet de le modifier, un appui long de le supprimer.

### Connexion à une API

Par défaut, l'application fonctionne en mode local. Pour brancher un backend REST, renseigner l'URL de base dans `lib/core/network/api_client.dart` et `lib/core/utils/constants.dart`, puis réactiver les appels distants dans les sources de données de chaque fonctionnalité (`features/*/data/datasources/`).

## Modèle de données

| Entité | Champs principaux |
|---|---|
| Produit | id, name, description, price, quantity, minQuantity, supplierId, supplierName, createdAt, updatedAt |
| Fournisseur | id, name, email, phone, address, createdAt, updatedAt |
| Mouvement de stock | id, productId, productName, type (entrée / sortie), quantity, reason, date |

## Feuille de route

- Synchronisation bidirectionnelle avec un serveur distant
- Export des données en PDF et Excel
- Notifications pour les alertes de rupture
- Lecture de codes-barres
- Gestion multi-utilisateurs avec rôles
- Rapports et analyses avancés
- Interface optimisée pour tablette
- Couverture de tests unitaires et de widgets

## Auteur

**Hamza Elrhadiouini** - conception et développement.

## Licence

Ce projet est distribué sous licence MIT. Voir le fichier [LICENSE](LICENSE).
