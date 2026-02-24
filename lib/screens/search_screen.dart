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

    // Logika filtriranja
    final List<Plant> allPlants = categoryPassed == null
        ? plantsProvider.getPlants
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

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        // Pastelna pozadina celog ekrana
        backgroundColor: const Color(0xFFF1F8E9),
        appBar: AppBar(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          elevation: 0,
          iconTheme: IconThemeData(
          color: isDark ? Colors.white : Colors.black,
          ),
         title: TitleTextWidget(
          label: "Sve Biljke",
          color: isDark ? Colors.white : Colors.black,
        ),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            children: [
              const SizedBox(height: 15.0),
              // STILIZOVANI SEARCH BAR
              TextField(
                controller: searchTextController,
                decoration: InputDecoration(
                  hintText: "Pretraži Zeleni Raj...",
                  prefixIcon: const Icon(
                    Icons.search,
                    color: Color(0xFF4CAF50),
                  ),
                  suffixIcon: searchTextController.text.isNotEmpty
                      ? IconButton(
                          onPressed: () {
                            setState(() {
                              searchTextController.clear();
                              FocusScope.of(context).unfocus();
                            });
                          },
                          icon: const Icon(
                            Icons.clear,
                            color: Colors.redAccent,
                          ),
                        )
                      : null,
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(vertical: 0),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                    borderSide: const BorderSide(
                      color: Color(0xFFC8E6C9),
                      width: 1.5,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                    borderSide: const BorderSide(
                      color: Color(0xFF4CAF50),
                      width: 2,
                    ),
                  ),
                ),
                onChanged: (value) {
                  setState(() {});
                },
              ),
              const SizedBox(height: 20.0),

              // PRIKAZ LISTE
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
                          final plant = filteredPlants[index];
                          return PlantWidget(
                            plant: plant,
                            // Dodajemo callback za edit
                            onEdit: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      EditOrUploadProductScreen(
                                        plantModel: plant,
                                      ),
                                ),
                              );
                            },
                          );
                        },
                      )
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.eco_outlined,
                            size: 80,
                            color: Colors.green.withOpacity(0.3),
                          ),
                          const SizedBox(height: 10),
                          const Text(
                            "Nema pronađenih biljaka",
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.grey,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}
