import 'package:skriptarnica_admin/models/plant_model.dart';

class CartItem {
  final String cartId;
  final Plant plant;
  int quantity;

  CartItem({
    required this.cartId,
    required this.plant,
    this.quantity = 1,
  });
}