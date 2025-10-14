// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get quickStartTitle => 'Démarrage rapide';

  @override
  String get repsLabel => 'RÉPÉTITIONS';

  @override
  String get workLabel => 'TRAVAIL';

  @override
  String get restLabel => 'REPOS';

  @override
  String get saveButton => 'SAUVEGARDER';

  @override
  String get startButton => 'COMMENCER';

  @override
  String get presetsTitle => 'VOS PRÉRÉGLAGES';

  @override
  String get addButton => '+ AJOUTER';

  @override
  String get volumeButtonLabel => 'Régler le volume';

  @override
  String get volumeSliderLabel => 'Curseur de volume';

  @override
  String get moreOptionsLabel => 'Plus d\'options';

  @override
  String get collapseQuickStartLabel => 'Replier la section Démarrage rapide';

  @override
  String get decreaseRepsLabel => 'Diminuer les répétitions';

  @override
  String get increaseRepsLabel => 'Augmenter les répétitions';

  @override
  String get decreaseWorkLabel => 'Diminuer le temps de travail';

  @override
  String get increaseWorkLabel => 'Augmenter le temps de travail';

  @override
  String get decreaseRestLabel => 'Diminuer le temps de repos';

  @override
  String get increaseRestLabel => 'Augmenter le temps de repos';

  @override
  String get savePresetLabel => 'Sauvegarder le préréglage rapide';

  @override
  String get startIntervalLabel => 'Démarrer l\'intervalle';

  @override
  String get editPresetsLabel => 'Éditer les préréglages';

  @override
  String get addPresetLabel => 'Ajouter un préréglage';

  @override
  String selectPresetLabel(String name) {
    return 'Sélectionner préréglage $name';
  }

  @override
  String get emptyPresetsMessage =>
      'Aucun préréglage sauvegardé.\\nAppuyez sur + AJOUTER pour créer.';

  @override
  String get presetSavedSnackbar => 'Préréglage sauvegardé';

  @override
  String get saveFailed => 'Échec de la sauvegarde. Réessayez.';

  @override
  String get repsValidationError =>
      'Les répétitions doivent être entre 1 et 99';

  @override
  String get workTimeValidationError =>
      'Le temps de travail doit être entre 00:05 et 60:00';

  @override
  String get restTimeValidationError =>
      'Le temps de repos doit être entre 00:00 et 60:00';

  @override
  String get presetNameEmptyError =>
      'Le nom du préréglage ne peut pas être vide';

  @override
  String get maxRepsError => 'Maximum 99 répétitions';

  @override
  String get minWorkTimeError => 'Minimum 5 secondes de travail';

  @override
  String get loadPresetsError => 'Impossible de charger les préréglages';
}
