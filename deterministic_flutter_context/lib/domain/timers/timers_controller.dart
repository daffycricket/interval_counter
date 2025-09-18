import 'package:flutter/foundation.dart';

class TimersController extends ChangeNotifier {
  int repetitions;
  Duration work;
  Duration rest;

  TimersController({this.repetitions = 16, Duration? work, Duration? rest})
      : work = work ?? const Duration(seconds: 44),
        rest = rest ?? const Duration(seconds: 15);

  void incReps() { repetitions++; notifyListeners(); }
  void decReps() { if (repetitions > 0) { repetitions--; notifyListeners(); } }

  void setWork(Duration d) { work = d; notifyListeners(); }
  void setRest(Duration d) { rest = d; notifyListeners(); }
}
