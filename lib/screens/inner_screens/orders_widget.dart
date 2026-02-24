import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:skriptarnica_admin/consts/app_consts.dart';
import 'package:skriptarnica_admin/widgets/subtitle_text.dart';
import 'package:skriptarnica_admin/widgets/title_text.dart';

class OrdersWidgetFree extends StatefulWidget {
  const OrdersWidgetFree({super.key});

  @override
  State<OrdersWidgetFree> createState() => _OrdersWidgetFreeState();
}

class _OrdersWidgetFreeState extends State<OrdersWidgetFree> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        // Koristimo tvoju šumsko-zelenu boju
        color: isDark ? const Color(0xFF00382A) : Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          // SLIKA PROIZVODA
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: FancyShimmerImage(
              height: size.width * 0.22,
              width: size.width * 0.22,
              imageUrl: AppConstants.imageUrl,
              boxFit: BoxFit.cover,
            ),
          ),
          
          const SizedBox(width: 12),

          // INFORMACIJE O NARUDŽBINI
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Flexible(
                      child: TitleTextWidget(
                        label: 'Fikus Elastica - Robusta',
                        fontSize: 16,
                      ),
                    ),
                    // Dugme za uklanjanje narudžbine (samo vizuelno za sada)
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.close, color: Colors.red, size: 20),
                    ),
                  ],
                ),
                
                // CENA
                Row(
                  children: [
                    const TitleTextWidget(label: 'Cena: ', fontSize: 14),
                    SubtitleTextWidget(
                      label: "1.200 RSD", 
                      color: Colors.green.shade600,
                      fontWeight: FontWeight.bold,
                    ),
                  ],
                ),
                
                const SizedBox(height: 4),
                
                // KOLIČINA I OPIS (Dodato)
                Row(
                  children: [
                    const SubtitleTextWidget(label: "Količina: ", fontSize: 13),
                    const SubtitleTextWidget(label: "2 kom", fontWeight: FontWeight.bold, fontSize: 13),
                  ],
                ),
                
                const SizedBox(height: 8),

                // STATUS BAR (Zeleni tonovi za Admina)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    "Status: Novo",
                    style: TextStyle(
                      fontSize: 11, 
                      color: isDark ? Colors.green.shade300 : Colors.green.shade700, 
                      fontWeight: FontWeight.bold
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}