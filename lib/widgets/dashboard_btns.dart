import 'package:flutter/material.dart';
import 'package:skriptarnica_admin/widgets/subtitle_text.dart';

class DashboardButtonsWidget extends StatelessWidget {
  const DashboardButtonsWidget({
    super.key,
    required this.text,
    required this.imagePath,
    required this.onPressed,
  });

  final String text, imagePath;
  final VoidCallback onPressed; // Bolje koristiti VoidCallback za funkcije

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Padding(
        padding: const EdgeInsets.all(8.0), 
        child: Card(
          color: const Color(0xFFF1F8E9),
          elevation: 2, 
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: Color(0xFFC8E6C9), width: 1),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                imagePath,
                height: 60, 
                width: 60,
                errorBuilder: (context, error, stackTrace) {
                  // Ako slika fali, prikaži fallback ikonicu da nemaš "iks"
                  return const Icon(Icons.image_not_supported, size: 50, color: Colors.grey);
                },
              ),
              const SizedBox(height: 12),
              SubtitleTextWidget(
                label: text,
                fontSize: 16,
                color: const Color(0xFF2E7D32),
                fontWeight: FontWeight.bold,
              ),
            ],
          ),
        ),
      ),
    );
  }
}