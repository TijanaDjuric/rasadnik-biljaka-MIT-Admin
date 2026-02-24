import 'package:flutter/material.dart';
import 'package:skriptarnica_admin/data/dummy_plants.dart';
import 'package:skriptarnica_admin/models/plant_model.dart';

class PlantsProvider with ChangeNotifier {
  // Umesto ručnog kucanja, kopiramo sve iz dummyPlants liste
  final List<Plant> _plants = [...dummyPlants];

  // Getter za pristup listi biljaka
  List<Plant> get getPlants {
    return _plants;
  }

  // Korisna metoda koju ćeš sigurno trebati za Details Screen
  Plant? findByProdId(String plantId) {
    if (_plants.where((element) => element.id == plantId).isEmpty) {
      return null;
    }
    return _plants.firstWhere((element) => element.id == plantId);
  }

  // Metoda za filtriranje po kategoriji (npr. za Home Screen)
  List<Plant> findByCategory(String categoryName) {
    return _plants
        .where((element) =>
            element.category.toLowerCase() == (categoryName.toLowerCase()))
        .toList();
  }
}