import 'package:flutter/material.dart';

class SubtitleTextWidget extends StatelessWidget {
  final String label;
  final int maxLines;
  final Color? color; // Promenjeno u opciono
  final FontWeight? fontWeight;
  final FontStyle? fontStyle;
  final double fontSize; // DODATO OVO POLJE
  final TextDecoration? textDecoration;

  const SubtitleTextWidget({
    super.key,
    required this.label,
    this.maxLines = 1,
    this.color,
    this.fontWeight,
    this.fontStyle,
    this.fontSize = 14, // Podrazumevana vrednost je 14
    this.textDecoration,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      maxLines: maxLines,
      overflow: TextOverflow.ellipsis,
      style: TextStyle( // Izbačeno const da bi primao dinamičke vrednosti
        fontSize: fontSize,
        color: color ?? Colors.grey, // Koristi prosleđenu boju ili sivu
        fontWeight: fontWeight,
        fontStyle: fontStyle,
        decoration: textDecoration,
      ),
    );
  }
}