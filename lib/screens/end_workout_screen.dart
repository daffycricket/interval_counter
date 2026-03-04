import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
import '../models/preset.dart';
import '../routes/app_routes.dart';
import '../theme/app_text_styles.dart';

/// Écran terminal affiché à la fin d'un workout.
/// Permet à l'utilisateur d'arrêter (retour home) ou de relancer le workout.
class EndWorkoutScreen extends StatelessWidget {
  final Preset preset;

  const EndWorkoutScreen({super.key, required this.preset});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: const Color(0xFF0F7C82),
      body: SafeArea(
        child: Center(
          child: Column(
            key: const Key('end_workout__container-1'),
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                l10n.endWorkoutTitle.toUpperCase(),
                key: const Key('end_workout__text-2'),
                style: AppTextStyles.titleLarge.copyWith(
                  color: const Color(0xFF1A1A1A),
                ),
              ),
              const SizedBox(height: 40),
              Row(
                key: const Key('end_workout__container-3'),
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _ShapedIconButton(
                    key: const Key('end_workout__iconbutton-4'),
                    icon: Icons.stop,
                    semanticLabel: l10n.endWorkoutStopLabel,
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  const SizedBox(width: 24),
                  _ShapedIconButton(
                    key: const Key('end_workout__iconbutton-6'),
                    icon: Icons.refresh,
                    semanticLabel: l10n.endWorkoutRestartLabel,
                    onPressed: () => Navigator.of(context).pushReplacementNamed(
                      AppRoutes.workout,
                      arguments: preset,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Bouton icône 100×100 avec fond coloré et coins arrondis.
/// Implémente rule:iconButton/shaped.
class _ShapedIconButton extends StatelessWidget {
  final IconData icon;
  final String semanticLabel;
  final VoidCallback onPressed;

  const _ShapedIconButton({
    super.key,
    required this.icon,
    required this.semanticLabel,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        color: const Color(0xFF6F7F86),
        borderRadius: BorderRadius.circular(6),
      ),
      child: IconButton(
        onPressed: onPressed,
        icon: Icon(icon, color: const Color(0xFFE6E6E6), size: 30),
        tooltip: semanticLabel,
        splashRadius: 50,
      ),
    );
  }
}
