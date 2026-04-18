import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skriptarnica_admin/data/dummy_categories.dart';
import 'package:skriptarnica_admin/models/plant_model.dart';
import 'package:skriptarnica_admin/providers/plants_provider.dart';
import 'package:skriptarnica_admin/screens/edit_upload_product_from.dart';
import 'package:skriptarnica_admin/widgets/plant_widget.dart';
import 'package:skriptarnica_admin/widgets/title_text.dart';

class SearchScreen extends StatefulWidget {
  static const routeName = '/SearchScreen';
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  late TextEditingController searchTextController;
  List<Plant> filteredPlants = [];

  @override
  void initState() {
    super.initState();
    searchTextController = TextEditingController();
  }

  @override
  void dispose() {
    searchTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final plantsProvider = Provider.of<PlantsProvider>(context);

    // Hvatanje kategorije iz navigacije
    final String? categoryPassed =
        ModalRoute.of(context)!.settings.arguments as String?;

    String title = "Sve Biljke";
    if (categoryPassed != null) {
      try {
        final category = dummyCategories.firstWhere(
          (element) => element.id == categoryPassed,
        );
        title = category.name;
      } catch (e) {
        title = categoryPassed;
      }
    }

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        // Pastelna pozadina celog ekrana
        backgroundColor: const Color(0xFFF1F8E9),
        appBar: AppBar(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          elevation: 0,
          iconTheme: IconThemeData(color: isDark ? Colors.white : Colors.black),
          title: TitleTextWidget(
            label: "Sve Biljke",
            color: isDark ? Colors.white : Colors.black,
          ),
        ),
        body: StreamBuilder<List<Plant>>(
          stream: plantsProvider.fetchProductsStream(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: SelectableText("Greška: ${snapshot.error}"));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text("Nema dodatih biljaka u bazi."));
            }

            // 1. LOGIKA FILTRIRANJA (Ostaje ista)
            List<Plant> allPlants = categoryPassed == null
                ? snapshot.data!
                : plantsProvider.findByCategory(categoryPassed);

            if (searchTextController.text.isNotEmpty) {
              filteredPlants = allPlants.where((plant) {
                return plant.name.toLowerCase().contains(
                  searchTextController.text.toLowerCase(),
                );
              }).toList();
            } else {
              filteredPlants = allPlants;
            }

            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  const SizedBox(height: 15.0),
                  // 2. SEARCH TEXTFIELD (Ostaje isti)
                  TextField(
                    controller: searchTextController,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.search),
                      suffixIcon: GestureDetector(
                        onTap: () {
                          setState(() {
                            searchTextController.clear();
                            FocusScope.of(context).unfocus();
                          });
                        },
                        child: const Icon(Icons.clear, color: Colors.red),
                      ),
                      hintText: "Pretraži proizvode za izmenu...",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onChanged: (value) {
                      setState(() {});
                    },
                  ),
                  const SizedBox(height: 15.0),
                  Expanded(
                    child: filteredPlants.isNotEmpty
                        ? GridView.builder(
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  crossAxisSpacing: 12,
                                  mainAxisSpacing: 12,
                                  childAspectRatio: 0.6,
                                ),
                            itemCount: filteredPlants.length,
                            itemBuilder: (context, index) {
                              return PlantWidget(
                                plant: filteredPlants[index],
                                onEdit: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          EditOrUploadProductScreen(
                                            plantModel: filteredPlants[index],
                                          ),
                                    ),
                                  );
                                },
                                onDelete: () async {
                                  try {
                                    // Pozivamo provider da obriše iz Firebase-a
                                    await plantsProvider.deleteProduct(
                                      filteredPlants[index].id,
                                    );

                                    // Obaveštenje korisniku
                                    if (context.mounted) {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                            "Biljka uspešno uklonjena",
                                          ),
                                        ),
                                      );
                                    }
                                  } catch (e) {
                                    print("Greška pri brisanju: $e");
                                  }
                                },
                              );
                            },
                          )
                        : const Center(
                            child: Text("Nema biljki koje odgovaraju pretrazi"),
                          ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
