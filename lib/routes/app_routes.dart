import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../screens/home_screen.dart';
import '../screens/preset_editor_screen.dart';
import '../screens/workout_screen.dart';
import '../state/home_state.dart';
import '../state/preset_editor_state.dart';
import '../models/preset.dart';

/// Gestionnaire de routes de l'application
class AppRoutes {
  AppRoutes._(); // Constructeur privé

  // Noms de routes
  static const String home = '/';
  static const String workout = '/workout';
  static const String presetEditor = '/preset_editor';

  /// Génère les routes de l'application
  static Route<dynamic>? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case home:
        return MaterialPageRoute(
          builder: (_) => const HomeScreen(),
          settings: settings,
        );

      case workout:
        final preset = settings.arguments as Preset;
        return MaterialPageRoute(
          builder: (_) => WorkoutScreen(preset: preset),
          settings: settings,
        );

      case presetEditor:
        final args = settings.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(
          builder: (context) {
            // Récupérer le HomeState depuis le context
            final homeState = context.read<HomeState>();
            
            // Créer le PresetEditorState avec les paramètres fournis
            return FutureBuilder<SharedPreferences>(
              future: SharedPreferences.getInstance(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Scaffold(
                    body: Center(child: CircularProgressIndicator()),
                  );
                }
                
                final editorState = PresetEditorState(
                  homeState,
                  initialName: args?['name'] as String?,
                  initialPrepareSeconds: args?['prepareSeconds'] as int?,
                  initialRepetitions: args?['repetitions'] as int?,
                  initialWorkSeconds: args?['workSeconds'] as int?,
                  initialRestSeconds: args?['restSeconds'] as int?,
                  initialCooldownSeconds: args?['cooldownSeconds'] as int?,
                  isEditMode: args?['isEditMode'] as bool?,
                  presetId: args?['presetId'] as String?,
                );
                
                return ChangeNotifierProvider.value(
                  value: editorState,
                  child: const PresetEditorScreen(),
                );
              },
            );
          },
          settings: settings,
        );

      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('Route non trouvée: ${settings.name}'),
            ),
          ),
        );
    }
  }
}

