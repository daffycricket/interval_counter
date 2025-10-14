import 'package:flutter/material.dart';
import 'package:interval_counter/l10n/app_localizations.dart';
import '../../theme/app_colors.dart';

/// Volume header with slider and action buttons
/// Corresponds to Container-1, IconButton-2, Slider-3, IconButton-5 from plan.md
class VolumeHeader extends StatelessWidget {
  final double volume;
  final VoidCallback onVolumeToggle;
  final ValueChanged<double> onVolumeChange;
  final VoidCallback onMoreOptions;

  const VolumeHeader({
    super.key,
    required this.volume,
    required this.onVolumeToggle,
    required this.onVolumeChange,
    required this.onMoreOptions,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Container(
      key: const Key('interval_timer_home__Container-1'),
      color: AppColors.headerBackgroundDark,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Volume toggle button (IconButton-2)
          IconButton(
            key: const Key('interval_timer_home__IconButton-2'),
            icon: const Icon(Icons.volume_up),
            color: AppColors.onPrimary,
            onPressed: onVolumeToggle,
            tooltip: l10n.volumeButtonLabel,
            splashRadius: 20,
          ),

          // Volume slider (Slider-3)
          // Icon-4 (material.circle) is excluded per rule:slider/normalizeSiblings(drop)
          Expanded(
            child: SliderTheme(
              data: SliderThemeData(
                activeTrackColor: AppColors.sliderActive,
                inactiveTrackColor: AppColors.sliderInactive,
                thumbColor: AppColors.sliderThumb,
                trackHeight: 1,
                thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8),
              ),
              child: Slider(
                key: const Key('interval_timer_home__Slider-3'),
                value: volume,
                onChanged: onVolumeChange,
                min: 0.0,
                max: 1.0,
                semanticFormatterCallback: (double value) {
                  return '${(value * 100).round()}%';
                },
              ),
            ),
          ),

          // More options button (IconButton-5)
          IconButton(
            key: const Key('interval_timer_home__IconButton-5'),
            icon: const Icon(Icons.more_vert),
            color: AppColors.onPrimary,
            onPressed: onMoreOptions,
            tooltip: l10n.moreOptionsLabel,
            splashRadius: 20,
          ),
        ],
      ),
    );
  }
}
