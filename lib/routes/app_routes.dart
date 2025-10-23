import 'package:flutter/material.dart';
import '../screens/home_screen.dart';

/// Gestionnaire de routes de l'application
class AppRoutes {
  AppRoutes._(); // Constructeur privé

  // Noms de routes
  static const String home = '/';
  static const String timer = '/timer';

  /// Génère les routes de l'application
  static Route<dynamic>? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case home:
        return MaterialPageRoute(
          builder: (_) => const HomeScreen(),
          settings: settings,
        );

      case timer:
        // TODO: Implémenter l'écran Timer
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(
              child: Text('Timer Screen - À implémenter'),
            ),
          ),
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

