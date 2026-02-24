import 'package:flutter/material.dart';
import 'package:skriptarnica_admin/widgets/title_text.dart';


class AppNameTextWidget extends StatelessWidget {
  const AppNameTextWidget({super.key, this.fontSize = 24});
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    // Proveravamo da li je tamna tema da bismo znali koju boju teksta da stavimo
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return TitleTextWidget(
      label: "Zeleni Raj Admin", // Ažurirano ime
      fontSize: fontSize,
      // Koristimo tamno zelenu za svetli mod i svetlo zelenu za tamni mod
      color: isDark ? Colors.green.shade300 : Colors.green.shade900, 
    );
  }
}