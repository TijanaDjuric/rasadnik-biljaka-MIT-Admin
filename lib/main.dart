import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skriptarnica_admin/consts/theme_data.dart';
import 'package:skriptarnica_admin/providers/order_provider.dart';
import 'package:skriptarnica_admin/providers/plants_provider.dart';
import 'package:skriptarnica_admin/providers/theme_provider.dart';
import 'package:skriptarnica_admin/screens/dashboard_screen.dart';
import 'package:skriptarnica_admin/screens/edit_upload_product_from.dart';
import 'package:skriptarnica_admin/screens/inner_screens/orders_screen.dart';
import 'package:skriptarnica_admin/screens/search_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
   return FutureBuilder(
      future: Firebase.initializeApp(),
      builder: (context, snapshot) {
        // Dok čekamo bazu
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const MaterialApp(
            debugShowCheckedModeBanner: false,
            home: Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            ),
          );
        } 
        // Ako nešto pođe po zlu kod Admina
        else if (snapshot.hasError) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            home: Scaffold(
              body: Center(
                child: SelectableText(
                  "Greška pri povezivanju Admin aplikacije:\n${snapshot.error.toString()}",
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          );
        }

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => PlantsProvider()),
        ChangeNotifierProvider(create: (_) => OrderProvider())
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
    },
    );
  }
}