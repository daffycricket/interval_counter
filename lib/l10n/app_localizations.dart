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
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

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
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('fr'),
  ];

  /// Quick start section title
  ///
  /// In en, this message translates to:
  /// **'Quick Start'**
  String get quickStartTitle;

  /// Repetitions label
  ///
  /// In en, this message translates to:
  /// **'REPS'**
  String get repsLabel;

  /// Work time label
  ///
  /// In en, this message translates to:
  /// **'WORK'**
  String get workLabel;

  /// Rest time label
  ///
  /// In en, this message translates to:
  /// **'REST'**
  String get restLabel;

  /// Save button text
  ///
  /// In en, this message translates to:
  /// **'SAVE'**
  String get saveButton;

  /// Start button text
  ///
  /// In en, this message translates to:
  /// **'START'**
  String get startButton;

  /// Presets section title
  ///
  /// In en, this message translates to:
  /// **'YOUR PRESETS'**
  String get presetsTitle;

  /// Add button text
  ///
  /// In en, this message translates to:
  /// **'ADD'**
  String get addButton;

  /// Empty state message
  ///
  /// In en, this message translates to:
  /// **'No presets'**
  String get noPresetsMessage;

  /// Validation error for empty preset name
  ///
  /// In en, this message translates to:
  /// **'Please enter a name'**
  String get presetNameError;

  /// Volume button semantic label
  ///
  /// In en, this message translates to:
  /// **'Adjust volume'**
  String get volumeButtonLabel;

  /// Volume slider semantic label
  ///
  /// In en, this message translates to:
  /// **'Volume slider'**
  String get volumeSliderLabel;

  /// Menu button semantic label
  ///
  /// In en, this message translates to:
  /// **'More options'**
  String get menuButtonLabel;

  /// Collapse button semantic label
  ///
  /// In en, this message translates to:
  /// **'Collapse quick start section'**
  String get collapseQuickStartLabel;

  /// Decrease reps button semantic label
  ///
  /// In en, this message translates to:
  /// **'Decrease repetitions'**
  String get decreaseRepsLabel;

  /// Increase reps button semantic label
  ///
  /// In en, this message translates to:
  /// **'Increase repetitions'**
  String get increaseRepsLabel;

  /// Decrease work button semantic label
  ///
  /// In en, this message translates to:
  /// **'Decrease work time'**
  String get decreaseWorkLabel;

  /// Increase work button semantic label
  ///
  /// In en, this message translates to:
  /// **'Increase work time'**
  String get increaseWorkLabel;

  /// Decrease rest button semantic label
  ///
  /// In en, this message translates to:
  /// **'Decrease rest time'**
  String get decreaseRestLabel;

  /// Increase rest button semantic label
  ///
  /// In en, this message translates to:
  /// **'Increase rest time'**
  String get increaseRestLabel;

  /// Save preset button semantic label
  ///
  /// In en, this message translates to:
  /// **'Save quick preset'**
  String get savePresetLabel;

  /// Start interval button semantic label
  ///
  /// In en, this message translates to:
  /// **'Start interval'**
  String get startIntervalLabel;

  /// Edit presets button semantic label
  ///
  /// In en, this message translates to:
  /// **'Edit presets'**
  String get editPresetsLabel;

  /// Add preset button semantic label
  ///
  /// In en, this message translates to:
  /// **'Add preset'**
  String get addPresetLabel;

  /// Dialog prompt for preset name
  ///
  /// In en, this message translates to:
  /// **'Preset name'**
  String get presetNamePrompt;

  /// Cancel button text
  ///
  /// In en, this message translates to:
  /// **'CANCEL'**
  String get cancelButton;

  /// OK button text
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get okButton;

  /// Simple mode button text
  ///
  /// In en, this message translates to:
  /// **'SIMPLE'**
  String get simpleModeButton;

  /// Advanced mode button text
  ///
  /// In en, this message translates to:
  /// **'ADVANCED'**
  String get advancedModeButton;

  /// Close button semantic label
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get closeButtonLabel;

  /// Save button semantic label
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get saveButtonLabel;

  /// Simple mode button semantic label
  ///
  /// In en, this message translates to:
  /// **'Simple mode'**
  String get simpleModeLabel;

  /// Advanced mode button semantic label
  ///
  /// In en, this message translates to:
  /// **'Advanced mode'**
  String get advancedModeLabel;

  /// Preset name input placeholder
  ///
  /// In en, this message translates to:
  /// **'Preset name'**
  String get presetNamePlaceholder;

  /// Preset name input semantic label
  ///
  /// In en, this message translates to:
  /// **'Preset name'**
  String get presetNameLabel;

  /// Prepare time label
  ///
  /// In en, this message translates to:
  /// **'PREPARE'**
  String get prepareLabel;

  /// Cooldown time label
  ///
  /// In en, this message translates to:
  /// **'COOLDOWN'**
  String get cooldownLabel;

  /// Decrease prepare button semantic label
  ///
  /// In en, this message translates to:
  /// **'Decrease prepare time'**
  String get decreasePrepareLabel;

  /// Increase prepare button semantic label
  ///
  /// In en, this message translates to:
  /// **'Increase prepare time'**
  String get increasePrepareLabel;

  /// Decrease cooldown button semantic label
  ///
  /// In en, this message translates to:
  /// **'Decrease cooldown time'**
  String get decreaseCooldownLabel;

  /// Increase cooldown button semantic label
  ///
  /// In en, this message translates to:
  /// **'Increase cooldown time'**
  String get increaseCooldownLabel;

  /// Long-press to exit workout button
  ///
  /// In en, this message translates to:
  /// **'Hold to exit'**
  String get workoutExitButton;

  /// Work step label
  ///
  /// In en, this message translates to:
  /// **'WORK'**
  String get workoutStepWork;

  /// Rest step label
  ///
  /// In en, this message translates to:
  /// **'REST'**
  String get workoutStepRest;

  /// Prepare step label
  ///
  /// In en, this message translates to:
  /// **'PREPARE'**
  String get workoutStepPrepare;

  /// Cooldown step label
  ///
  /// In en, this message translates to:
  /// **'COOLDOWN'**
  String get workoutStepCooldown;

  /// Toggle sound button semantic label
  ///
  /// In en, this message translates to:
  /// **'Toggle sound on or off'**
  String get workoutToggleSound;

  /// Previous step button semantic label
  ///
  /// In en, this message translates to:
  /// **'Previous'**
  String get workoutPrevious;

  /// Next step button semantic label
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get workoutNext;

  /// Pause button semantic label
  ///
  /// In en, this message translates to:
  /// **'Pause'**
  String get workoutPause;

  /// Resume button semantic label
  ///
  /// In en, this message translates to:
  /// **'Resume'**
  String get workoutResume;

  /// End workout screen title
  ///
  /// In en, this message translates to:
  /// **'FINI'**
  String get endWorkoutTitle;

  /// Stop button semantic label on end workout screen
  ///
  /// In en, this message translates to:
  /// **'Stop timer'**
  String get endWorkoutStopLabel;

  /// Restart button semantic label on end workout screen
  ///
  /// In en, this message translates to:
  /// **'Restart timer'**
  String get endWorkoutRestartLabel;

  /// Group repetitions header label in advanced mode
  ///
  /// In en, this message translates to:
  /// **'REPS'**
  String get advancedRepsLabel;

  /// Step mode: time
  ///
  /// In en, this message translates to:
  /// **'TIME'**
  String get advancedTimeLabel;

  /// Step mode: reps
  ///
  /// In en, this message translates to:
  /// **'REPS'**
  String get advancedStepRepsLabel;

  /// Color picker button text
  ///
  /// In en, this message translates to:
  /// **'COLOR'**
  String get advancedColorLabel;

  /// Finish section title
  ///
  /// In en, this message translates to:
  /// **'FINISH'**
  String get advancedFinishLabel;

  /// Alarm label in finish card
  ///
  /// In en, this message translates to:
  /// **'ALARM'**
  String get advancedAlarmLabel;

  /// Alarm beeps display
  ///
  /// In en, this message translates to:
  /// **'BEEP X{count}'**
  String advancedAlarmBeepsFormat(int count);

  /// Default step name
  ///
  /// In en, this message translates to:
  /// **'Step {number}'**
  String advancedStepDefaultName(int number);

  /// Add step button semantic label
  ///
  /// In en, this message translates to:
  /// **'Add step to group'**
  String get advancedAddStepLabel;

  /// Add group button semantic label
  ///
  /// In en, this message translates to:
  /// **'Add a new group'**
  String get advancedAddGroupLabel;

  /// Duplicate step button semantic label
  ///
  /// In en, this message translates to:
  /// **'Duplicate step'**
  String get advancedDuplicateLabel;

  /// Delete step button semantic label
  ///
  /// In en, this message translates to:
  /// **'Delete step'**
  String get advancedDeleteLabel;

  /// Reorder step button semantic label
  ///
  /// In en, this message translates to:
  /// **'Reorder step'**
  String get advancedReorderLabel;

  /// Decrease button semantic label
  ///
  /// In en, this message translates to:
  /// **'Decrease'**
  String get advancedDecreaseLabel;

  /// Increase button semantic label
  ///
  /// In en, this message translates to:
  /// **'Increase'**
  String get advancedIncreaseLabel;

  /// Choose color button semantic label
  ///
  /// In en, this message translates to:
  /// **'Choose color'**
  String get advancedChooseColorLabel;

  /// Color picker dialog title
  ///
  /// In en, this message translates to:
  /// **'Choose a color'**
  String get advancedChooseColorTitle;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'fr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'fr':
      return AppLocalizationsFr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
