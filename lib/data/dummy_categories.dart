import 'package:skriptarnica_admin/models/categories_model.dart';
import 'package:skriptarnica_admin/services/assets_manager.dart';

final List<CategoriesModel> dummyCategories = [
  CategoriesModel(
    id: "indoor", // mora da se poklapa sa Plant.category
    name: "Sobne biljke",
    image: "${AssetsManager.imagePath}/categories/indoor.png",
  ),
  CategoriesModel(
    id: "garden",
    name: "Baštenske biljke",
    image: "${AssetsManager.imagePath}/categories/garden.png",
  ),
  CategoriesModel(
    id: "succulents",
    name: "Sukulenti",
    image: "${AssetsManager.imagePath}/categories/succulents.png",
  ),
  CategoriesModel(
    id: "trees",
    name: "Drveće",
    image: "${AssetsManager.imagePath}/categories/trees.png",
  ),
];