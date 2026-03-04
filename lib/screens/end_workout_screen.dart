import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
import '../models/preset.dart';
import '../routes/app_routes.dart';

/// Écran de fin de workout (terminal)
class EndWorkoutScreen extends StatelessWidget {
  final Preset preset;

  const EndWorkoutScreen({
    super.key,
    required this.preset,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: const Color(0xFF008290),
      body: SafeArea(
        child: Column(
          children: [
            // Espace du haut (30% de l'écran environ)
            const Spacer(flex: 3),

            // Titre "FINI"
            Text(
              l10n.endWorkoutTitle,
              key: const Key('end_workout__text-2'),
              style: const TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.bold,
                color: Color(0xFF212121),
              ),
            ),

            // Grand espace entre titre et boutons (35% de l'écran environ)
            const Spacer(flex: 4),

            // Boutons d'action
            Row(
              key: const Key('end_workout__container-3'),
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Bouton Stop
                _ActionButton(
                  key: const Key('end_workout__iconbutton-4'),
                  icon: Icons.stop,
                  semanticLabel: l10n.endWorkoutStopLabel,
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),

                const SizedBox(width: 24),

                // Bouton Restart
                _ActionButton(
                  key: const Key('end_workout__iconbutton-6'),
                  icon: Icons.replay,
                  semanticLabel: l10n.endWorkoutRestartLabel,
                  onPressed: () {
                    Navigator.of(context).pushReplacementNamed(
                      AppRoutes.workout,
                      arguments: preset,
                    );
                  },
                ),
              ],
            ),

            // Espace du bas (30% de l'écran environ)
            const Spacer(flex: 3),
          ],
        ),
      ),
    );
  }
}

/// Bouton d'action carré avec icône et tooltip
class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String semanticLabel;
  final VoidCallback onPressed;

  const _ActionButton({
    super.key,
    required this.icon,
    required this.semanticLabel,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: semanticLabel,
      button: true,
      child: Tooltip(
        message: semanticLabel,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(4),
          child: Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: const Color(0xFF546F78),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Icon(
              icon,
              color: Colors.white,
              size: 32,
            ),
          ),
        ),
      ),
    );
  }
}
