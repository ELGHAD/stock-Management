# Architecture de l'Application

## Vue d'ensemble

Stock Management suit une **architecture Clean Architecture** avec séparation claire des responsabilités en trois couches principales :

1. **Presentation Layer** : Interface utilisateur et logique de présentation
2. **Domain Layer** : Logique métier pure (indépendante du framework)
3. **Data Layer** : Accès aux données (API et base de données locale)

## Structure des Couches

### Presentation Layer

**Responsabilités** :
- Affichage de l'interface utilisateur
- Gestion de l'état avec BLoC
- Navigation entre les écrans
- Validation des entrées utilisateur

**Composants** :
- **Pages** : Écrans de l'application
- **BLoC** : Gestion d'état (Events, States, BLoC)
- **Widgets** : Composants réutilisables

**Exemple** : `lib/features/products/presentation/`

### Domain Layer

**Responsabilités** :
- Logique métier pure (sans dépendances externes)
- Définition des entités métier
- Cas d'utilisation (Use Cases)
- Interfaces des repositories

**Composants** :
- **Entities** : Modèles métier purs
- **Use Cases** : Actions métier spécifiques
- **Repository Interfaces** : Contrats pour l'accès aux données

**Exemple** : `lib/features/products/domain/`

### Data Layer

**Responsabilités** :
- Accès aux données (API REST et base locale)
- Implémentation des repositories
- Modèles de données (DTO)
- Cache et synchronisation

**Composants** :
- **Data Sources** : API Remote et Local (Hive)
- **Models** : Modèles de données avec sérialisation
- **Repository Implementations** : Implémentations concrètes

**Exemple** : `lib/features/products/data/`

## Flux de Données

```
UI (Page)
  ↓
BLoC (Event)
  ↓
Use Case
  ↓
Repository Interface
  ↓
Repository Implementation
  ↓
Data Sources (Remote/Local)
  ↓
API / Hive Database
```

## Pattern BLoC

### Événements (Events)
Représentent les actions utilisateur ou système :
```dart
class LoadProductsEvent extends ProductEvent {}
class CreateProductEvent extends ProductEvent {
  final Product product;
}
```

### États (States)
Représentent l'état de l'application :
```dart
class ProductLoading extends ProductState {}
class ProductLoaded extends ProductState {
  final List<Product> products;
}
```

### BLoC
Transforme les Events en States :
```dart
class ProductBloc extends Bloc<ProductEvent, ProductState> {
  // Logique de transformation
}
```

## Gestion des Données

### Stratégie de Synchronisation

1. **Tentative API** : Appel à l'API REST
2. **Fallback Local** : En cas d'erreur réseau, utilisation de Hive
3. **Cache Automatique** : Sauvegarde des données API en local
4. **Mode Hors Ligne** : Fonctionnement complet sans connexion

### Base de Données Locale (Hive)

**Avantages** :
- Performance élevée
- Pas de schéma SQL
- Type-safe avec Dart
- Persistance automatique

**Boxes utilisées** :
- `products` : Stockage des produits
- `suppliers` : Stockage des fournisseurs
- `stock_movements` : Historique des mouvements
- `auth_box` : Token d'authentification

## Injection de Dépendances

Utilisation de **GetIt** pour l'injection de dépendances :

```dart
// Enregistrement
getIt.registerLazySingleton(() => ProductRepositoryImpl(...));

// Utilisation
final repository = getIt<ProductRepository>();
```

**Avantages** :
- Découplage des dépendances
- Testabilité facilitée
- Gestion du cycle de vie
- Injection par type

## Gestion des Erreurs

### Stratégie Multi-Niveaux

1. **Niveau Data Source** : Gestion des erreurs réseau
2. **Niveau Repository** : Fallback vers données locales
3. **Niveau BLoC** : Émission d'états d'erreur
4. **Niveau UI** : Affichage des messages d'erreur

### Types d'Erreurs

- **Erreurs Réseau** : Timeout, connexion perdue
- **Erreurs Serveur** : 404, 500, etc.
- **Erreurs Validation** : Données invalides
- **Erreurs Locales** : Problèmes de stockage

## Tests (Recommandations)

### Structure de Tests

```
test/
├── features/
│   ├── products/
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/
│   └── ...
└── core/
```

### Types de Tests

1. **Unit Tests** : Use Cases, Repositories
2. **Widget Tests** : Composants UI
3. **Integration Tests** : Flux complets

## Bonnes Pratiques

### À Faire

- Séparer clairement les couches
- Utiliser des entités métier pures
- Implémenter des Use Cases spécifiques
- Gérer les erreurs à chaque niveau
- Documenter le code complexe
- Utiliser des types forts (pas de dynamic)

### À Éviter

- Logique métier dans la couche présentation
- Dépendances circulaires
- Accès direct aux Data Sources depuis la UI
- États mutables partagés
- Code dupliqué

## Évolutivité

L'architecture permet facilement :

- **Ajout de nouvelles fonctionnalités** : Nouvelle feature = nouveau dossier
- **Changement de Data Source** : Modifier uniquement la couche Data
- **Changement de State Management** : Modifier uniquement la couche Presentation
- **Tests isolés** : Tester chaque couche indépendamment

## Performance

### Optimisations

- **Lazy Loading** : Chargement à la demande
- **Cache Local** : Réduction des appels API
- **Pagination** : Pour grandes listes (à implémenter)
- **Debouncing** : Pour les recherches (à implémenter)

## Sécurité

### Mesures Implémentées

- Stockage sécurisé des tokens
- Validation des entrées utilisateur
- Gestion des erreurs sans exposer de détails sensibles

### À Améliorer

- Chiffrement des données sensibles
- Authentification JWT complète
- Refresh tokens
- Validation côté serveur

