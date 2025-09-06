# 📝 Système de Commentaires pour les Études BET - Module MOA

## 🎯 Vue d'ensemble

Ce système permet aux utilisateurs du module MOA d'ajouter et de consulter des commentaires sur les études BET (Bureau d'Études Techniques).

## 🏗️ Architecture

### Structure des fichiers

```
lib/moa/
├── models/
│   └── study_comment.dart              # Modèle de données
├── services/
│   └── StudyCommentService.dart        # Service API
├── repository/
│   └── study_comment_repository.dart   # Repository
├── bloc/study_comments/
│   ├── study_comments_event.dart       # Événements
│   ├── study_comments_state.dart       # États
│   └── study_comments_bloc.dart        # Logique métier
└── widgets/
    ├── study_comment_form.dart         # Formulaire de commentaire
    └── study_comments_list.dart        # Liste des commentaires
```

## 🔧 Fonctionnalités

### ✅ Ajout de commentaires
- Formulaire de saisie avec validation
- Limite de 500 caractères
- Indicateur de chargement
- Gestion d'erreurs

### ✅ Affichage des commentaires
- Liste chronologique des commentaires
- Informations sur l'auteur et la date
- Formatage des dates (relatif et absolu)
- États de chargement et d'erreur

### ✅ Interface utilisateur
- Design cohérent avec l'application
- Responsive et accessible
- Feedback visuel pour les actions

## 🚀 Utilisation

### 1. Dans une page d'étude

```dart
// Ajouter le BLoC provider
BlocProvider(
  create: (context) => StudyCommentsBloc(
    repository: StudyCommentRepository(),
  )..add(LoadStudyComments(studyRequestId: studyId)),
  child: YourWidget(),
)

// Utiliser le formulaire
StudyCommentForm(
  studyRequestId: studyId,
  userId: userId,
)

// Afficher la liste
StudyCommentsList(
  studyRequestId: studyId,
)
```

### 2. API Endpoints

#### Ajouter un commentaire
```http
POST /api/study-requests/comment/study/{studyRequestId}/users/{userId}
Content-Type: application/json

{
  "content": "Contenu du commentaire"
}
```

#### Récupérer les commentaires
```http
GET /api/study-requests/{studyRequestId}/comments
```

## 📊 Modèle de données

### StudyComment

```dart
class StudyComment {
  final int id;
  final String content;
  final DateTime createdAt;
  final int authorId;
  final String authorName;
}
```

### Format de réponse API

```json
{
  "id": 6,
  "content": "Deuxieme rapport d etude",
  "createdAt": [2025, 9, 5, 23, 17, 38, 120410949],
  "authorId": 36,
  "authorName": "SENE"
}
```

## 🎨 Interface utilisateur

### Formulaire de commentaire
- Champ de texte multi-lignes (4 lignes max)
- Compteur de caractères (500 max)
- Boutons "Annuler" et "Envoyer"
- Indicateur de chargement

### Liste des commentaires
- Cartes avec avatar de l'auteur
- Nom et date de création
- Contenu du commentaire
- Formatage des dates intelligentes

## 🔄 Gestion d'état (BLoC)

### Événements
- `LoadStudyComments` - Charger les commentaires
- `AddStudyComment` - Ajouter un commentaire
- `RefreshStudyComments` - Rafraîchir la liste

### États
- `StudyCommentsInitial` - État initial
- `StudyCommentsLoading` - Chargement
- `StudyCommentsLoaded` - Commentaires chargés
- `StudyCommentsError` - Erreur de chargement
- `StudyCommentAdding` - Ajout en cours
- `StudyCommentAdded` - Commentaire ajouté
- `StudyCommentAddError` - Erreur d'ajout

## 🛠️ Configuration

### Dépendances requises
```yaml
dependencies:
  dio: ^5.8.0+1
  flutter_bloc: ^9.1.1
  equatable: ^2.0.7
  intl: ^0.20.2
```

### Permissions
Aucune permission spéciale requise.

## 🧪 Tests

### Test de l'API
```bash
dart test_comment_api.dart
```

### Test manuel
1. Ouvrir une étude BET
2. Ajouter un commentaire
3. Vérifier l'affichage
4. Tester la gestion d'erreurs

## 🐛 Gestion d'erreurs

### Erreurs API
- **400** - Données invalides
- **401** - Non autorisé
- **403** - Accès refusé
- **404** - Étude non trouvée
- **500** - Erreur serveur

### Erreurs de connexion
- Timeout de connexion
- Erreur de réseau
- Service indisponible

## 📱 Intégration

### Page de détail d'étude
Le système est intégré dans `EtudeDetailPage` :
- Section commentaires avec compteur
- Formulaire d'ajout
- Liste des commentaires existants

### Navigation
- Accessible depuis l'onglet "Études BET"
- Intégré dans la page de détail de chaque étude

## 🔮 Améliorations futures

- [ ] Édition de commentaires
- [ ] Suppression de commentaires
- [ ] Pièces jointes
- [ ] Notifications en temps réel
- [ ] Mentions d'utilisateurs
- [ ] Réactions aux commentaires

## 📞 Support

Pour toute question ou problème :
1. Vérifier les logs de l'application
2. Tester l'API avec le script fourni
3. Consulter la documentation des erreurs

---

**Version:** 1.0.0  
**Dernière mise à jour:** $(date)  
**Auteur:** Assistant IA
