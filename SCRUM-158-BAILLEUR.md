# SCRUM-158 — BAILLEUR

> Module d'adhésion bailleur : cycle de vie complet d'une demande, du formulaire public jusqu'à la décision de l'agence.

- **Statut :** À faire
- **Type :** Tâche
- **Priorité :** Medium
- **Assigné :** hdiop
- **Lien Jira :** https://ubax-team.atlassian.net/browse/SCRUM-158

---

## Objectif

Un bailleur est un propriétaire immobilier qui souhaite confier la gestion de ses biens à une agence partenaire UBAX. Ce module couvre l'intégralité du cycle de vie d'une demande d'adhésion bailleur, du formulaire public jusqu'à la décision de l'agence.

### Flux principal

1. Le bailleur remplit un formulaire public (sans compte) en indiquant ses informations personnelles, sa pièce d'identité et la liste des biens qu'il souhaite mettre en gestion.
2. La demande est reçue par l'agence ciblée avec le statut `PENDING`.
3. Le Directeur d'agence (`DIRECTEUR_AGENCE`) consulte la demande, vérifie les biens soumis (avec alerte si conflit géographique détecté automatiquement par le backend), puis approuve ou rejette.
4. En cas d'approbation, le backend crée automatiquement un compte UBAX avec le rôle `OWNER` pour le bailleur — aucune action frontend supplémentaire requise.
5. L'équipe admin UBAX dispose d'une vue globale en lecture seule sur toutes les demandes de toutes les agences.

### Périmètre frontend du module

| Sous-tâche | Acteur | Accès |
|---|---|---|
| [UBAX-FE-301](#scrum-159--ubax-fe-301--formulaire-de-demande-dadhésion-bailleur-public) — Formulaire de demande | Bailleur (grand public) | Page publique |
| [UBAX-FE-302](#scrum-160--ubax-fe-302--liste-des-demandes-bailleur-reçues-agence) — Liste des demandes reçues | Directeur d'agence | Espace partenaire |
| [UBAX-FE-303](#scrum-161--ubax-fe-303--détail-dune-demande-bailleur-agence) — Détail d'une demande | Directeur d'agence | Espace partenaire |
| [UBAX-FE-304](#scrum-162--ubax-fe-304--décision-sur-une-demande-bailleur-agence) — Décision (approuver / rejeter) | Directeur d'agence | Espace partenaire |
| [UBAX-FE-305](#scrum-163--ubax-fe-305--vue-globale-des-demandes-bailleur-admin) — Vue globale toutes agences | Admin / Super Admin | Back-office UBAX |

### Points d'attention

- Le champ `conflictDetected` indique qu'un autre bien à moins de 50 m a déjà été enregistré — afficher une alerte visible mais non bloquante pour le Directeur.
- Le formulaire public doit connaître l'`agencyId` cible (passé en paramètre d'URL ou sélectionné depuis une liste d'agences).
- Un bailleur peut soumettre plusieurs biens dans une même demande (liste dynamique).
- La décision `REJECT` doit obligatoirement inclure un `comment` expliquant le motif.

### Récapitulatif des sous-tâches

| Clé | Résumé | Statut | Assigné |
|---|---|---|---|
| SCRUM-159 | UBAX-FE-301 · Formulaire de demande d'adhésion bailleur (Public) | À faire | rmeissa |
| SCRUM-160 | UBAX-FE-302 · Liste des demandes bailleur reçues (Agence) | À faire | rmeissa |
| SCRUM-161 | UBAX-FE-303 · Détail d'une demande bailleur (Agence) | À faire | rmeissa |
| SCRUM-162 | UBAX-FE-304 · Décision sur une demande bailleur (Agence) | À faire | rmeissa |
| SCRUM-163 | UBAX-FE-305 · Vue globale des demandes bailleur (Admin) | À faire | rmeissa |

---

## SCRUM-159 — UBAX-FE-301 · Formulaire de demande d'adhésion bailleur (Public)

- **Statut :** À faire · **Priorité :** Medium · **Assigné :** rmeissa
- **Lien Jira :** https://ubax-team.atlassian.net/browse/SCRUM-159

### API

| Champ | Valeur |
|---|---|
| Endpoint | `POST /v1/bailleur/apply` |
| Auth | Aucune (public) |
| Content-Type | `application/json` |

### Request body

```json
{
  "agencyId": "uuid (requis)",
  "firstName": "string (max 100, requis)",
  "lastName": "string (max 100, requis)",
  "phone": "string (format +XXX, requis)",
  "email": "string (email valide, requis)",
  "idType": "CNI",
  "idNumber": "string (max 100, requis)",
  "properties": [
    {
      "address": "string (requis)",
      "propertyType": "string (requis)",
      "rooms": 3,
      "surface": 75.5,
      "desiredRent": 150000,
      "description": "string (optionnel)",
      "latitude": 3.8667,
      "longitude": 11.5167
    }
  ]
}
```

> Valeurs `idType` : `CNI` · `PASSEPORT` · `PERMIS_CONDUIRE` · `TITRE_SEJOUR` · `CARTE_CONSULAIRE`

### Response 201

```json
{
  "status": "SUCCESS",
  "statusCode": 201,
  "message": "Application submitted successfully",
  "data": {
    "id": "uuid",
    "agencyId": "uuid",
    "agencyName": "string",
    "firstName": "string",
    "lastName": "string",
    "phone": "string",
    "email": "string",
    "idType": "CNI",
    "idNumber": "string",
    "status": "PENDING",
    "conflictDetected": false,
    "conflictNote": null,
    "rejectionReason": null,
    "reviewedByName": null,
    "reviewedAt": null,
    "properties": [
      {
        "id": "uuid",
        "address": "string",
        "propertyType": "string",
        "rooms": 3,
        "surface": 75.5,
        "desiredRent": 150000,
        "description": "string",
        "latitude": 3.8667,
        "longitude": 11.5167,
        "geoVerified": false
      }
    ],
    "createdAt": "2026-04-30T10:00:00",
    "updatedAt": "2026-04-30T10:00:00"
  }
}
```

### Critères d'acceptation

- Page publique accessible sans connexion
- **Étape 1 :** identité bailleur (nom, prénom, email, téléphone, type pièce, numéro pièce)
- **Étape 2 :** sélection de l'agence (`agencyId` — à récupérer depuis une liste ou passé en param URL)
- **Étape 3 :** ajout de biens (formulaire dynamique, au moins 1 bien requis)
  - Champs : adresse, type de bien, nbre pièces, surface, loyer souhaité, description, latitude/longitude (carte optionnelle)
- Validation complète avant soumission
- Page de confirmation après soumission réussie (`status: PENDING`)
- Gestion d'erreur si `agencyId` invalide

---

## SCRUM-160 — UBAX-FE-302 · Liste des demandes bailleur reçues (Agence)

- **Statut :** À faire · **Priorité :** Medium · **Assigné :** rmeissa
- **Lien Jira :** https://ubax-team.atlassian.net/browse/SCRUM-160

### API

| Champ | Valeur |
|---|---|
| Endpoint | `GET /v1/bailleur/agency/applications` |
| Auth | Bearer token · Rôle `UBAX_PARTNER` + sous-rôle `DIRECTEUR_AGENCE` |
| Query params | `page` (défaut 0) · `size` (défaut 20) · `sort=createdAt,desc` |

### Response 200

```json
{
  "status": "SUCCESS",
  "statusCode": 200,
  "message": "Applications retrieved",
  "data": {
    "content": [
      {
        "id": "uuid",
        "agencyId": "uuid",
        "agencyName": "string",
        "firstName": "string",
        "lastName": "string",
        "phone": "string",
        "email": "string",
        "idType": "CNI",
        "idNumber": "string",
        "status": "PENDING",
        "conflictDetected": false,
        "conflictNote": null,
        "rejectionReason": null,
        "reviewedByName": null,
        "reviewedAt": null,
        "properties": [ { "...": "voir UBAX-FE-301" } ],
        "createdAt": "2026-04-30T10:00:00",
        "updatedAt": "2026-04-30T10:00:00"
      }
    ],
    "totalElements": 42,
    "totalPages": 3,
    "size": 20,
    "number": 0
  }
}
```

> Valeurs `status` : `PENDING` · `APPROVED` · `REJECTED` · `CANCELLED`

### Critères d'acceptation

- Tableau paginé avec colonnes : nom complet, email, téléphone, statut (badge coloré), date, actions
- Badge `conflictDetected` visible si `true` (alerte visuelle)
- Filtre par statut
- Pagination avec navigation page suivante/précédente
- Lien vers le détail (UBAX-FE-303)

---

## SCRUM-161 — UBAX-FE-303 · Détail d'une demande bailleur (Agence)

- **Statut :** À faire · **Priorité :** Medium · **Assigné :** rmeissa
- **Lien Jira :** https://ubax-team.atlassian.net/browse/SCRUM-161

### API

| Champ | Valeur |
|---|---|
| Endpoint | `GET /v1/bailleur/agency/applications/{id}` |
| Auth | Bearer token · Rôle `UBAX_PARTNER` + sous-rôle `DIRECTEUR_AGENCE` |
| Path params | `id` : UUID de la demande |

**Response 200** : objet `BailleurApplicationResponse` complet — voir UBAX-FE-302.

### Critères d'acceptation

- Page de détail avec toutes les informations du bailleur
- Section « Biens soumis » avec liste des propriétés et coordonnées GPS
- Si `conflictDetected = true` : afficher `conflictNote` dans un bandeau d'alerte
- Si `status = PENDING` : afficher les boutons **Approuver / Rejeter** (UBAX-FE-304)
- Si déjà traité : afficher `reviewedByName`, `reviewedAt`, `rejectionReason`

---

## SCRUM-162 — UBAX-FE-304 · Décision sur une demande bailleur (Agence)

- **Statut :** À faire · **Priorité :** Medium · **Assigné :** rmeissa
- **Lien Jira :** https://ubax-team.atlassian.net/browse/SCRUM-162

### API

| Champ | Valeur |
|---|---|
| Endpoint | `PATCH /v1/bailleur/agency/applications/{id}/decision` |
| Auth | Bearer token · Rôle `UBAX_PARTNER` + sous-rôle `DIRECTEUR_AGENCE` |
| Path params | `id` : UUID de la demande |
| Content-Type | `application/json` |

### Request body

```json
{
  "decision": "APPROVE",
  "comment": "string (optionnel)"
}
```

> Valeurs `decision` : `APPROVE` · `REJECT`

### Response 200

```json
{
  "status": "SUCCESS",
  "statusCode": 200,
  "message": "Decision processed successfully",
  "data": {
    "id": "uuid",
    "status": "APPROVED",
    "reviewedByName": "Jean Dupont",
    "reviewedAt": "2026-04-30T10:00:00",
    "rejectionReason": null,
    "...": "autres champs BailleurApplicationResponse"
  }
}
```

### Erreurs possibles

- `400 Bad Request` — demande déjà traitée (non `PENDING`)
- `404 Not Found` — demande introuvable

### Critères d'acceptation

- Bouton **Approuver** (vert) → appel avec `decision: APPROVE`
- Bouton **Rejeter** (rouge) → ouvre modal avec champ `comment` obligatoire pour `REJECT`
- Si `APPROVE` : création automatique d'un compte `OWNER` (géré côté backend)
- Confirmation avant action
- Mise à jour du statut affiché après succès
- Désactiver les boutons si `status !== PENDING`

---

## SCRUM-163 — UBAX-FE-305 · Vue globale des demandes bailleur (Admin)

- **Statut :** À faire · **Priorité :** Medium · **Assigné :** rmeissa
- **Lien Jira :** https://ubax-team.atlassian.net/browse/SCRUM-163

### API

| Champ | Valeur |
|---|---|
| Endpoint | `GET /v1/bailleur/admin/applications` |
| Auth | Bearer token · Rôle `UBAX_ADMIN` ou `UBAX_SUPER_ADMIN` |
| Query params | `page` · `size` · `sort=createdAt,desc` |

**Response 200** : identique à UBAX-FE-302 — `Page<BailleurApplicationResponse>`.

### Critères d'acceptation

- Tableau identique à UBAX-FE-302 mais avec toutes les agences visibles
- Colonne `agencyName` visible
- Filtres par agence et par statut
- Accès en lecture seule (pas de bouton Décision ici)
