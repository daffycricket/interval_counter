import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';

/// En-tête avec contrôle de volume et menu d'options
class VolumeHeader extends StatelessWidget {
  final double volumeLevel;
  final ValueChanged<double> onVolumeChanged;
  final VoidCallback onVolumeButtonPressed;
  final VoidCallback onMenuPressed;

  const VolumeHeader({
    super.key,
    required this.volumeLevel,
    required this.onVolumeChanged,
    required this.onVolumeButtonPressed,
    required this.onMenuPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      key: const Key('interval_timer_home__Container-1'),
      color: AppColors.headerBackgroundDark,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: SafeArea(
        bottom: false,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Bouton volume
            Semantics(
              label: 'Régler le volume',
              button: true,
              child: IconButton(
                key: const Key('interval_timer_home__IconButton-2'),
                icon: const Icon(Icons.volume_up, color: AppColors.onPrimary),
                onPressed: onVolumeButtonPressed,
                padding: const EdgeInsets.all(8),
                constraints: const BoxConstraints(),
                iconSize: 24,
              ),
            ),

            // Slider de volume (Expanded pour remplir l'espace disponible)
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Semantics(
                  label: 'Curseur de volume',
                  slider: true,
                  child: SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                      activeTrackColor: AppColors.sliderActive,
                      inactiveTrackColor: AppColors.sliderInactive,
                      thumbColor: AppColors.sliderThumb,
                      trackHeight: 4,
                      thumbShape: const RoundSliderThumbShape(
                        enabledThumbRadius: 8,
                      ),
                      overlayShape: const RoundSliderOverlayShape(
                        overlayRadius: 16,
                      ),
                    ),
                    child: Slider(
                      key: const Key('interval_timer_home__Slider-3'),
                      value: volumeLevel,
                      onChanged: onVolumeChanged,
                      min: 0.0,
                      max: 1.0,
                    ),
                  ),
                ),
              ),
            ),

            // Note: Icon-4 (material.circle) est exclu comme indiqué dans le plan
            // (thumb orphelin détecté lors de la validation)

            // Bouton menu
            Semantics(
              label: 'Plus d\'options',
              button: true,
              child: IconButton(
                key: const Key('interval_timer_home__IconButton-5'),
                icon: const Icon(Icons.more_vert, color: AppColors.onPrimary),
                onPressed: onMenuPressed,
                padding: const EdgeInsets.all(8),
                constraints: const BoxConstraints(),
                iconSize: 24,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
