import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';

/// Dialog simple de sélection de couleur parmi une palette prédéfinie.
class ColorPickerDialog extends StatelessWidget {
  final Color currentColor;
  final String title;

  const ColorPickerDialog({
    super.key,
    required this.currentColor,
    this.title = 'Choose a color',
  });

  static Future<Color?> show(
    BuildContext context, {
    required Color currentColor,
    String title = 'Choose a color',
  }) {
    return showDialog<Color>(
      context: context,
      builder: (_) => ColorPickerDialog(
        currentColor: currentColor,
        title: title,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColors.advancedCardBg,
      title: Text(
        title,
        style: const TextStyle(color: AppColors.advancedTextPrimary, fontSize: 18),
      ),
      content: Wrap(
        spacing: 12,
        runSpacing: 12,
        children: AppColors.stepColorPalette.map((color) {
          final isSelected = color.toARGB32() == currentColor.toARGB32();
          return GestureDetector(
            onTap: () => Navigator.of(context).pop(color),
            child: Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(8),
                border: isSelected
                    ? Border.all(color: Colors.white, width: 3)
                    : null,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
