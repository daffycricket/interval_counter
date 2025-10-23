import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

/// Widget de l'en-tête avec contrôle volume et menu
class VolumeHeader extends StatelessWidget implements PreferredSizeWidget {
  final double volume;
  final ValueChanged<double> onVolumeChange;
  final VoidCallback onMenuPressed;

  const VolumeHeader({
    super.key,
    required this.volume,
    required this.onVolumeChange,
    required this.onMenuPressed,
  });

  @override
  Size get preferredSize => const Size.fromHeight(70);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return SafeArea( 
      child: Container(
      key: const Key('home__Container-1'),
      height: 88,
      color: AppColors.headerBackgroundDark,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: 
          Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Bouton volume
          Semantics(
            label: l10n.volumeButtonLabel,
            button: true,
            child: IconButton(
              key: const Key('home__IconButton-2'),
              icon: const Icon(Icons.volume_up, color: AppColors.onPrimary),
              iconSize: 24,
              onPressed: () {
                // Action informative, le slider gère déjà le volume
              },
            ),
          ),

          // Slider volume
          Expanded(
            child: Container(
              child: Semantics(
                label: l10n.volumeSliderLabel,
                slider: true,
                child: SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    activeTrackColor: AppColors.sliderActive,
                    inactiveTrackColor: AppColors.sliderInactive,
                    thumbColor: AppColors.sliderThumb,
                    trackHeight: 1,
                    trackShape: RectangularSliderTrackShape(),
                    thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8),
                    overlayShape: const RoundSliderOverlayShape(overlayRadius: 16),
                  ),
                  child: Slider(
                    key: const Key('home__Slider-3'),
                    value: volume,
                    min: 0.0,
                    max: 1.0,
                    onChanged: onVolumeChange,
                  ),
                ),
              ),
            ),
          ),

          // Bouton menu
          Semantics(
            label: l10n.menuButtonLabel,
            button: true,
            child: IconButton(
              key: const Key('home__IconButton-5'),
              icon: const Icon(Icons.more_vert, color: AppColors.onPrimary),
              iconSize: 28,
              onPressed: onMenuPressed,
            ),
          ),
        ],
      ),
    )
    );
  }
}
