import 'package:flutter/material.dart';

abstract class Tokens {
  static const Color primary = Color(0xFF455A64);
  static const Color accent  = Color(0xFFFFD600);
  static const Color text    = Color(0xFF000000);
  static const Color muted   = Color(0xFF666666);
  static const Color surface = Color(0xFFF9F9F9);
  static const Color divider = Color(0xFFCCCCCC);
  static const Color bg      = Color(0xFFFFFFFF);

  static const double spaceXs = 4;
  static const double spaceSm = 8;
  static const double spaceMd = 12;
  static const double spaceLg = 16;
  static const double spaceXl = 24;

  static const BorderRadius rSm = BorderRadius.all(Radius.circular(4));
  static const BorderRadius rMd = BorderRadius.all(Radius.circular(8));
  static const BorderRadius rLg = BorderRadius.all(Radius.circular(12));
}
