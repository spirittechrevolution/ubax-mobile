# Intégration APIs — UBAX Mobile

> Spécifications consolidées des 3 épopées d'intégration API mobile assignées à `hdiop@ubax.io`.

## Sommaire

- [MOB-AUTH — Authentification (Keycloak)](#scrum-279--mob-auth--authentification-mobile)
  - [SCRUM-282 · Login par téléphone](#scrum-282--mob-auth-01--login-par-numéro-de-téléphone)
  - [SCRUM-283 · Inscription OTP](#scrum-283--mob-auth-02--inscription-otp)
  - [SCRUM-284 · Mot de passe oublié OTP](#scrum-284--mob-auth-03--mot-de-passe-oublié-otp-sms)
  - [SCRUM-285 · Mise à jour avatar](#scrum-285--mob-auth-04--mise-à-jour-avatar)
- [MOB-BAILLEUR — Module Bailleur](#scrum-280--mob-bailleur--module-bailleur-mobile)
  - [SCRUM-286 · Demande d'adhésion](#scrum-286--mob-bailleur-01--demande-dadhésion-à-une-agence)
  - [SCRUM-287 · Mes biens](#scrum-287--mob-bailleur-02--mes-biens)
  - [SCRUM-288 · Mes contrats de bail](#scrum-288--mob-bailleur-03--mes-contrats-de-bail)
  - [SCRUM-289 · Mes loyers & paiements](#scrum-289--mob-bailleur-04--mes-loyers--paiements)
  - [SCRUM-290 · Profil bailleur & avatar](#scrum-290--mob-bailleur-05--profil-bailleur--avatar)
  - [SCRUM-294 · Mes abonnements agence](#scrum-294--mob-bailleur-06--mes-abonnements-agence)
- [MOB-CLIENT — Catalogue & Recherche](#scrum-281--mob-client--catalogue--recherche-de-biens)
  - [SCRUM-291 · Catalogue public](#scrum-291--mob-client-01--catalogue-des-biens-public)

---

## SCRUM-279 · MOB-AUTH — Authentification Mobile

- **Statut :** À faire · **Type :** Tâche · **Priorité :** Medium · **Assigné :** hdiop
- **Lien Jira :** https://ubax-team.atlassian.net/browse/SCRUM-279

Module regroupant toutes les intégrations d'API d'authentification pour l'application mobile UBAX.

**Backend :** Spring Boot + Keycloak (realm `ubax-plateform`) · **Base URL :** `/api/v1/auth`

### SCRUM-282 · MOB-AUTH-01 — Login par numéro de téléphone

- **Assigné :** hdiop · **Statut :** À faire
- **Lien Jira :** https://ubax-team.atlassian.net/browse/SCRUM-282

Intégration de l'authentification mobile via numéro de téléphone. Route publique (WHITELIST), aucun token requis. Keycloak ROPC grant type côté backend.

**Endpoint**

| Méthode | URL | Auth | Rôle |
|---|---|---|---|
| POST | `/v1/auth/login/phone` | Public | Aucun |

**Request Body**

```json
{
  "phone": "+221771234567",
  "password": "MonMotDePasse@2026"
}
```

**Champs**

| Champ | Type | Obligatoire | Description |
|---|---|---|---|
| `phone` | String | ✅ | Numéro au format international E.164 (`+221XXXXXXXXX`) |
| `password` | String | ✅ | Mot de passe Keycloak |

**Réponse 200**

```json
{
  "status": "success",
  "statusCode": 200,
  "message": "Login successful",
  "data": {
    "access_token": "eyJhbGc...",
    "refresh_token": "eyJhbGc...",
    "token_type": "Bearer",
    "expires_in": 300,
    "refresh_expires_in": 1800
  }
}
```

**Codes d'erreur**

| Code | Cas |
|---|---|
| 401 | Numéro ou mot de passe incorrect |
| 404 | Compte introuvable avec ce numéro |

**Critères UX Mobile**

- Input téléphone : sélecteur de pays + préfixe (+221 Sénégal par défaut)
- Stocker `access_token` + `refresh_token` en stockage sécurisé (Keychain iOS / Keystore Android)
- Gérer l'expiration (`expires_in = 300s`) avec refresh automatique
- Message d'erreur localisé pour 401 : « Numéro ou mot de passe incorrect »

---

### SCRUM-283 · MOB-AUTH-02 — Inscription OTP

- **Assigné :** hdiop · **Statut :** À faire
- **Lien Jira :** https://ubax-team.atlassian.net/browse/SCRUM-283

Flux d'inscription en 3 étapes. Un OTP 6 chiffres est envoyé par SMS via LAfricaMobile (TTL 10 min). Toutes les routes sont publiques.

**Étape 1 — Envoyer l'OTP**

| Méthode | URL | Auth |
|---|---|---|
| POST | `/v1/auth/register/send-otp` | Public |

```json
// Request
{ "phone": "+221771234567" }

// Response 200
{
  "status": "success",
  "statusCode": 200,
  "message": "OTP sent successfully",
  "data": null
}
```

**Étape 2 — Vérifier l'OTP**

| Méthode | URL | Auth |
|---|---|---|
| POST | `/v1/auth/register/verify-otp` | Public |

```json
// Request
{ "phone": "+221771234567", "code": "847293" }

// Response 200
{
  "status": "success",
  "statusCode": 200,
  "message": "OTP verified successfully",
  "data": null
}
```

**Étape 3 — Finaliser l'inscription**

| Méthode | URL | Auth |
|---|---|---|
| POST | `/v1/auth/register/complete` | Public |

```json
// Request
{
  "firstName": "Moussa",
  "lastName": "Diallo",
  "email": "moussa@example.com",
  "phone": "+221771234567",
  "password": "MonMotDePasse@2026"
}

// Response 201
{
  "status": "success",
  "statusCode": 201,
  "message": "User registered successfully",
  "data": {
    "id": "uuid",
    "firstName": "Moussa",
    "lastName": "Diallo",
    "email": "moussa@example.com",
    "phone": "+221771234567",
    "role": "CLIENT"
  }
}
```

**Codes d'erreur**

| Code | Cas |
|---|---|
| 400 | OTP invalide ou expiré (TTL 10 min) |
| 409 | Numéro ou email déjà enregistré |

**Critères UX Mobile**

- Écran 1 : saisie du numéro → bouton « Envoyer le code »
- Écran 2 : 6 cases OTP séparées + minuteur décompte 10 min + « Renvoyer le code »
- Écran 3 : formulaire prénom / nom / email / mot de passe + confirmation
- Après succès étape 3 : login automatique + redirection accueil CLIENT

---

### SCRUM-284 · MOB-AUTH-03 — Mot de passe oublié OTP SMS

- **Assigné :** hdiop · **Statut :** À faire
- **Lien Jira :** https://ubax-team.atlassian.net/browse/SCRUM-284

Réinitialisation du mot de passe via OTP SMS. Complète SCRUM-25/26 (écrans UI) avec les specs API précises. OTP 6 chiffres, TTL 10 min, envoi LAfricaMobile.

**Étape 1 — Demander l'OTP**

```json
POST /v1/auth/forgot-password/send-otp
// Request
{ "phone": "+221771234567" }

// Response 200
{
  "status": "success",
  "statusCode": 200,
  "message": "OTP sent for password reset",
  "data": null
}
```

**Étape 2 — Vérifier l'OTP**

```json
POST /v1/auth/forgot-password/verify-otp
// Request
{ "phone": "+221771234567", "code": "394721" }

// Response 200
{
  "status": "success",
  "statusCode": 200,
  "message": "OTP verified",
  "data": { "resetToken": "temp-token-uuid" }
}
```

**Étape 3 — Définir le nouveau mot de passe**

```json
POST /v1/auth/forgot-password/reset
// Request
{
  "phone": "+221771234567",
  "code": "394721",
  "newPassword": "NouveauMdp@2026"
}

// Response 200
{
  "status": "success",
  "statusCode": 200,
  "message": "Password reset successfully",
  "data": null
}
```

**Codes d'erreur**

| Code | Cas |
|---|---|
| 400 | OTP expiré ou invalide |
| 404 | Aucun compte lié à ce numéro |

**Critères UX Mobile**

- Écran 1 : saisie numéro → « Recevoir un code »
- Écran 2 : saisie OTP 6 chiffres + décompte + « Renvoyer »
- Écran 3 : nouveau mot de passe + confirmation (afficher règles : min 8 caract., majuscule, chiffre, spécial)
- Après succès : redirection vers login avec message « Mot de passe modifié »

---

### SCRUM-285 · MOB-AUTH-04 — Mise à jour avatar

- **Assigné :** hdiop · **Statut :** À faire
- **Lien Jira :** https://ubax-team.atlassian.net/browse/SCRUM-285

Permet à l'utilisateur connecté (tous rôles) de mettre à jour sa photo de profil. Upload multipart vers le backend qui stocke dans MinIO bucket `users-avatars` et retourne l'URL publique.

**Endpoint**

| Méthode | URL | Auth | Content-Type |
|---|---|---|---|
| POST | `/v1/users/me/avatar` | Bearer JWT | `multipart/form-data` |

**Request**

| Champ form-data | Type | Description |
|---|---|---|
| `file` | Binary | Image JPG/PNG/WEBP, max 5 Mo |

**Réponse 200**

```json
{
  "status": "success",
  "statusCode": 200,
  "message": "Avatar updated successfully",
  "data": {
    "avatarUrl": "https://minio.ubax.sn/users-avatars/uuid.jpg"
  }
}
```

**Critères UX Mobile**

- Permettre sélection depuis galerie ET appareil photo
- Recadrage circulaire avant upload (crop 1:1)
- Indicateur de progression upload
- Mettre à jour l'avatar localement après succès sans recharger tout le profil

---

## SCRUM-280 · MOB-BAILLEUR — Module Bailleur Mobile

- **Statut :** À faire · **Type :** Tâche · **Priorité :** Medium · **Assigné :** hdiop
- **Lien Jira :** https://ubax-team.atlassian.net/browse/SCRUM-280

Module regroupant toutes les intégrations d'API pour le parcours bailleur (OWNER) sur l'application mobile : adhésion à une agence, gestion de ses biens, contrats, loyers et profil. Backend disponible — cf. CLAUDE.md modules `bailleur`, `property`, `contract`, `payment`.

### SCRUM-286 · MOB-BAILLEUR-01 — Demande d'adhésion à une agence

- **Assigné :** hdiop · **Statut :** À faire
- **Lien Jira :** https://ubax-team.atlassian.net/browse/SCRUM-286

Formulaire public permettant à un propriétaire de soumettre une demande d'adhésion à une agence UBAX, avec la liste de ses biens à confier. Aucun compte requis. Après approbation, l'admin crée un compte OWNER pour le bailleur.

**Endpoint**

| Méthode | URL | Auth |
|---|---|---|
| POST | `/v1/bailleur/apply` | Public (pas de JWT) |

**Request Body**

```json
{
  "fullName": "Seydou Diallo",
  "email": "seydou@example.com",
  "phone": "+221771234567",
  "idType": "CNI",
  "idNumber": "1 21 XXX XXX 001",
  "agencyId": "uuid-agence",
  "message": "Je souhaite confier mes biens à votre agence.",
  "properties": [
    {
      "address": "12 Rue Parcelles Assainies, Dakar",
      "type": "APPARTEMENT",
      "surface": 85,
      "desiredRent": 250000
    }
  ]
}
```

**Champs détaillés**

| Champ | Type | Obligatoire | Description |
|---|---|---|---|
| `fullName` | String | ✅ | Nom complet du bailleur |
| `email` | String | ✅ | Email de contact |
| `phone` | String | ✅ | Format E.164 (`+221XXXXXXXXX`) |
| `idType` | Enum | ✅ | `CNI` \| `PASSEPORT` \| `PERMIS_CONDUIRE` \| `TITRE_SEJOUR` \| `CARTE_CONSULAIRE` (`GET /v1/code-list/type/ID_TYPE`) |
| `idNumber` | String | ✅ | Numéro de la pièce d'identité |
| `agencyId` | UUID | ✅ | ID de l'agence cible (choisie depuis le catalogue) |
| `message` | String | ❌ | Message libre au directeur d'agence |
| `properties[]` | Array | ✅ | Liste des biens à confier (min 1) |
| `properties[].address` | String | ✅ | Adresse complète du bien |
| `properties[].type` | String | ✅ | Type de bien (APPARTEMENT, VILLA, STUDIO…) |
| `properties[].surface` | Integer | ❌ | Superficie en m² |
| `properties[].desiredRent` | Long | ❌ | Loyer souhaité en FCFA |

**Réponse 201**

```json
{
  "status": "success",
  "statusCode": 201,
  "message": "Bailleur application submitted successfully",
  "data": {
    "id": "uuid",
    "status": "PENDING",
    "createdAt": "2026-05-10T14:32:00"
  }
}
```

> ⚠️ « Voir ses abonnements » (liens bailleur↔agence) : aucun endpoint `GET /v1/bailleur/my-links` n'est encore exposé côté backend. À coordonner avec mba pour V042+.

**Critères UX Mobile**

- Formulaire multi-étapes : identité → pièce d'identité (photo scan optionnel) → sélection agence → liste biens
- Sélection agence : liste des agences UBAX approuvées (`GET /v1/properties` public ou future endpoint agences)
- Possibilité d'ajouter plusieurs biens (bouton + Ajouter un bien)
- Après soumission : écran de confirmation « Demande envoyée » avec statut `PENDING`

---

### SCRUM-287 · MOB-BAILLEUR-02 — Mes biens

- **Assigné :** hdiop · **Statut :** À faire
- **Lien Jira :** https://ubax-team.atlassian.net/browse/SCRUM-287

Une fois le compte OWNER créé par l'admin, le bailleur peut consulter ses biens publiés sur la plateforme. Endpoint paginé, JWT obligatoire (rôle `UBAX_OWNER`).

**Endpoints**

| Méthode | URL | Auth | Description |
|---|---|---|---|
| GET | `/v1/properties/mine` | OWNER JWT | Liste paginée de mes biens |
| GET | `/v1/properties/{id}` | Public | Détail d'un bien |
| GET | `/v1/properties/{id}/media` | Public | Photos du bien |

**Query Params — `/v1/properties/mine`**

| Paramètre | Type | Description |
|---|---|---|
| `page` | int (default 0) | Numéro de page |
| `size` | int (default 20) | Taille de page |
| `status` | String (optionnel) | `DRAFT` \| `PENDING` \| `ACTIVE` \| `REJECTED` \| `EXPIRED` |

**Réponse 200**

```json
{
  "status": "success",
  "statusCode": 200,
  "message": "Properties retrieved",
  "data": {
    "content": [
      {
        "id": "uuid",
        "title": "Appartement F3 Mermoz",
        "type": "APPARTEMENT",
        "status": "ACTIVE",
        "price": 350000,
        "city": "Dakar",
        "coverMediaUrl": "https://...",
        "createdAt": "2026-01-15T10:00:00"
      }
    ],
    "totalElements": 3,
    "totalPages": 1,
    "number": 0
  }
}
```

**Critères UX Mobile**

- Liste scrollable avec cards (photo couverture + titre + statut + loyer)
- Badge coloré par statut (`ACTIVE`=vert, `DRAFT`=gris, `PENDING`=orange, `EXPIRED`=rouge)
- Pull-to-refresh + pagination infinie
- Tap sur une card → écran détail du bien

---

### SCRUM-288 · MOB-BAILLEUR-03 — Mes contrats de bail

- **Assigné :** hdiop · **Statut :** À faire
- **Lien Jira :** https://ubax-team.atlassian.net/browse/SCRUM-288

Le bailleur (OWNER) consulte les contrats liés à ses biens. Endpoint paginé, filtrable par statut. JWT obligatoire.

**Endpoints**

| Méthode | URL | Auth | Description |
|---|---|---|---|
| GET | `/v1/contracts` | OWNER JWT | Liste paginée des contrats |
| GET | `/v1/contracts/{id}` | OWNER JWT | Détail d'un contrat |

**Query Params**

| Paramètre | Valeurs | Description |
|---|---|---|
| `status` | `DRAFT` \| `PENDING_SIGNATURE` \| `ACTIVE` \| `TERMINATED` \| `CANCELLED` | Filtrer par statut |
| `page` / `size` | int | Pagination |

**Réponse 200 — Champs clés**

```json
{
  "data": {
    "content": [{
      "id": "uuid",
      "status": "ACTIVE",
      "startDate": "2026-06-01",
      "durationMonths": 12,
      "monthlyRent": 250000,
      "tenantName": "Fatima Mbaye",
      "propertyAddress": "12 Rue Parcelles, Dakar",
      "contractPdfUrl": "https://minio.ubax.sn/..."
    }]
  }
}
```

**Critères UX Mobile**

- Onglets par statut (Actifs / En attente / Terminés)
- Card : nom locataire + adresse bien + loyer mensuel + durée restante
- Bouton « Voir le contrat PDF » → ouvrir URL présignée dans viewer intégré

---

### SCRUM-289 · MOB-BAILLEUR-04 — Mes loyers & paiements

- **Assigné :** hdiop · **Statut :** À faire
- **Lien Jira :** https://ubax-team.atlassian.net/browse/SCRUM-289

Le bailleur consulte l'historique des paiements/loyers liés à ses biens. Permet de suivre les loyers payés, en attente et en retard. JWT OWNER obligatoire.

**Endpoints**

| Méthode | URL | Description |
|---|---|---|
| GET | `/v1/payments` | Liste paginée (filtres `status`, `type`, `contractId`) |
| GET | `/v1/payments/late` | Loyers en retard uniquement |
| GET | `/v1/payments/{id}` | Détail + URL reçu PDF |

**Query Params — `/v1/payments`**

| Paramètre | Valeurs | Description |
|---|---|---|
| `status` | `PENDING` \| `PAID` \| `LATE` \| `CANCELLED` | Filtrer par statut |
| `type` | `LEASE` \| `DEPOSIT` \| `COMMISSION` | Type de paiement |
| `contractId` | UUID | Filtrer par contrat |

**Réponse 200 — Champs clés**

```json
{
  "data": {
    "content": [{
      "id": "uuid",
      "status": "PAID",
      "type": "LEASE",
      "amount": 250000,
      "paymentDate": "2026-05-08",
      "dueDate": "2026-05-01",
      "method": "WAVE",
      "contractId": "uuid",
      "receiptUrl": "https://minio.ubax.sn/..."
    }]
  }
}
```

**Critères UX Mobile**

- Vue tableau de bord avec total encaissé / en attente / en retard ce mois
- Onglets : Tous / En attente / Payés / En retard
- Badge rouge sur loyers en retard avec nombre de jours
- Bouton « Reçu PDF » sur les paiements `PAID`

---

### SCRUM-290 · MOB-BAILLEUR-05 — Profil bailleur & avatar

- **Assigné :** hdiop · **Statut :** À faire
- **Lien Jira :** https://ubax-team.atlassian.net/browse/SCRUM-290

Écran profil du bailleur (OWNER). Complète SCRUM-144 avec les specs API précises. Le profil est extrait du token JWT Keycloak + données User en DB.

**Endpoints**

| Méthode | URL | Description |
|---|---|---|
| POST | `/v1/users/me/avatar` | `multipart/form-data` — mettre à jour la photo |

**Données profil (depuis JWT + DB)**

| Donnée | Source | Description |
|---|---|---|
| `firstName` / `lastName` | JWT claims | `given_name` / `family_name` du token Keycloak |
| `email` | JWT claims | `email` du token |
| `phone` | DB users | Numéro enregistré en base |
| `avatarUrl` | DB users | URL MinIO bucket `users-avatars` |
| `role` | JWT `realm_access.roles` | `UBAX_OWNER` |

**Critères UX Mobile**

- Avatar circulaire avec bouton appareil photo en overlay
- Afficher : nom complet, email, téléphone, rôle (« Propriétaire »), date d'inscription
- Lien vers « Mes biens », « Mes contrats », « Mes loyers » depuis le profil
- Bouton déconnexion (`POST /v1/auth/logout` + clear secure storage)

---

### SCRUM-294 · MOB-BAILLEUR-06 — Mes abonnements agence

- **Assigné :** hdiop · **Statut :** À faire
- **Lien Jira :** https://ubax-team.atlassian.net/browse/SCRUM-294

> ⚠️ **Dépendance :** cette tâche est bloquée par **SCRUM-293 (BE-BAILL-01)**. Implémenter seulement après confirmation backend disponible par mba@ubax.io.

**Objectif** — Permettre au bailleur de voir ses demandes d'adhésion soumises aux agences et la liste de ses agences partenaires approuvées (écran « Mes abonnements »).

**Endpoint 1 — Mes demandes d'adhésion**

| Champ | Détail |
|---|---|
| Méthode + URL | `GET /v1/bailleur/my-applications` |
| Auth | Bearer JWT (rôle `OWNER`) |
| Query params | `page=0`, `size=10`, `status` (`PENDING` \| `APPROVED` \| `REJECTED` \| `CANCELLED`) |

```json
// Réponse 200
{
  "status": "SUCCESS",
  "statusCode": 200,
  "message": "BAILLEUR_MY_APPLICATIONS_SUCCESS",
  "data": {
    "content": [
      {
        "id": "uuid",
        "agencyName": "Immobilier Dakar",
        "status": "PENDING",
        "message": "Je souhaite confier mes biens",
        "propertiesCount": 2,
        "createdAt": "2025-05-01T10:30:00"
      }
    ],
    "totalElements": 3,
    "totalPages": 1,
    "page": 0,
    "size": 10
  }
}
```

**Endpoint 2 — Mes agences approuvées**

| Champ | Détail |
|---|---|
| Méthode + URL | `GET /v1/bailleur/my-agencies` |
| Auth | Bearer JWT (rôle `OWNER`) |

```json
// Réponse 200
{
  "data": [
    {
      "agencyId": "uuid",
      "agencyName": "Immobilier Dakar",
      "agencyLogo": "https://minio.ubax.sn/agencies-logos/uuid.jpg",
      "agencyPhone": "+221771234567",
      "agencyEmail": "contact@immo-dakar.sn",
      "linkedAt": "2025-04-15T09:00:00"
    }
  ]
}
```

**Critères d'acceptation mobile**

- Écran « Mes abonnements » accessible depuis le profil bailleur
- Onglet 1 : liste des demandes avec badge statut coloré (`PENDING`=orange, `APPROVED`=vert, `REJECTED`=rouge)
- Onglet 2 : liste des agences approuvées avec logo, nom, téléphone
- État vide affiché si aucune demande soumise
- Gestion erreur 403 si token non-OWNER

**Codes d'erreur**

| Code | Cas |
|---|---|
| 401 | JWT absent ou expiré |
| 403 | Utilisateur n'a pas le rôle `OWNER` |
| 200 vide | Aucune donnée — liste vide, pas de 404 |

---

## SCRUM-281 · MOB-CLIENT — Catalogue & Recherche de biens

- **Statut :** À faire · **Type :** Tâche · **Priorité :** Medium · **Assigné :** hdiop
- **Lien Jira :** https://ubax-team.atlassian.net/browse/SCRUM-281

Module complémentaire aux tâches existantes (SCRUM-231–234). Couvre l'exploration publique des biens immobiliers et espaces hôteliers depuis l'application mobile (aucun token requis).

### SCRUM-291 · MOB-CLIENT-01 — Catalogue des biens public

- **Assigné :** hdiop · **Statut :** À faire
- **Lien Jira :** https://ubax-team.atlassian.net/browse/SCRUM-291

Page d'exploration des biens immobiliers disponibles, accessible sans authentification. Complète SCRUM-99 (détail) avec la liste et la recherche. Endpoint public, aucun JWT requis.

**Endpoint**

| Méthode | URL | Auth |
|---|---|---|
| GET | `/v1/properties` | Public (WHITELIST) |

**Query Params (filtres)**

| Paramètre | Type | Description | Exemple |
|---|---|---|---|
| `type` | String | Type de bien | `APPARTEMENT`, `VILLA`, `STUDIO` |
| `city` | String | Ville | `Dakar`, `Thiès` |
| `minPrice` | Long | Loyer minimum (FCFA) | `100000` |
| `maxPrice` | Long | Loyer maximum (FCFA) | `500000` |
| `bedrooms` | Integer | Nombre de chambres | `2` |
| `boosted` | Boolean | Biens mis en avant uniquement | `true` |
| `page` / `size` | int | Pagination | `page=0&size=20` |

**Réponse 200**

```json
{
  "data": {
    "content": [{
      "id": "uuid",
      "title": "Villa 4 chambres Almadies",
      "type": "VILLA",
      "city": "Dakar",
      "price": 650000,
      "bedrooms": 4,
      "surface": 180,
      "coverMediaUrl": "https://cdn.ubax.sn/...",
      "boosted": true,
      "agencyName": "Agence Immo Elite"
    }],
    "totalElements": 124,
    "totalPages": 7,
    "number": 0
  }
}
```

**Critères UX Mobile**

- Vue liste (cards) ET vue carte (MapView) switchable
- Filtres accessibles via bottom sheet : type, ville, fourchette de prix (slider), nb chambres
- Biens boostés : badge « En vedette » + position prioritaire
- Pagination infinie (lazy load) au scroll
- Tap sur une card → SCRUM-99 (écran détail bien)
