import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skriptarnica_admin/models/order_model.dart';
import 'package:skriptarnica_admin/providers/order_provider.dart';
import 'package:skriptarnica_admin/widgets/subtitle_text.dart';
import 'package:skriptarnica_admin/widgets/title_text.dart';

class OrderDetailsScreen extends StatelessWidget {
  static const routeName = '/OrderDetailsScreen';
  const OrderDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
  // 1. Prvo uzimamo podatke iz Navigatora da bismo znali ID narudžbine
  final argumentOrder = ModalRoute.of(context)!.settings.arguments as OrderModel;
  final size = MediaQuery.of(context).size;
  final isDark = Theme.of(context).brightness == Brightness.dark;

  // Povezujemo se sa provajderom
  // Slušamo listu narudžbina i tražimo onu koja ima isti ID
  final orderProvider = Provider.of<OrderProvider>(context);
  final orderModel = orderProvider.getOrders.firstWhere(
    (element) => element.orderId == argumentOrder.orderId,
    orElse: () => argumentOrder, // Ako je ne nađe u listi, koristi staru verziju
  );

  // 3. Koristimo podatke iz 'orderModel' (onog koji dolazi iz provajdera)
  final DateTime date = orderModel.orderDate.toDate();

  final String dan = date.day.toString().padLeft(2, '0');
  final String mesec = date.month.toString().padLeft(2, '0');
  final String godina = date.year.toString();
  final String sati = date.hour.toString().padLeft(2, '0');
  final String minuti = date.minute.toString().padLeft(2, '0');
  final String formattedDate = "$dan.$mesec.$godina. u $sati:$minuti";

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF002117) : const Color(0xFFF1F8E9),
      appBar: AppBar(
        title: const TitleTextWidget(label: "Detalji Narudžbine"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const TitleTextWidget(label: "Informacije o kupcu", fontSize: 18),
              const SizedBox(height: 10),
              _customerInfoRow("Ime:", orderModel.userName),
              _customerInfoRow("Datum:", formattedDate),
              _customerInfoRow("ID Kupca:", orderModel.userId),
              const Divider(height: 30),
              const TitleTextWidget(label: "Stavke narudžbine", fontSize: 18),
              const SizedBox(height: 10),
              
              // Lista biljaka u narudžbini
              ListView.builder(
                shrinkWrap: true, 
                physics: const NeverScrollableScrollPhysics(),
                itemCount: orderModel.plants.length,
                itemBuilder: (ctx, index) {
                  final plantOrder = orderModel.plants[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 5),
                    child: ListTile(
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: FancyShimmerImage(
                          width: 50,
                          height: 50,
                          imageUrl: plantOrder.plant.imageUrl,
                          boxFit: BoxFit.cover,
                        ),
                      ),
                      title: TitleTextWidget(
                        label: plantOrder.plant.name,
                        fontSize: 16,
                      ),
                      subtitle: Text("Količina: ${plantOrder.quantity}"),
                      trailing: TitleTextWidget(
                        label: "${plantOrder.plant.price} RSD",
                        fontSize: 14,
                        color: Colors.green,
                      ),
                    ),
                  );
                },
              ),
              const Divider(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const TitleTextWidget(label: "UKUPNO ZA NAPLATU:", fontSize: 18),
                  TitleTextWidget(
                    label: "${orderModel.totalPrice.toStringAsFixed(2)} RSD",
                    fontSize: 20,
                    color: Colors.green,
                  ),
                ],
              ),
              const Divider(height: 30),
              // --- STATUS SEKCIJU ---
              const TitleTextWidget(label: "Status Narudžbine:", fontSize: 18),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: isDark ? Colors.white10 : Colors.black.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.green.withOpacity(0.3)),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: orderModel.orderStatus, // Uzima status iz modela
                    isExpanded: true,
                    items: ["Na čekanju", "Poslato", "Isporučeno"].map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (String? newValue) async {
                      if (newValue != null) {
                        try {
                          await Provider.of<OrderProvider>(context, listen: false)
                              .updateOrderStatus(
                                  orderId: orderModel.orderId, 
                                  newStatus: newValue
                              );
                          
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Status promenjen u: $newValue")),
                          );
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Greška pri ažuriranju: $e")),
                          );
                        }
                      }
                    },
                  ),
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _customerInfoRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Row(
        children: [
          SubtitleTextWidget(label: title, fontWeight: FontWeight.bold),
          const SizedBox(width: 10),
          Expanded(child: SubtitleTextWidget(label: value)),
        ],
      ),
    );
  }
}