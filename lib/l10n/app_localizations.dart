import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_fr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('fr')
  ];

  /// Quick start section title
  ///
  /// In fr, this message translates to:
  /// **'Démarrage rapide'**
  String get quickStartTitle;

  /// Repetitions label
  ///
  /// In fr, this message translates to:
  /// **'RÉPÉTITIONS'**
  String get repsLabel;

  /// Work time label
  ///
  /// In fr, this message translates to:
  /// **'TRAVAIL'**
  String get workLabel;

  /// Rest time label
  ///
  /// In fr, this message translates to:
  /// **'REPOS'**
  String get restLabel;

  /// Save preset button
  ///
  /// In fr, this message translates to:
  /// **'SAUVEGARDER'**
  String get saveButton;

  /// Start interval button
  ///
  /// In fr, this message translates to:
  /// **'COMMENCER'**
  String get startButton;

  /// Presets section title
  ///
  /// In fr, this message translates to:
  /// **'VOS PRÉRÉGLAGES'**
  String get presetsTitle;

  /// Add preset button
  ///
  /// In fr, this message translates to:
  /// **'+ AJOUTER'**
  String get addButton;

  /// Volume button accessibility label
  ///
  /// In fr, this message translates to:
  /// **'Régler le volume'**
  String get volumeButtonLabel;

  /// Volume slider accessibility label
  ///
  /// In fr, this message translates to:
  /// **'Curseur de volume'**
  String get volumeSliderLabel;

  /// More options button accessibility label
  ///
  /// In fr, this message translates to:
  /// **'Plus d\'options'**
  String get moreOptionsLabel;

  /// Collapse quick start accessibility label
  ///
  /// In fr, this message translates to:
  /// **'Replier la section Démarrage rapide'**
  String get collapseQuickStartLabel;

  /// Decrease reps accessibility label
  ///
  /// In fr, this message translates to:
  /// **'Diminuer les répétitions'**
  String get decreaseRepsLabel;

  /// Increase reps accessibility label
  ///
  /// In fr, this message translates to:
  /// **'Augmenter les répétitions'**
  String get increaseRepsLabel;

  /// Decrease work time accessibility label
  ///
  /// In fr, this message translates to:
  /// **'Diminuer le temps de travail'**
  String get decreaseWorkLabel;

  /// Increase work time accessibility label
  ///
  /// In fr, this message translates to:
  /// **'Augmenter le temps de travail'**
  String get increaseWorkLabel;

  /// Decrease rest time accessibility label
  ///
  /// In fr, this message translates to:
  /// **'Diminuer le temps de repos'**
  String get decreaseRestLabel;

  /// Increase rest time accessibility label
  ///
  /// In fr, this message translates to:
  /// **'Augmenter le temps de repos'**
  String get increaseRestLabel;

  /// Save preset accessibility label
  ///
  /// In fr, this message translates to:
  /// **'Sauvegarder le préréglage rapide'**
  String get savePresetLabel;

  /// Start interval accessibility label
  ///
  /// In fr, this message translates to:
  /// **'Démarrer l\'intervalle'**
  String get startIntervalLabel;

  /// Edit presets accessibility label
  ///
  /// In fr, this message translates to:
  /// **'Éditer les préréglages'**
  String get editPresetsLabel;

  /// Add preset accessibility label
  ///
  /// In fr, this message translates to:
  /// **'Ajouter un préréglage'**
  String get addPresetLabel;

  /// Select preset accessibility label
  ///
  /// In fr, this message translates to:
  /// **'Sélectionner préréglage {name}'**
  String selectPresetLabel(String name);

  /// Empty state message
  ///
  /// In fr, this message translates to:
  /// **'Aucun préréglage sauvegardé.\\nAppuyez sur + AJOUTER pour créer.'**
  String get emptyPresetsMessage;

  /// Success message
  ///
  /// In fr, this message translates to:
  /// **'Préréglage sauvegardé'**
  String get presetSavedSnackbar;

  /// Error message
  ///
  /// In fr, this message translates to:
  /// **'Échec de la sauvegarde. Réessayez.'**
  String get saveFailed;

  /// Validation error
  ///
  /// In fr, this message translates to:
  /// **'Les répétitions doivent être entre 1 et 99'**
  String get repsValidationError;

  /// Validation error
  ///
  /// In fr, this message translates to:
  /// **'Le temps de travail doit être entre 00:05 et 60:00'**
  String get workTimeValidationError;

  /// Validation error
  ///
  /// In fr, this message translates to:
  /// **'Le temps de repos doit être entre 00:00 et 60:00'**
  String get restTimeValidationError;

  /// Validation error
  ///
  /// In fr, this message translates to:
  /// **'Le nom du préréglage ne peut pas être vide'**
  String get presetNameEmptyError;

  /// Boundary error
  ///
  /// In fr, this message translates to:
  /// **'Maximum 99 répétitions'**
  String get maxRepsError;

  /// Boundary error
  ///
  /// In fr, this message translates to:
  /// **'Minimum 5 secondes de travail'**
  String get minWorkTimeError;

  /// Error message
  ///
  /// In fr, this message translates to:
  /// **'Impossible de charger les préréglages'**
  String get loadPresetsError;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en', 'fr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en': return AppLocalizationsEn();
    case 'fr': return AppLocalizationsFr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
