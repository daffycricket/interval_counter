import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

/// Widget de l'en-tête avec contrôle volume et menu optionnel
/// 
/// Usage:
/// - Home: passer onMenuPressed pour afficher le bouton menu
/// - Workout: passer onMenuPressed: null pour masquer le bouton menu
class VolumeHeader extends StatelessWidget implements PreferredSizeWidget {
  final double volume;
  final ValueChanged<double> onVolumeChange;
  final VoidCallback? onMenuPressed; // Nullable: si null, pas de bouton menu
  final Color backgroundColor;
  final Color activeColor;
  final Color inactiveColor;

  const VolumeHeader({
    super.key,
    required this.volume,
    required this.backgroundColor,
    required this.activeColor,
    required this.inactiveColor,
    required this.onVolumeChange,
    this.onMenuPressed, // Optionnel
  });

  @override
  Size get preferredSize => const Size.fromHeight(70);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return SafeArea( 
      child: Container(
      height: 88,
      color: backgroundColor,
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
              icon: Icon(Icons.volume_up, color: activeColor),
              iconSize: 24,
              onPressed: () {
                // Action informative, le slider gère déjà le volume
              },
            ),
          ),

          // Slider volume
          Expanded(
            child: Semantics(
              label: l10n.volumeSliderLabel,
              slider: true,
              child: SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  activeTrackColor: activeColor, //isDark ? AppColors.sliderActiveDark : AppColors.sliderActive,
                  inactiveTrackColor: inactiveColor, //isDark ? AppColors.sliderInactiveDark : AppColors.sliderInactive,
                  thumbColor: activeColor,
                  trackHeight: 1,
                  trackShape: RectangularSliderTrackShape(),
                  thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8),
                  overlayShape: const RoundSliderOverlayShape(overlayRadius: 16),
                ),
                child: Slider(
                  value: volume,
                  min: 0.0,
                  max: 1.0,
                  onChanged: onVolumeChange,
                ),
              ),
            ),
          ),

          // Bouton menu (optionnel)
          if (onMenuPressed != null)
            Semantics(
              label: l10n.menuButtonLabel,
              button: true,
              child: IconButton(
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

