import 'package:flutter/material.dart';
import 'package:skriptarnica_admin/widgets/subtitle_text.dart';
import 'package:skriptarnica_admin/widgets/title_text.dart';



class EmptyBagWidget extends StatelessWidget {
  const EmptyBagWidget({
    super.key,
    required this.imagePath,
    required this.title,
    required this.subtitle,
  });

  final String imagePath, title, subtitle;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        children: [
          const SizedBox(height: 50),
          
          // Slika (npr. prazna korpa ili paket)
          Image.asset(
            imagePath,
            width: double.infinity,
            height: size.height * 0.35,
          ),
          
          const SizedBox(height: 20),

          // Glavni naslov - sada je dinamičan i koristi zelenu boju teme
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: TitleTextWidget(
              label: title,
              fontSize: 28, // Smanjeno sa 40 da bi lepše stalo
              color: isDark ? Colors.green.shade300 : Colors.green.shade800,
            ),
          ),
          
          const SizedBox(height: 20),

          // Podnaslov/Opis
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: SubtitleTextWidget(
              label: subtitle,
              fontWeight: FontWeight.w400,
              fontSize: 16,
            ),
          ),
          
          const SizedBox(height: 40),
        ],
      ),
    );
  }
}