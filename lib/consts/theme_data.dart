import 'package:flutter/material.dart';
import 'package:skriptarnica_admin/consts/app_colors.dart';

class Styles {
  static ThemeData themeData({
    required bool isDarkTheme, 
    required BuildContext context
  }) {
    return ThemeData(
      // Glavna pozadina ekrana
      scaffoldBackgroundColor: isDarkTheme
          ? const Color(0xFF002117) // Duboka tamno-zelena umesto crne/sive
          : AppColors.lightScaffoldColor,
          
      // Pozadina kartica (proizvoda i opcija na Dashboardu)
      cardColor: isDarkTheme 
          ? const Color(0xFF00382A) // Nešto svetlija tamno-zelena da bi se kartice videle
          : AppColors.lightCardColor,
          
      brightness: isDarkTheme ? Brightness.dark : Brightness.light,

      // AppBar stilizacija za tamni režim
      appBarTheme: AppBarTheme(
        backgroundColor: isDarkTheme 
            ? const Color(0xFF004D40) 
            : const Color(0xFFC8E6C9),
        elevation: 0,
        centerTitle: true,
      ),

      // Stilizacija polja za unos (TextField) u tamnom režimu
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: isDarkTheme ? const Color(0xFF004034) : Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}