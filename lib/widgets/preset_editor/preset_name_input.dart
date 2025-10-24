import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

/// Widget du champ de saisie du nom de préréglage
class PresetNameInput extends StatelessWidget {
  final String name;
  final ValueChanged<String> onNameChange;

  const PresetNameInput({
    super.key,
    required this.name,
    required this.onNameChange,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Semantics(
        label: l10n.presetNameLabel,
        textField: true,
        child: TextField(
          key: const Key('preset_editor__input-6'),
          controller: TextEditingController(text: name)
            ..selection = TextSelection.collapsed(offset: name.length),
          onChanged: onNameChange,
          style: AppTextStyles.body.copyWith(
            fontSize: 16,
            color: AppColors.primary,
          ),
          decoration: InputDecoration(
            hintText: l10n.presetNamePlaceholder,
            filled: true,
            fillColor: AppColors.surface,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(2),
              borderSide: const BorderSide(
                color: Color(0xFF999999),
                width: 1,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(2),
              borderSide: const BorderSide(
                color: Color(0xFF999999),
                width: 1,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(2),
              borderSide: const BorderSide(
                color: AppColors.accent,
                width: 1,
              ),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          ),
        ),
      ),
    );
  }
}

