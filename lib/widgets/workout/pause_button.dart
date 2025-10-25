import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../state/workout_state.dart';
import '../../theme/app_colors.dart';

/// Bouton FAB de pause/lecture
class PauseButton extends StatelessWidget {
  const PauseButton({super.key});
  
  @override
  Widget build(BuildContext context) {
    final state = context.watch<WorkoutState>();
    
    return FloatingActionButton(
      key: const Key('workout__iconbutton-4'),
      onPressed: state.togglePause,
      backgroundColor: AppColors.ghostButtonBg,
      tooltip: state.isPaused ? 'Reprendre' : 'Mettre en pause',
      child: Icon(
        state.isPaused ? Icons.play_arrow : Icons.pause,
        color: Colors.white,
        size: 32,
      ),
    );
  }
}

