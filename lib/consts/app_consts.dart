import 'package:skriptarnica_admin/models/categories_model.dart';
import 'package:skriptarnica_admin/services/assets_manager.dart';

class AppConstants {
  /// Default slika (fallback)
  static const String imageUrl =
      'https://images.unsplash.com/photo-1501004318641-b39e6451bec6';

  /// Banneri za Home screen
  static List<String> bannersImages = [
    "${AssetsManager.imagePath}/banners/rasadnik1.jpg",
    "${AssetsManager.imagePath}/banners/rasadnik2.jpg",
  ];

  /// Kategorije biljaka
  static List<CategoriesModel> categoriesList = [
    CategoriesModel(
      id: "indoor",
      name: "Sobne biljke",
      image: "${AssetsManager.imagePath}/categories/indoor.png",
    ),
    CategoriesModel(
      id: "garden",
      name: "Baštenske biljke",
      image: "${AssetsManager.imagePath}/categories/garden.png",
    ),
    CategoriesModel(
      id: "flowers",
      name: "Cveće",
      image: "${AssetsManager.imagePath}/categories/flowers.png",
    ),
    CategoriesModel(
      id: "trees",
      name: "Drveće i žbunje",
      image: "${AssetsManager.imagePath}/categories/trees.png",
    ),
    CategoriesModel(
      id: "succulents",
      name: "Sukulenti i kaktusi",
      image: "${AssetsManager.imagePath}/categories/succulents.png",
    ),
  ];
}
