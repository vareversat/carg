class CustomException implements Exception {
  late String message;
  late String code;

  CustomException(String rawMessage) {
    if (rawMessage.contains('PERMISSION_DENIED')) {
      code = 'PERMISSION_DENIED';
      message = "Erreur : Vous n'êtes pas authentifiez";
    } else if (rawMessage == 'wrong-password') {
      code = 'ERROR_WRONG_PASSWORD';
      message = 'Erreur : Mot de passe incorrect';
    } else if (rawMessage == 'user-not-found') {
      code = 'ERROR_USER_NOT_FOUND';
      message = 'Erreur : Cet utilisateur n\'existe pas';
    } else if (rawMessage == 'user-disabled') {
      code = 'ERROR_USER_DISABLED';
      message = 'Erreur : Cet utilisateur est désactivé';
    } else if (rawMessage == 'too-many-requests') {
      code = 'ERROR_TOO_MANY_REQUESTS';
      message = 'Erreur : Trop d\'essais de connexion infructeux';
    } else if (rawMessage.contains('ERROR_EMAIL_NOT_VALIDATED')) {
      code = 'ERROR_EMAIL_NOT_VALIDATED';
      message = 'Erreur : L\'email n\'est pas encore été validé';
    } else if (rawMessage == 'email-already-in-use') {
      code = 'ERROR_EMAIL_ALREADY_IN_USE';
      message = 'Erreur : Cette adresse email est déjà utilisée';
    } else if (rawMessage == 'invalid-email') {
      code = 'ERROR_INVALID_EMAIL';
      message = 'Erreur : L\'email est invalide';
    } else if (rawMessage == 'invalid-phone-number') {
      code = 'ERROR_INVALID_PHONE_NUMBER';
      message = 'Erreur : Le numéro de téléphone est invalide';
    } else if (rawMessage == 'credential-already-in-use') {
      code = 'ERROR_USED_CREDENTIAL';
      message = 'Erreur : Le justificatif d\'identité est déjà utilisé';
    } else if (rawMessage == 'weak-password') {
      code = 'ERROR_WEAK_PASSWORD';
      message = 'Erreur : Le mot de passe doit au moins contenir 6 charactères';
    } else if (rawMessage == 'invalid-action-code') {
      code = 'ERROR_INVALID_ACTION_CODE';
      message = 'Erreur : Le lien est erroné ou a déjà été utilisé';
    } else if (rawMessage == 'invalid-verification-code') {
      code = 'ERROR_INVALID_VERIFICATION_CODE';
      message = 'Erreur : Le code de vérification est invalide';
    } else if (rawMessage == 'sign_in_failed') {
      code = 'ERROR_SIGN_IN_FAILED';
      message = 'Erreur : Impossible de se connecter via cette méthode';
    } else if (rawMessage == 'requires-recent-login') {
      code = 'ERROR_REQUIRES_RECENT_LOGIN';
      message =
          'Erreur : Veuillez vous déconnecter et vous reconnecter à l\'application avant de procéder au changement d\'adresse mail';
    } else {
      code = 'UNKWNOW';
      message = rawMessage;
    }
  }

  @override
  String toString() {
    return message;
  }
}
