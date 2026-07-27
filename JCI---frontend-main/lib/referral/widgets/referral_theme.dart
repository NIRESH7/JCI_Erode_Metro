import 'package:flutter/material.dart';

class ReferralTheme {
  static const Color lightBlue = Color(0xFF24B9EC);
  static const Color darkBlue = Color(0xFF23346B);
  static const Color softBg = Color(0xFFF4F8FC);
  static const Color cardBg = Colors.white;

  static BoxDecoration cardDecoration = BoxDecoration(
    color: cardBg,
    borderRadius: BorderRadius.circular(16),
    boxShadow: [
      BoxShadow(
        color: darkBlue.withOpacity(0.08),
        blurRadius: 16,
        offset: const Offset(0, 6),
      ),
    ],
  );

  static ButtonStyle primaryButton = ElevatedButton.styleFrom(
    backgroundColor: lightBlue,
    foregroundColor: Colors.white,
    padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
    elevation: 0,
  );

  static ButtonStyle outlineButton = OutlinedButton.styleFrom(
    foregroundColor: darkBlue,
    side: const BorderSide(color: lightBlue, width: 1.5),
    padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
  );
}
