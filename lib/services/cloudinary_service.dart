import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class CloudinaryService {
  // Ostavi svoj cloudName i uploadPreset koji si dobila na vezbama
  static const String cloudName = "djpma21zs"; 
  static const String uploadPreset = "flutter_unsigned";

  static Future<String> uploadImage(File file) async {
    final uri =
        Uri.parse("https://api.cloudinary.com/v1_1/$cloudName/image/upload");

    final request = http.MultipartRequest("POST", uri)
      ..fields["upload_preset"] = uploadPreset
      // IZMENA: Naziv foldera gde će se čuvati slike biljaka
      ..fields["folder"] = "rasadnik_biljaka" 
      ..files.add(await http.MultipartFile.fromPath("file", file.path));

    final response = await request.send();
    final body = await response.stream.bytesToString();

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception("Cloudinary upload nije uspeo: $body");
    }

    final data = jsonDecode(body) as Map<String, dynamic>;
    
    // Vraća direktan link ka slici koji posle čuvamo u Firestore-u
    return data["secure_url"] as String;
  }
}