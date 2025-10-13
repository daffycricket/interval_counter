import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../state/interval_timer_home_state.dart';
import '../../theme/app_colors.dart';

/// En-tête avec contrôle de volume et menu options
/// Composants: Container-1, IconButton-2, Slider-3, IconButton-5
/// Note: Icon-4 exclu (thumb-like sibling)
class VolumeHeader extends StatelessWidget {
  const VolumeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<IntervalTimerHomeState>();

    return Container(
      key: const Key('interval_timer_home__Container-1'),
      color: AppColors.headerBackgroundDark,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // IconButton volume
          IconButton(
            key: const Key('interval_timer_home__IconButton-2'),
            icon: const Icon(Icons.volume_up, color: AppColors.onPrimary),
            onPressed: () {
              // TODO: Afficher panneau volume étendu
            },
            padding: const EdgeInsets.all(8),
            constraints: const BoxConstraints(),
            tooltip: 'Régler le volume',
          ),
          
          // Slider volume
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: SliderTheme(
                data: SliderThemeData(
                  activeTrackColor: AppColors.sliderActive,
                  inactiveTrackColor: AppColors.sliderInactive,
                  thumbColor: AppColors.sliderThumb,
                  trackHeight: 4,
                  overlayShape: SliderComponentShape.noOverlay,
                ),
                child: Slider(
                  key: const Key('interval_timer_home__Slider-3'),
                  value: state.volume,
                  onChanged: (value) => state.onVolumeChange(value),
                  min: 0.0,
                  max: 1.0,
                ),
              ),
            ),
          ),

          // IconButton menu
          IconButton(
            key: const Key('interval_timer_home__IconButton-5'),
            icon: const Icon(Icons.more_vert, color: AppColors.onPrimary),
            onPressed: () {
              // TODO: Afficher menu contextuel
            },
            padding: const EdgeInsets.all(8),
            constraints: const BoxConstraints(),
            tooltip: 'Plus d\'options',
          ),
        ],
      ),
    );
  }
}
