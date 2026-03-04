import 'package:flutter/material.dart';

/// Carte FINISH affichant le titre, le bouton COLOR et les infos d'alarme.
class FinishCard extends StatelessWidget {
  final Color finishColor;
  final int alarmBeeps;
  final VoidCallback? onColorTap;

  const FinishCard({
    super.key,
    required this.finishColor,
    this.alarmBeeps = 3,
    this.onColorTap,
  });

  Color get _foreground =>
      finishColor.computeLuminance() > 0.5 ? Colors.black : Colors.white;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: finishColor,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'FINISH',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: _foreground,
            ),
          ),
          const SizedBox(height: 12),
          // COLOR button
          GestureDetector(
            onTap: onColorTap,
            child: Semantics(
              label: 'Choose finish color',
              button: true,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.edit, size: 14, color: _foreground),
                  const SizedBox(width: 4),
                  Text(
                    'COLOR',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: _foreground,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          // Alarm info
          Row(
            children: [
              Text(
                'ALARM',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: _foreground,
                ),
              ),
              const SizedBox(width: 8),
              Icon(Icons.notifications_active, size: 18, color: _foreground),
              const SizedBox(width: 8),
              Text(
                'BEEP X$alarmBeeps',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: _foreground,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
