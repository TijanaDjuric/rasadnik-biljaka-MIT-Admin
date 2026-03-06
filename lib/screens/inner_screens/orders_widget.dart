import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skriptarnica_admin/models/order_model.dart';
import 'package:skriptarnica_admin/providers/order_provider.dart';
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
  final orderModel = Provider.of<OrderModel>(context);
  final size = MediaQuery.of(context).size;
  final isDark = Theme.of(context).brightness == Brightness.dark;
  
  // Uzimamo prvu biljku za prikaz na slici i naslovu
  final firstPlant = orderModel.plants.isNotEmpty ? orderModel.plants[0].plant : null;

  return Container(
    // OVDE JE DEKORACIONI KOD KOJI JE FALIO
    margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
    padding: const EdgeInsets.all(10),
    decoration: BoxDecoration(
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
        // SLIKA
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: FancyShimmerImage(
            height: size.width * 0.22,
            width: size.width * 0.22,
            imageUrl: firstPlant?.imageUrl ?? "",
            boxFit: BoxFit.cover,
          ),
        ),
        const SizedBox(width: 12),

        // INFORMACIJE
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: TitleTextWidget(
                      label: firstPlant?.name ?? "Narudžbina",
                      fontSize: 16,
                    ),
                  ),
                  
                  // OVDE JE KOD ZA BRISANJE 
                  IconButton(
                    onPressed: () {
                      _showDeleteDialog(context, orderModel.orderId);
                    },
                    icon: const Icon(
                      Icons.close,
                      color: Colors.red,
                      size: 20,
                    ),
                  ),
                ],
              ),
              
              Row(
                children: [
                  const TitleTextWidget(label: 'Ukupno: ', fontSize: 14),
                  SubtitleTextWidget(
                    label: "${orderModel.totalPrice.toStringAsFixed(2)} RSD",
                    color: Colors.green.shade600,
                    fontWeight: FontWeight.bold,
                  ),
                ],
              ),
              const SizedBox(height: 4),
              
              SubtitleTextWidget(
                label: "Kupac: ${orderModel.userName}",
                fontSize: 12,
                color: Colors.grey,
              ),
              const SizedBox(height: 4),
              
              SubtitleTextWidget(
                label: "Artikala: ${orderModel.plants.length}",
                fontSize: 12,
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

// POMOĆNA FUNKCIJA ZA DIJALOG (Dodaj je ispod build metode)
void _showDeleteDialog(BuildContext context, String orderId) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text("Brisanje"),
        content: const Text("Da li želite da obrišete ovu narudžbinu?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Otkaži"),
          ),
          TextButton(
            onPressed: () async {
              final ordersProvider = Provider.of<OrderProvider>(context, listen: false);
              try {
                await ordersProvider.removeOrderFromFirestore(orderId: orderId);
                if (context.mounted) Navigator.pop(context);
              } catch (e) {
                print("Greška: $e");
              }
            },
            child: const Text("Obriši", style: TextStyle(color: Colors.red)),
          ),
        ],
      );
    },
  );
}
}