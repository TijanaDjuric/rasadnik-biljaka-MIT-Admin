import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:skriptarnica_admin/models/plant_model.dart';

class PlantsProvider with ChangeNotifier {
  List<Plant> _plants = [];

  // Getter za pristup listi biljaka
  List<Plant> get getPlants {
    return _plants;
  }

  // 2. Referenca ka Firebase kolekciji (mora biti isti naziv kao u Admin app)
  final productDb = FirebaseFirestore.instance.collection("plants");

  // 3. Funkcija za povlačenje podataka iz Firebase-a
  Future<List<Plant>> fetchProducts() async {
    try {
      await productDb.get().then((productSnapshot) {
        _plants.clear();
        for (var element in productSnapshot.docs) {
          // Ovde koristimo fromFirestore metodu koju Plant model mora da ima
          _plants.insert(0, Plant.fromFirestore(element));
        }
      });
      notifyListeners();
      return _plants;
    } catch (e) {
      rethrow;
    }
  }

  Stream<List<Plant>> fetchProductsStream() {
    try {
      return productDb.snapshots().map((snapshot) {
        _plants.clear();
        for (var element in snapshot.docs) {
          _plants.insert(0, Plant.fromFirestore(element));
        }
        return _plants;
      });
    } catch (e) {
      rethrow;
    }
  }

  // 4. Funkcija za pretragu (Search)
  List<Plant> searchQuery({
    required String searchText,
    required List<Plant> passedList,
  }) {
    List<Plant> searchList = passedList
        .where(
          (element) => element
              .name // Kod tebe je name, ne productTitle
              .toLowerCase()
              .contains(searchText.toLowerCase()),
        )
        .toList();
    return searchList;
  }

  // 5. Pronalaženje po ID-u (ostaje isto, samo radimo sa listom iz baze)
  Plant? findByProdId(String plantId) {
    if (_plants.where((element) => element.id == plantId).isEmpty) {
      return null;
    }
    return _plants.firstWhere((element) => element.id == plantId);
  }

  // 6. Filtriranje po kategoriji
  List<Plant> findByCategory(String categoryName) {
    return _plants
        .where(
          (element) =>
              element.category.toLowerCase() == (categoryName.toLowerCase()),
        )
        .toList();
  }
}
