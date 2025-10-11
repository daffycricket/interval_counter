import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';

/// En-tête avec contrôle de volume
class VolumeHeader extends StatelessWidget {
  final double volume;
  final ValueChanged<double> onVolumeChanged;
  final VoidCallback? onOptionsPressed;

  const VolumeHeader({
    super.key,
    required this.volume,
    required this.onVolumeChanged,
    this.onOptionsPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      key: const Key('interval_timer_home__Container-1'),
      color: AppColors.headerBackgroundDark,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Icône volume
          IconButton(
            key: const Key('interval_timer_home__IconButton-2'),
            icon: const Icon(Icons.volume_up),
            color: AppColors.onPrimary,
            iconSize: 24,
            padding: const EdgeInsets.all(8),
            constraints: const BoxConstraints(
              minWidth: 40,
              minHeight: 40,
            ),
            onPressed: () {},
            tooltip: 'Régler le volume',
          ),

          // Slider de volume
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: SliderTheme(
                data: SliderThemeData(
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
                  value: volume,
                  onChanged: onVolumeChanged,
                  semanticFormatterCallback: (value) {
                    return '${(value * 100).round()}%';
                  },
                ),
              ),
            ),
          ),

          // NOTE: Icon-4 (material.circle thumb) est exclu selon le plan
          // buildStrategy: rule:slider/normalizeSiblings(drop)
          // Raison: thumb-like sibling (orphan thumb)

          // Bouton options
          IconButton(
            key: const Key('interval_timer_home__IconButton-5'),
            icon: const Icon(Icons.more_vert),
            color: AppColors.onPrimary,
            iconSize: 28,
            padding: const EdgeInsets.all(8),
            constraints: const BoxConstraints(
              minWidth: 44,
              minHeight: 44,
            ),
            onPressed: onOptionsPressed,
            tooltip: 'Plus d\'options',
          ),
        ],
      ),
    );
  }
}

