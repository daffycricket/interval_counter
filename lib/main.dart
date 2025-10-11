import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/interval_timer_home_screen.dart';
import 'state/interval_timer_home_state.dart';
import 'state/presets_state.dart';
import 'theme/app_colors.dart';

void main() {
  runApp(const IntervalCounterApp());
}

class IntervalCounterApp extends StatelessWidget {
  const IntervalCounterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => IntervalTimerHomeState()),
        ChangeNotifierProvider(create: (_) => PresetsState()),
      ],
      child: MaterialApp(
        title: 'Interval Counter',
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
