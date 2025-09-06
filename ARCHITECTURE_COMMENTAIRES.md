# 🏗️ Architecture du Système de Commentaires

## 📊 Diagramme de l'architecture

```
┌─────────────────────────────────────────────────────────────────┐
│                        INTERFACE UTILISATEUR                    │
├─────────────────────────────────────────────────────────────────┤
│  ┌─────────────────┐    ┌─────────────────┐                    │
│  │ StudyCommentForm│    │StudyCommentsList│                    │
│  │                 │    │                 │                    │
│  │ • Formulaire    │    │ • Liste         │                    │
│  │ • Validation    │    │ • Affichage     │                    │
│  │ • Envoi         │    │ • Formatage     │                    │
│  └─────────────────┘    └─────────────────┘                    │
└─────────────────────────────────────────────────────────────────┘
                                │
                                ▼
┌─────────────────────────────────────────────────────────────────┐
│                           BLoC LAYER                            │
├─────────────────────────────────────────────────────────────────┤
│  ┌─────────────────────────────────────────────────────────────┐ │
│  │                StudyCommentsBloc                           │ │
│  │                                                             │ │
│  │  Événements:                    États:                      │ │
│  │  • LoadStudyComments          • StudyCommentsInitial        │ │
│  │  • AddStudyComment            • StudyCommentsLoading        │ │
│  │  • RefreshStudyComments       • StudyCommentsLoaded         │ │
│  │                               • StudyCommentsError          │ │
│  │                               • StudyCommentAdding          │ │
│  │                               • StudyCommentAdded           │ │
│  │                               • StudyCommentAddError        │ │
│  └─────────────────────────────────────────────────────────────┘ │
└─────────────────────────────────────────────────────────────────┘
                                │
                                ▼
┌─────────────────────────────────────────────────────────────────┐
│                        REPOSITORY LAYER                         │
├─────────────────────────────────────────────────────────────────┤
│  ┌─────────────────────────────────────────────────────────────┐ │
│  │              StudyCommentRepository                        │ │
│  │                                                             │ │
│  │  • addComment()                                             │ │
│  │  • getComments()                                            │ │
│  │  • Gestion d'erreurs                                        │ │
│  └─────────────────────────────────────────────────────────────┘ │
└─────────────────────────────────────────────────────────────────┘
                                │
                                ▼
┌─────────────────────────────────────────────────────────────────┐
│                         SERVICE LAYER                           │
├─────────────────────────────────────────────────────────────────┤
│  ┌─────────────────────────────────────────────────────────────┐ │
│  │               StudyCommentService                          │ │
│  │                                                             │ │
│  │  • addComment()                                             │ │
│  │  • getComments()                                            │ │
│  │  • Gestion des erreurs HTTP                                │ │
│  │  • Configuration Dio                                        │ │
│  └─────────────────────────────────────────────────────────────┘ │
└─────────────────────────────────────────────────────────────────┘
                                │
                                ▼
┌─────────────────────────────────────────────────────────────────┐
│                          API LAYER                              │
├─────────────────────────────────────────────────────────────────┤
│  ┌─────────────────────────────────────────────────────────────┐ │
│  │                    API REST                                │ │
│  │                                                             │ │
│  │  POST /api/study-requests/comment/study/{id}/users/{id}    │ │
│  │  GET  /api/study-requests/{id}/comments                     │ │
│  │                                                             │ │
│  │  Headers:                                                   │ │
│  │  • Authorization: Bearer {token}                            │ │
│  │  • Content-Type: application/json                           │ │
│  └─────────────────────────────────────────────────────────────┘ │
└─────────────────────────────────────────────────────────────────┘
```

## 🔄 Flux de données

### 1. Ajout d'un commentaire

```
Utilisateur saisit commentaire
         │
         ▼
StudyCommentForm (Validation)
         │
         ▼
StudyCommentsBloc (AddStudyComment)
         │
         ▼
StudyCommentRepository (addComment)
         │
         ▼
StudyCommentService (API Call)
         │
         ▼
API REST (POST /comment)
         │
         ▼
Réponse API → StudyComment
         │
         ▼
StudyCommentsBloc (StudyCommentAdded)
         │
         ▼
UI Update (Nouveau commentaire affiché)
```

### 2. Chargement des commentaires

```
Page s'ouvre
         │
         ▼
StudyCommentsBloc (LoadStudyComments)
         │
         ▼
StudyCommentRepository (getComments)
         │
         ▼
StudyCommentService (API Call)
         │
         ▼
API REST (GET /comments)
         │
         ▼
List<StudyComment>
         │
         ▼
StudyCommentsBloc (StudyCommentsLoaded)
         │
         ▼
StudyCommentsList (Affichage)
```

## 🎯 Points clés de l'architecture

### ✅ Séparation des responsabilités
- **UI Layer** : Interface utilisateur pure
- **BLoC Layer** : Logique métier et gestion d'état
- **Repository Layer** : Abstraction des données
- **Service Layer** : Communication API
- **API Layer** : Endpoints REST

### ✅ Gestion d'état réactive
- États clairs et prévisibles
- Gestion des cas de chargement et d'erreur
- Mise à jour automatique de l'UI

### ✅ Gestion d'erreurs robuste
- Erreurs HTTP spécifiques
- Erreurs de connexion
- Messages d'erreur utilisateur

### ✅ Testabilité
- Chaque couche peut être testée indépendamment
- Injection de dépendances
- Mocking facile des services

## 🔧 Configuration requise

### Dépendances
```yaml
dependencies:
  flutter_bloc: ^9.1.1  # Gestion d'état
  dio: ^5.8.0+1         # Requêtes HTTP
  equatable: ^2.0.7     # Comparaison d'objets
  intl: ^0.20.2         # Formatage des dates
```

### Configuration API
- Base URL : `https://wakana.online`
- Authentification : Bearer Token
- Content-Type : `application/json`

## 📱 Intégration dans l'application

### Page de détail d'étude
```dart
EtudeDetailPage
├── _StudyHeader
├── _RejectionSection / _ReportsSection
└── _CommentsSection
    ├── StudyCommentForm
    └── StudyCommentsList
```

### Navigation
```
MOA Main Screen
└── Projets
    └── Études BET Tab
        └── Étude Detail
            └── Commentaires
```

## 🚀 Avantages de cette architecture

1. **Maintenabilité** : Code organisé et modulaire
2. **Testabilité** : Chaque composant isolé
3. **Évolutivité** : Facile d'ajouter de nouvelles fonctionnalités
4. **Réutilisabilité** : Composants réutilisables
5. **Performance** : Gestion d'état optimisée
6. **UX** : Interface réactive et intuitive
