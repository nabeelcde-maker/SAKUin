import 'package:flutter/material.dart';

/// Palette taken from the Figma file's local variables
/// (Hijau Tua / Hijau Muda / Krem / Kuning) and extended with the
/// semantic + neutral roles the original design was missing.
class AppColors {
  AppColors._();

  // Brand
  static const primary = Color(0xFF186049); // Hijau Tua
  static const primaryDark = Color(0xFF0F4433);
  static const primaryLight = Color(0xFF2E8065);
  static const secondary = Color(0xFF4A943E); // Hijau Muda
  static const cream = Color(0xFFECE8AF); // Krem
  static const amber = Color(0xFFD98327); // Kuning

  // Semantic
  static const success = Color(0xFF17A34A);
  static const danger = Color(0xFFD64545);
  static const info = Color(0xFF2F80ED);

  // Ink / text
  static const ink = Color(0xFF101B17);
  static const inkSoft = Color(0xFF5C6B66);
  static const inkMuted = Color(0xFF8A9995);

  // Surfaces
  static const surface = Color(0xFFFFFFFF);
  static const surfaceMuted = Color(0xFFF3F6F4);
  static const line = Color(0xFFE5EBE8);

  // Category hues — deliberately distinct (the Figma file used 4 shades of green,
  // which is unreadable and fails for colour-blind users).
  static const catShopping = Color(0xFF186049);
  static const catTransport = Color(0xFF4A943E);
  static const catFood = Color(0xFFD98327);
  static const catSport = Color(0xFF2F80ED);
  static const catBills = Color(0xFF8E5BD9);
  static const catHealth = Color(0xFFD64545);

  // Background gradient (soft mint → peach → mint, as in the design)
  static const bgBase = Color(0xFFF2F5F2);
  static const bgMint = Color(0xFFDFF0E6);
  static const bgPeach = Color(0xFFF7E6D2);
  static const bgSky = Color(0xFFE3EDF7);

  static const brandGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF20795C), Color(0xFF11493A)],
  );

  static const heroGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF2C8A6A), Color(0xFF14513F)],
  );

  static const amberGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFF0A63C), Color(0xFFD97C15)],
  );

  static const tripGradient = LinearGradient(
    begin: Alignment.bottomLeft,
    end: Alignment.topRight,
    colors: [Color(0xFF1F4F45), Color(0xFF6FA98E)],
  );

  static const gadgetGradient = LinearGradient(
    begin: Alignment.bottomLeft,
    end: Alignment.topRight,
    colors: [Color(0xFF1B2436), Color(0xFF3E5C86)],
  );
}
