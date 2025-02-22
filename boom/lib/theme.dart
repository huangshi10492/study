import 'package:flutter/material.dart';

extension ThemeDataExt on ThemeData {
  /// This is the actual [cardColor] being used.
  Color get cardColorWithElevation {
    return ElevationOverlay.applySurfaceTint(
        cardColor, colorScheme.surfaceTint, 1);
  }
}
