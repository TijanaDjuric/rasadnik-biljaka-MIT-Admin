import 'package:flutter/material.dart';
import 'package:skriptarnica_admin/consts/app_colors.dart';
import 'package:skriptarnica_admin/models/plant_model.dart';
import 'package:skriptarnica_admin/screens/edit_upload_product_from.dart';
import 'package:skriptarnica_admin/widgets/subtitle_text.dart';
import 'package:skriptarnica_admin/widgets/title_text.dart';

class PlantWidget extends StatelessWidget {
  final Plant plant;
  final Function onEdit;

  const PlantWidget({super.key, required this.plant, required this.onEdit});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    Future<void> _showDeleteDialog(BuildContext context) async {
      await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            title: const Text("Obriši biljku?"),
            content: const Text(
              "Da li ste sigurni da želite da uklonite ovu biljku iz Zelenog Raja?",
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text(
                  "Odustani",
                  style: TextStyle(color: Colors.grey),
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                onPressed: () {
                  // OVDE ĆEMO DODATI FIREBASE BRISANJE
                  Navigator.pop(context);
                },
                child: const Text(
                  "Obriši",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          );
        },
      );
    }

    return GestureDetector(
      onTap: () {
        // Klik na karticu kod Admina vodi na izmenu proizvoda
        Navigator.pushNamed(
          context,
          EditOrUploadProductScreen.routeName,
          arguments:
              plant, // Šaljemo ceo objekat biljke da bi se polja popunila
        );
      },
      child: Card(
        elevation: 2,
        margin: const EdgeInsets.all(4.0),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              // SLIKA
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(
                  plant.imageUrl,
                  height: size.height * 0.13,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 8),

              // NAZIV
              TitleTextWidget(label: plant.name, maxLines: 1, fontSize: 16),
              const SizedBox(height: 4),

              // CENA
              SubtitleTextWidget(
                label: "${plant.price.toStringAsFixed(0)} RSD",
                color: AppColors.lightPrimary,
                fontWeight: FontWeight.bold,
              ),

              SubtitleTextWidget(
                label: plant.description,
                maxLines: 1, // Samo jedan red da ne pokvari dizajn
                fontSize: 12,
              ),

              const Spacer(), // Gura dugmiće na dno
              // ADMIN DUGMIĆI (Edit i Delete)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  // Kanta za brisanje - Nežno crvena/roze
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.red.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: IconButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (ctx) => AlertDialog(
                            title: const Text('Da li ste sigurni?'),
                            content: const Text(
                              'Želite li da trajno izbrišete ovaj proizvod?',
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.of(
                                  ctx,
                                ).pop(), // Samo zatvori dijalog
                                child: const Text(
                                  'Ne',
                                  style: TextStyle(color: Colors.grey),
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  // Za sada samo ispisujemo u konzolu, sutra ovde ide Firebase brisanje
                                  Navigator.of(ctx).pop();
                                  print(
                                    "Proizvod će biti obrisan iz Firebase-a sutra!",
                                  );
                                },
                                child: const Text(
                                  'Da, obriši',
                                  style: TextStyle(color: Colors.red),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                      icon: const Icon(
                        Icons.delete_outline,
                        color: Colors.redAccent,
                        size: 20,
                      ),
                    ),
                  ),

                  // Olovka za izmenu - Maslinasto zelena
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.green.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: IconButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                EditOrUploadProductScreen(plantModel: plant),
                          ),
                        );
                      },
                      icon: const Icon(
                        Icons.edit_note,
                        color: Colors.green,
                        size: 22,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
