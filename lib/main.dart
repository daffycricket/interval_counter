import 'package:flutter/material.dart';
import 'screens/quick_start_timer_screen.dart';
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
      theme: AppTheme.theme,
      home: const QuickStartTimerScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
