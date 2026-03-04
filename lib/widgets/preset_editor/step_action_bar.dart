import 'package:flutter/material.dart';

/// Barre d'actions pour une étape : COLOR, dupliquer, supprimer.
class StepActionBar extends StatelessWidget {
  final VoidCallback? onColorTap;
  final VoidCallback? onDuplicate;
  final VoidCallback? onDelete;
  final Color foregroundColor;
  final String colorLabel;
  final String duplicateLabel;
  final String deleteLabel;

  const StepActionBar({
    super.key,
    this.onColorTap,
    this.onDuplicate,
    this.onDelete,
    this.foregroundColor = Colors.white,
    this.colorLabel = 'COLOR',
    this.duplicateLabel = 'Duplicate step',
    this.deleteLabel = 'Delete step',
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // COLOR button with leading icon
        GestureDetector(
          onTap: onColorTap,
          child: Semantics(
            label: colorLabel,
            button: true,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.edit, size: 14, color: foregroundColor),
                const SizedBox(width: 4),
                Text(
                  'COLOR',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: foregroundColor,
                  ),
                ),
              ],
            ),
          ),
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Semantics(
              label: duplicateLabel,
              button: true,
              child: IconButton(
                onPressed: onDuplicate,
                icon: Icon(Icons.content_copy, size: 18, color: foregroundColor),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
              ),
            ),
            Semantics(
              label: deleteLabel,
              button: true,
              child: IconButton(
                onPressed: onDelete,
                icon: Icon(Icons.delete, size: 18, color: foregroundColor),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
