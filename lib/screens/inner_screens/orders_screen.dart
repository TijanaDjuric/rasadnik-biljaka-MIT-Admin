import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skriptarnica_admin/models/order_model.dart';
import 'package:skriptarnica_admin/providers/order_provider.dart';
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
  late Future<List<OrderModel>> _ordersFuture;

  @override
  void initState() {
    super.initState();
    // Pozivamo bazu samo JEDNOM pri pokretanju ekrana
    _ordersFuture = Provider.of<OrderProvider>(context, listen: false).fetchOrders();
  }

  @override
  Widget build(BuildContext context) {
    final ordersProvider = Provider.of<OrderProvider>(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF002117) : const Color(0xFFF1F8E9),
      appBar: AppBar(
        title: const TitleTextWidget(label: 'Sve Narudžbine'),
      ),
      body: FutureBuilder<List<OrderModel>>(
        future: _ordersFuture, // Pozivamo bazu, Koristi promenljivu, ne direktan poziv funkcije
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: TitleTextWidget(label: "Greška: ${snapshot.error}"));
          } else if (ordersProvider.getOrders.isEmpty) {
            return EmptyBagWidget(
              imagePath: AssetsManager.order,
              title: "Nema narudžbina",
              subtitle: "Još uvek niko nije ništa poručio.",
            );
          }

          return ListView.separated(
            itemCount: ordersProvider.getOrders.length, // Prava dužina liste
            padding: const EdgeInsets.symmetric(vertical: 12),
            itemBuilder: (ctx, index) {
              // Prosleđujemo pojedinačni model svakom widgetu
              return ChangeNotifierProvider.value(
                value: ordersProvider.getOrders[index],
                child: const OrdersWidgetFree(),
              );
            },
            separatorBuilder: (context, index) => const Divider(thickness: 1),
          );
        },
      ),
    );
  }
}