import 'package:flutter/material.dart';

class AppColors{
  // Background
  static const Color background = Color(0xFF0F1020);
  static const Color boardBackground = Color(0xFF1B1C3A);
  static const Color gridLine = Color(0xFF2A2C5A);

  // Tetromino Colors
  static const Color pieceI = Color(0xFF00E5FF);
  static const Color pieceO = Color(0xFFFFEA00);
  static const Color pieceT = Color(0xFFB388FF);
  static const Color pieceL = Color(0xFFFF9100);
  static const Color pieceJ = Color(0xFF448AFF);
  static const Color pieceS = Color(0xFF00E676);
  static const Color pieceZ = Color(0xFFFF1744);

  // UI
  static const Color primary = Color(0xFF448AFF);
  static const Color accent = Color(0xFFFF1744);
  static const Color success = Color(0xFF00E676);
  static const Color warning = Color(0xFFFFD166);
  static const Color textPrimary = Colors.white;
  static const Color textSecondary = Color(0xFFB0B3C6);

  // Extra
  static const Color neonBlue = Color(0xFF00F0FF);
  static const Color darkSurface = Color(0xFF141530);

  // BackGround Gradient
  static const Gradient gameBg = LinearGradient(
    colors: [
      AppColors.background,
      AppColors.boardBackground,
    ],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );


}
