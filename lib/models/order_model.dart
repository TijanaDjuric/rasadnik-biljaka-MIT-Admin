import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:skriptarnica_admin/models/cart_item.dart';
import 'package:skriptarnica_admin/models/plant_model.dart';

class OrderModel with ChangeNotifier {
  final String orderId;
  final String userId;
  final String userName; 
  final double totalPrice; 
  final List<CartItem> plants; 
  final Timestamp orderDate; 

  OrderModel({
    required this.orderId,
    required this.userId,
    required this.userName,
    required this.totalPrice,
    required this.plants,
    required this.orderDate,
  });

  factory OrderModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    
    // Mapiranje liste stavki iz Firebase-a u tvoju List<CartItem>
    List<CartItem> tempPlants = [];
    if (data['plants'] != null) {
      data['plants'].forEach((v) {
        tempPlants.add(CartItem(
          cartId: v['cartId'] ?? '',
          quantity: v['quantity'] ?? 1,
          plant: Plant(
            id: v['productId'] ?? '',
            name: v['productName'] ?? 'Nepoznata biljka',
            price: (v['price'] as num? ?? 0.0).toDouble(),
            imageUrl: v['imageUrl'] ?? '',
            // Ovi podaci obično nisu u narudžbini, pa stavljamo default vrednosti
            description: '',
            category: '',
            isAvailable: true,
            stock: 0,
          ),
        ));
      });
    }

    return OrderModel(
      orderId: data['orderId'] ?? '',
      userId: data['userId'] ?? '',
      userName: data['userName'] ?? 'Kupac',
      totalPrice: (data['totalPrice'] as num? ?? 0.0).toDouble(),
      plants: tempPlants,
      orderDate: data['orderDate'] ?? Timestamp.now(),
    );
  }
}
