import 'package:flutter/material.dart';
import 'package:skriptarnica_admin/screens/edit_upload_product_from.dart';
import 'package:skriptarnica_admin/screens/inner_screens/orders_screen.dart';
import 'package:skriptarnica_admin/screens/search_screen.dart';
import 'package:skriptarnica_admin/services/assets_manager.dart';

class DashboardButtonsModel {
  final String text, imagePath;
  final VoidCallback onPressed;

  DashboardButtonsModel({
    required this.text,
    required this.imagePath,
    required this.onPressed,
  });

  static List<DashboardButtonsModel> dashboardBtnList(BuildContext context) => [
        DashboardButtonsModel(
          text: "Dodaj proizvod",
          imagePath: AssetsManager.cloud, 
          onPressed: () {
            Navigator.pushNamed(context, EditOrUploadProductScreen.routeName);
          },
        ),
        DashboardButtonsModel(
          text: "Svi proizvodi",
          imagePath: AssetsManager.shoppingCart,
          onPressed: () {
            Navigator.pushNamed(context, SearchScreen.routeName);
          },
        ),
        DashboardButtonsModel(
          text: "Narudžbine",
          imagePath: AssetsManager.order,
          onPressed: () {
             Navigator.pushNamed(context, OrdersScreenFree.routeName);
          },
        ),
      ];
}