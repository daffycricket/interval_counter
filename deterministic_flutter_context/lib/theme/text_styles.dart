import 'package:flutter/material.dart';
import 'tokens.dart';

abstract class AppTextStyles {
  static const TextStyle title = TextStyle(
    fontSize: 18, fontWeight: FontWeight.w700, color: Tokens.text, height: 1.2,
  );
  static const TextStyle label = TextStyle(
    fontSize: 14, fontWeight: FontWeight.w600, color: Tokens.text, height: 1.4,
  );
  static const TextStyle body = TextStyle(
    fontSize: 16, fontWeight: FontWeight.w400, color: Tokens.text, height: 1.5,
  );
  static const TextStyle muted = TextStyle(
    fontSize: 14, fontWeight: FontWeight.w400, color: Tokens.muted, height: 1.5,
  );
}
