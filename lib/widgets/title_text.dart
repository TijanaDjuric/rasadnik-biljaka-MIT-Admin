import 'package:flutter/material.dart';

class TitleTextWidget extends StatelessWidget {
  final String label;
  final int maxLines;
  final double fontSize; 
  final Color? color;

  const TitleTextWidget({
    super.key, 
    required this.label, 
    this.maxLines = 1,
    this.fontSize = 18, 
    this.color,         // Može biti null
    });

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      maxLines: maxLines,
      overflow: TextOverflow.ellipsis,
      style: TextStyle( // Izbacili smo 'const' jer su vrednosti sada dinamičke
        fontSize: fontSize,
        fontWeight: FontWeight.bold,
        color: color,
      ),
    );
  }
}