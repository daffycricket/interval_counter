import 'package:flutter/material.dart';
import 'screens/interval_timer_home_screen.dart';
import 'theme/app_colors.dart';

void main() {
  runApp(const IntervalCounterApp());
}

class IntervalCounterApp extends StatelessWidget {
  const IntervalCounterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
    );
  }
}
