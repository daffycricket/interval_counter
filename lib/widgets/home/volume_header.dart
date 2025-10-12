import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../state/interval_timer_home_state.dart';
import '../../theme/app_colors.dart';

/// En-tête avec contrôle de volume
class VolumeHeader extends StatelessWidget {
  const VolumeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.headerBackgroundDark,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Icône volume
          IconButton(
            key: const Key('interval_timer_home__icon_button_2'),
            icon: const Icon(Icons.volume_up, color: AppColors.onPrimary),
            onPressed: () {
              // Toggle volume control (optionnel - no-op pour l'instant)
            },
            tooltip: 'Régler le volume',
            iconSize: 24,
          ),

          // Slider volume
          Expanded(
            child: SliderTheme(
              data: SliderThemeData(
                activeTrackColor: AppColors.sliderActive,
                inactiveTrackColor: AppColors.sliderInactive,
                thumbColor: AppColors.sliderThumb,
                trackHeight: 4,
                overlayShape: SliderComponentShape.noOverlay,
              ),
              child: Semantics(
                label: 'Curseur de volume',
                child: Slider(
                  key: const Key('interval_timer_home__slider_3'),
                  min: 0.0,
                  max: 1.0,
                  value: context.watch<IntervalTimerHomeState>().volume,
                  onChanged: (value) {
                    context.read<IntervalTimerHomeState>().updateVolume(value);
                  },
                ),
              ),
            ),
          ),

          // Icône menu options
          IconButton(
            key: const Key('interval_timer_home__icon_button_5'),
            icon: const Icon(Icons.more_vert, color: AppColors.onPrimary),
            onPressed: () {
              // Afficher menu options
              _showOptionsMenu(context);
            },
            tooltip: 'Plus d\'options',
            iconSize: 24,
          ),
        ],
      ),
    );
  }

  void _showOptionsMenu(BuildContext context) {
    // Menu contextuel (placeholder)
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Paramètres'),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: const Icon(Icons.info),
              title: const Text('À propos'),
              onTap: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }
}

