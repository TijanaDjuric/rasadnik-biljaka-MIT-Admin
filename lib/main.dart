import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skriptarnica_admin/consts/theme_data.dart';
import 'package:skriptarnica_admin/providers/plants_provider.dart';
import 'package:skriptarnica_admin/providers/theme_provider.dart';
import 'package:skriptarnica_admin/screens/dashboard_screen.dart';
import 'package:skriptarnica_admin/screens/edit_upload_product_from.dart';
import 'package:skriptarnica_admin/screens/inner_screens/orders_screen.dart';
import 'package:skriptarnica_admin/screens/search_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // MultiProvider je ključan jer Admin koristi i temu i proizvode
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => PlantsProvider()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Skriptarnica Admin',
            theme: Styles.themeData(
                isDarkTheme: themeProvider.getIsDarkTheme, 
                context: context),
            home: const DashboardScreen(), // Početni ekran za Admina
            routes: {
              DashboardScreen.routeName: (context) => const DashboardScreen(),
              SearchScreen.routeName: (context) => const SearchScreen(),
              EditOrUploadProductScreen.routeName: (context) => const EditOrUploadProductScreen(),
              OrdersScreenFree.routeName: (context) => const OrdersScreenFree(),
            },
          );
        },
      ),
    );
  }
}