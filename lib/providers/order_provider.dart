import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:skriptarnica_admin/models/cart_item.dart';
import 'package:skriptarnica_admin/models/order_model.dart';
import 'package:skriptarnica_admin/models/plant_model.dart';

class OrderProvider with ChangeNotifier {
  final List<OrderModel> _orders = [];
  List<OrderModel> get getOrders => _orders;

  final _firestore = FirebaseFirestore.instance;

  Future<List<OrderModel>> fetchOrders() async {
    try {
      // Admin povlači SVE porudžbine, sortirane po datumu
      final orderSnapshot = await _firestore
          .collection("orders")
          .orderBy("orderDate", descending: true)
          .get();

      _orders.clear();

      for (var element in orderSnapshot.docs) {
        final data = element.data();
        
        try {
          _orders.add(
            OrderModel(
              orderId: data['orderId'] ?? '',
              userId: data['userId'] ?? '',
              userName: data['userName'] ?? 'Kupac',
              // Sigurna konverzija brojeva
              totalPrice: (data['totalPrice'] as num? ?? 0.0).toDouble(),
              orderDate: data['orderDate'] ?? Timestamp.now(),
              orderStatus: data['orderStatus'] ?? 'Na čekanju',
              plants: (data['plants'] as List? ?? []).map((itemData) {
                final item = itemData as Map<String, dynamic>;
                return CartItem(
                  cartId: data['orderId'] ?? '',
                  quantity: item['quantity'] ?? 1,
                  plant: Plant(
                 
                    id: item['plantId'] ?? '', 
                    name: item['name'] ?? 'Nepoznata biljka',
                    price: (item['price'] as num? ?? 0.0).toDouble(),
                    imageUrl: item['imageUrl'] ?? '',
                    description: "",
                    category: "",
                    isAvailable: true,
                    stock: 0,
                  ),
                );
              }).toList(),
            ),
          );
        } catch (innerError) {
          print("Preskačem neispravnu porudžbinu: $innerError");
        }
      }
      
      notifyListeners();
      return _orders;
    } catch (e) {
      print("Greška pri preuzimanju porudžbina: $e");
      rethrow;
    }
  }

  Future<void> removeOrderFromFirestore({required String orderId}) async {
    try {
      await _firestore.collection("orders").doc(orderId).delete();
      _orders.removeWhere((element) => element.orderId == orderId);
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateOrderStatus({required String orderId, required String newStatus}) async {
  try {
    await FirebaseFirestore.instance
        .collection('orders')
        .doc(orderId)
        .update({'orderStatus': newStatus});
    
    // Opciono ažuriraj lokalnu listu da se odmah vidi promena bez osvežavanja
    int index = _orders.indexWhere((order) => order.orderId == orderId);
    if (index != -1) {
      fetchOrders(); 
    }
    notifyListeners();
  } catch (e) {
    rethrow;
  }
}
}