import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';

/// Header avec contrôle de volume
class VolumeControlHeader extends StatelessWidget {
  final double volumeLevel;
  final ValueChanged<double> onVolumeChanged;
  final VoidCallback? onVolumeButtonTap;
  final VoidCallback? onMoreOptionsTap;

  const VolumeControlHeader({
    super.key,
    required this.volumeLevel,
    required this.onVolumeChanged,
    this.onVolumeButtonTap,
    this.onMoreOptionsTap,
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
          // Bouton volume
          Semantics(
            label: 'Régler le volume',
            button: true,
            child: IconButton(
              key: const Key('interval_timer_home__IconButton-2'),
              icon: const Icon(Icons.volume_up),
              color: AppColors.onPrimary,
              onPressed: onVolumeButtonTap,
            ),
          ),

          // Slider de volume
          Expanded(
            child: Semantics(
              label: 'Curseur de volume',
              slider: true,
              child: SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  activeTrackColor: AppColors.sliderActive,
                  inactiveTrackColor: AppColors.sliderInactive,
                  thumbColor: AppColors.sliderThumb,
                  trackHeight: 4,
                  thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8),
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

          // Bouton plus d'options
          Semantics(
            label: 'Plus d\'options',
            button: true,
            child: IconButton(
              key: const Key('interval_timer_home__IconButton-5'),
              icon: const Icon(Icons.more_vert),
              color: AppColors.onPrimary,
              onPressed: onMoreOptionsTap,
            ),
          ),
        ],
      ),
    );
  }
}
