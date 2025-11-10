import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../state/workout_state.dart';
import '../../theme/app_colors.dart';

/// Widget de contrôles de volume en haut de l'écran
class VolumeControls extends StatelessWidget {
  const VolumeControls({super.key});
  
  @override
  Widget build(BuildContext context) {
    final state = context.watch<WorkoutState>();
    
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          // Bouton toggle son
          IconButton(
            key: const Key('workout__iconbutton-1'),
            icon: Icon(
              Icons.volume_up,
              color: Colors.black,
            ),
            onPressed: state.toggleSound,
            tooltip: 'Activer ou désactiver le son',
          ),
          
          // Slider de volume
          Expanded(
            child: SliderTheme(
              data: SliderTheme.of(context).copyWith(
                activeTrackColor: Colors.black,
                inactiveTrackColor: AppColors.sliderInactive,
                thumbColor: Colors.black,
                trackHeight: 4,
              ),
              child: Slider(
                key: const Key('workout__slider-1'),
                value: state.volume,
                onChanged: state.onVolumeChange,
                min: 0.0,
                max: 1.0,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

