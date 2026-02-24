import 'package:skriptarnica_admin/models/plant_model.dart';
import 'package:skriptarnica_admin/services/assets_manager.dart';

final List<Plant> dummyPlants = [
  Plant(
    id: '1',
    name: 'Fikus',
    description: 'Sobna biljka koja voli svetlost.',
    price: 1500,
    imageUrl: "${AssetsManager.imagePath}/plants/fikus.png",
    isAvailable: true,
    category: "indoor",
  ),
  Plant(
    id: '2',
    name: 'Monstera',
    description: 'Popularna dekorativna biljka.',
    price: 2200,
    imageUrl: "${AssetsManager.imagePath}/plants/monstera.png",
    isAvailable: true,
    category: "indoor",
  ),
  Plant(
    id: '3',
    name: 'Lavanda',
    description: 'Mirisna biljka za baštu.',
    price: 900,
    imageUrl: "${AssetsManager.imagePath}/plants/lavanda.png",
    isAvailable: false,
    category: "garden",
  ),
    Plant(
    id: "4",
    name: "Kaktus",
    description: "Otporna biljka koja voli sunce.",
    price: 500,
    imageUrl: "${AssetsManager.imagePath}/plants/kaktus.png",
    isAvailable: true,
    category: "succulents",
  ),
   Plant(
    id: "5",
    name: "Ruža",
    description: "Poznata zbog svoje lepote, mirisa.",
    price: 200,
    imageUrl: "${AssetsManager.imagePath}/plants/ruza.png",
    isAvailable: true,
    category: "indoor",
  ),
   Plant(
    id: "6",
    name: "Breza",
    description: "Rod drvenastih biljaka.",
    price: 410,
    imageUrl: "${AssetsManager.imagePath}/plants/breza.png",
    isAvailable: true,
    category: "trees",
  ),
];
