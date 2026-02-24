import 'package:flutter/material.dart';
import 'package:skriptarnica_admin/screens/inner_screens/orders_widget.dart';
import 'package:skriptarnica_admin/services/assets_manager.dart';
import 'package:skriptarnica_admin/widgets/empty_bag.dart';
import 'package:skriptarnica_admin/widgets/title_text.dart';

class OrdersScreenFree extends StatefulWidget {
  static const routeName = '/OrderScreen';
  const OrdersScreenFree({super.key});

  @override
  State<OrdersScreenFree> createState() => _OrdersScreenFreeState();
}

class _OrdersScreenFreeState extends State<OrdersScreenFree> {
  bool isEmptyOrders = false; // Postavi na true da testiraš praznu korpu

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF002117) : const Color(0xFFF1F8E9),
      appBar: AppBar(
        title: const TitleTextWidget(label: 'Sve Narudžbine'), // Na srpskom lepše zvuči
      ),
      body: isEmptyOrders
          ? EmptyBagWidget(
              imagePath: AssetsManager.order,
              title: "Još uvek nema narudžbina",
              subtitle: "Čim neko naruči biljku, pojaviće se ovde!",
            )
          : ListView.separated(
              itemCount: 10,
              padding: const EdgeInsets.symmetric(vertical: 12),
              itemBuilder: (ctx, index) {
                return const OrdersWidgetFree();
              },
              separatorBuilder: (context, index) => const Divider(
                thickness: 1,
                indent: 20,
                endIndent: 20,
              ),
            ),
    );
  }
}