import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'l10n/app_localizations.dart';
import 'screens/interval_timer_home_screen.dart';
import 'state/interval_timer_home_state.dart';
import 'theme/app_colors.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Créer le state avec injection de dépendances
  final homeState = await IntervalTimerHomeState.create();

  runApp(IntervalCounterApp(homeState: homeState));
}

class IntervalCounterApp extends StatelessWidget {
  final IntervalTimerHomeState homeState;

  const IntervalCounterApp({
    super.key,
    required this.homeState,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: homeState,
      child: MaterialApp(
        title: 'Interval Counter',

        // Localization configuration per plan.md § 2.6
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('fr'), // French (default)
          Locale('en'), // English
        ],
        locale: const Locale('fr'), // Prefer French

        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: AppColors.primary,
            brightness: Brightness.light,
          ),
          scaffoldBackgroundColor: AppColors.background,
          useMaterial3: true,
        ),
        home: const IntervalTimerHomeScreen(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
