import 'package:flutter/material.dart';
import 'package:skriptarnica_admin/services/assets_manager.dart';
import 'package:skriptarnica_admin/widgets/subtitle_text.dart';
import 'package:skriptarnica_admin/widgets/title_text.dart';

class MyAppFunctions {
  /// Dijalog za greške / upozorenja
  static Future<void> showErrorOrWarningDialog({
    required BuildContext context,
    required String subtitle,
    bool isError = true,
  }) async {
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                isError
                    ? "${AssetsManager.imagePath}/icons/error.png"
                    : "${AssetsManager.imagePath}/icons/info.png",
                height: 60,
                width: 60,
              ),
              const SizedBox(height: 16),
              SubtitleTextWidget(
                label: subtitle,
              ),
              const SizedBox(height: 20),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const SubtitleTextWidget(
                  label: "U redu",
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  /// Dijalog za biranje slike (register / profil)
  static Future<void> imagePickerDialog({
    required BuildContext context,
    required Function cameraFCT,
    required Function galleryFCT,
    required Function removeFCT,
  }) async {
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          title: const Center(
            child: TitleTextWidget(
              label: "Izaberite opciju",
            ),
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: [
                TextButton.icon(
                  onPressed: () {
                    cameraFCT();
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.camera_alt),
                  label: const Text("Kamera"),
                ),
                TextButton.icon(
                  onPressed: () {
                    galleryFCT(); 
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.photo_library),
                  label: const Text("Galerija"),
                ),
                TextButton.icon(
                  onPressed: () {
                    removeFCT();
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.delete_outline),
                  label: const Text("Ukloni sliku"),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
