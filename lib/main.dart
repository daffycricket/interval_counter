import 'package:flutter/material.dart';
import 'screens/interval_timer_home_screen.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(const IntervalCounterApp());
}

class IntervalCounterApp extends StatelessWidget {
  const IntervalCounterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Interval Counter',
      theme: AppTheme.lightTheme,
      home: const IntervalTimerHomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
