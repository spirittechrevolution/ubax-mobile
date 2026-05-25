import 'api_exception.dart';

/// Traduit n'importe quelle erreur en message lisible pour l'utilisateur.
/// Toujours utiliser [AppErrors.translate] au lieu d'afficher [ApiException.message]
/// directement dans l'UI.
abstract final class AppErrors {
  static String translate(dynamic e) {
    if (e is ApiException) return _fromApi(e);
    return 'Une erreur inattendue est survenue. Réessayez.';
  }

  static String _fromApi(ApiException e) {
    // ── Erreurs réseau (pas de réponse serveur) ──────────────────────────────
    if (e.isNetwork) return e.message; // déjà lisible (timeout, connexion…)

    final msg = e.message.toLowerCase();

    // ── Correspondances sur le contenu du message ────────────────────────────

    // Auth — identifiants
    if (_any(msg, ['bad credentials', 'invalid credentials', 'wrong password',
        'incorrect password', 'invalid password'])) {
      return 'Numéro de téléphone ou mot de passe incorrect.';
    }
    if (_any(msg, ['user not found', 'account not found', 'no account',
        'phone not found', 'not registered'])) {
      return 'Aucun compte associé à ce numéro de téléphone.';
    }
    if (_any(msg, ['already exists', 'already registered', 'already used',
        'phone already', 'email already', 'duplicate'])) {
      return 'Ce numéro ou cet email est déjà associé à un compte.';
    }
    if (_any(msg, ['account disabled', 'account inactive', 'account suspended',
        'user disabled', 'user inactive', 'user suspended', 'blocked'])) {
      return 'Votre compte est suspendu ou inactif. Contactez le support.';
    }
    if (_any(msg, ['email not verified', 'phone not verified',
        'not verified'])) {
      return 'Votre compte n\'est pas encore vérifié.';
    }

    // Auth — OTP / code
    if (_any(msg, ['otp'])) {
      if (_any(msg, ['invalid', 'wrong', 'incorrect', 'not found', 'not match'])) {
        return 'Code incorrect. Vérifiez et réessayez.';
      }
      if (_any(msg, ['expired', 'expiré'])) {
        return 'Code expiré. Demandez un nouveau code.';
      }
      return 'Code invalide ou expiré. Demandez un nouveau code.';
    }
    if (_any(msg, ['expired', 'expiré'])) {
      return 'Code ou session expiré. Veuillez recommencer.';
    }

    // Mot de passe
    if (_any(msg, ['password too short', 'password too weak',
        'password strength', 'weak password'])) {
      return 'Le mot de passe est trop faible. Utilisez au moins 8 caractères.';
    }
    if (_any(msg, ['passwords do not match', 'password mismatch'])) {
      return 'Les mots de passe ne correspondent pas.';
    }

    // Réservation
    if (_any(msg, ['propertyid', 'property id', 'property not found',
        'bien introuvable'])) {
      return 'Bien introuvable ou non disponible à la réservation.';
    }
    if (_any(msg, ['checkindate', 'checkoutdate', 'date invalide',
        'date in the past', 'past date', 'future date'])) {
      return 'Les dates sélectionnées sont invalides. Choisissez des dates futures.';
    }
    if (_any(msg, ['overlap', 'already booked', 'not available',
        'non disponible', 'chevauchement'])) {
      return 'Ce bien n\'est pas disponible pour ces dates. Essayez d\'autres dates.';
    }
    if (_any(msg, ['guestcount', 'guest count', 'nombre d\'invités'])) {
      return 'Le nombre de personnes doit être d\'au moins 1.';
    }

    // Bailleur / demande
    if (_any(msg, ['already applied', 'already submitted', 'application exists',
        'demande existe', 'already a bailleur'])) {
      return 'Vous avez déjà soumis une demande pour cette agence.';
    }
    if (_any(msg, ['agency not found', 'agence introuvable'])) {
      return 'Agence introuvable. Elle a peut-être été supprimée.';
    }

    // Documents / upload
    if (_any(msg, ['upload', 'file', 'storage', 'presign', 'bucket',
        'document upload'])) {
      return 'Erreur lors de l\'envoi du document. Vérifiez le fichier et réessayez.';
    }

    // Favoris
    if (e.isConflict && _any(msg, ['favorite', 'favori', 'already'])) {
      return 'Ce bien est déjà dans vos favoris.';
    }

    // Droits / accès
    if (_any(msg, ['forbidden', 'access denied', 'not allowed',
        'permission denied', 'unauthorized access'])) {
      return 'Vous n\'avez pas les droits pour effectuer cette action.';
    }

    // Limite de requêtes
    if (_any(msg, ['too many', 'rate limit', 'throttle', 'quota'])) {
      return 'Trop de tentatives. Attendez quelques minutes avant de réessayer.';
    }

    // Validation
    if (_any(msg, ['validation', 'invalid field', 'required field',
        'missing field', 'constraint'])) {
      return 'Certaines informations sont incorrectes. Vérifiez le formulaire.';
    }

    // ── Fallback sur le code HTTP ────────────────────────────────────────────
    return switch (e.statusCode) {
      400 => 'Informations incorrectes. Vérifiez les champs et réessayez.',
      401 => 'Session expirée. Veuillez vous reconnecter.',
      403 => 'Action non autorisée.',
      404 => 'Ressource introuvable.',
      409 => 'Action déjà effectuée ou information en doublon.',
      422 => 'Données invalides. Vérifiez le formulaire.',
      429 => 'Trop de tentatives. Attendez quelques minutes.',
      500 => 'Problème serveur. Réessayez dans quelques instants.',
      502 || 503 || 504 => 'Service temporairement indisponible. Réessayez plus tard.',
      _ => 'Une erreur est survenue (code ${e.statusCode}). Réessayez.',
    };
  }

  static bool _any(String msg, List<String> patterns) =>
      patterns.any((p) => msg.contains(p));
}
