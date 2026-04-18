import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Plant with ChangeNotifier {
  final String id;
  final String name;
  final String description;
  final double price;
  final String imageUrl;
  final bool isAvailable;
  final String category;
  final int stock;
  final Timestamp? createdAt; 

   Plant({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrl,
    required this.isAvailable,
    required this.category,
    required this.stock,
     this.createdAt,
  });

 factory Plant.fromFirestore(DocumentSnapshot doc) {
  Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
  return Plant(
    id: doc.id, 
    name: data['name'] ?? 'Nepoznata biljka',
    // Sigurnija konverzija u double
    price: double.parse(data['price'].toString()), 
    category: data['category'] ?? 'Razno',
    description: data['description'] ?? '',
    imageUrl: data['imageUrl'] ?? '',
    isAvailable: data['isAvailable'] ?? false,
    // Sigurnija konverzija u int
    stock: int.parse(data['stock'].toString()), 
    createdAt: data['createdAt'],
  );
}
}
