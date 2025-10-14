// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get quickStartTitle => 'Quick Start';

  @override
  String get repsLabel => 'REPETITIONS';

  @override
  String get workLabel => 'WORK';

  @override
  String get restLabel => 'REST';

  @override
  String get saveButton => 'SAVE';

  @override
  String get startButton => 'START';

  @override
  String get presetsTitle => 'YOUR PRESETS';

  @override
  String get addButton => '+ ADD';

  @override
  String get volumeButtonLabel => 'Adjust volume';

  @override
  String get volumeSliderLabel => 'Volume slider';

  @override
  String get moreOptionsLabel => 'More options';

  @override
  String get collapseQuickStartLabel => 'Collapse Quick Start section';

  @override
  String get decreaseRepsLabel => 'Decrease repetitions';

  @override
  String get increaseRepsLabel => 'Increase repetitions';

  @override
  String get decreaseWorkLabel => 'Decrease work time';

  @override
  String get increaseWorkLabel => 'Increase work time';

  @override
  String get decreaseRestLabel => 'Decrease rest time';

  @override
  String get increaseRestLabel => 'Increase rest time';

  @override
  String get savePresetLabel => 'Save quick preset';

  @override
  String get startIntervalLabel => 'Start interval';

  @override
  String get editPresetsLabel => 'Edit presets';

  @override
  String get addPresetLabel => 'Add preset';

  @override
  String selectPresetLabel(String name) {
    return 'Select preset $name';
  }

  @override
  String get emptyPresetsMessage =>
      'No saved presets.\\nTap + ADD to create one.';

  @override
  String get presetSavedSnackbar => 'Preset saved';

  @override
  String get saveFailed => 'Save failed. Please try again.';

  @override
  String get repsValidationError => 'Repetitions must be between 1 and 99';

  @override
  String get workTimeValidationError =>
      'Work time must be between 00:05 and 60:00';

  @override
  String get restTimeValidationError =>
      'Rest time must be between 00:00 and 60:00';

  @override
  String get presetNameEmptyError => 'Preset name cannot be empty';

  @override
  String get maxRepsError => 'Maximum 99 repetitions';

  @override
  String get minWorkTimeError => 'Minimum 5 seconds work';

  @override
  String get loadPresetsError => 'Unable to load presets';
}
