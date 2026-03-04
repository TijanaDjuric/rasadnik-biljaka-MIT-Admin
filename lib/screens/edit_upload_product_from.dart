import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:skriptarnica_admin/consts/validator.dart';
import 'package:skriptarnica_admin/models/plant_model.dart';
import 'package:skriptarnica_admin/widgets/title_text.dart';

class EditOrUploadProductScreen extends StatefulWidget {
  static const routeName = '/EditOrUploadProductScreen';
  final Plant? plantModel;

  const EditOrUploadProductScreen({super.key, this.plantModel});

  @override
  State<EditOrUploadProductScreen> createState() =>
      _EditOrUploadProductScreenState();
}

class _EditOrUploadProductScreenState extends State<EditOrUploadProductScreen> {
  final _formKey = GlobalKey<FormState>();
  XFile? _pickedImage;
  late TextEditingController _titleController,
      _priceController,
      _descriptionController,
      _stockController;
  String? _categoryValue;
  bool get isEditing => widget.plantModel != null;
  bool isLoading = false; // Dodato za Firebase proces

  final List<String> _categoriesList = [
    "indoor",
    "garden",
    "trees",
    "succulents",
  ];

  @override
  void initState() {
    super.initState(); // Uvek prvo pozovi super

    // 1. Inicijalizacija tekstualnih kontrolera
    // Ako je plantModel null (novi proizvod), biće prazan string ""
    _titleController = TextEditingController(
      text: widget.plantModel?.name ?? "",
    );
    _priceController = TextEditingController(
      text: widget.plantModel?.price.toString() ?? "",
    );
    _descriptionController = TextEditingController(
      text: widget.plantModel?.description ?? "",
    );
    _stockController = TextEditingController(
      text: widget.plantModel?.stock.toString() ?? "",
    );

    // 2. Inicijalizacija kategorije uz "osigurač"
    // Proveravamo da li kategorija iz modela uopšte postoji u našoj listi _categoriesList
    if (widget.plantModel != null && widget.plantModel!.category != null) {
      if (_categoriesList.contains(widget.plantModel!.category)) {
        _categoryValue = widget.plantModel!.category;
      } else {
        // Ako se ID ne poklapa (npr. u bazi piše nešto deseto), stavljamo null
        // da aplikacija ne bi pukla (Red Screen)
        _categoryValue = null;
        print(
          "Upozorenje: Kategorija '${widget.plantModel!.category}' nije pronađena!",
        );
      }
    } else {
      _categoryValue = null; // Za novi proizvod je uvek prazno na početku
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _priceController.dispose();
    _descriptionController.dispose();
    _stockController.dispose();
    super.dispose();
  }

  // Funkcija za biranje slike
  Future<void> _localImagePicker() async {
    final ImagePicker picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _pickedImage = image;
      });
    }
  }

  // Glavna funkcija za slanje podataka
  Future<void> _uploadProduct() async {
    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();

    if (_pickedImage == null && !isEditing) {
      // Alarm ako nema slike kod novog proizvoda
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Molimo izaberite sliku biljke")),
      );
      return;
    }

    if (isValid) {
      _formKey.currentState!.save();
      setState(() => isLoading = true);

      try {
        // OVDE ĆE IĆI FIREBASE KOD
        print("Slanje u bazu...");
        await Future.delayed(const Duration(seconds: 2)); // Simulacija
        if (mounted) Navigator.pop(context);
      } catch (error) {
        print("Greška: $error");
      } finally {
        setState(() => isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark
          ? const Color(0xFF002117)
          : const Color(0xFFF1F8E9),
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: isDark
            ? const Color(0xFF002117)
            : const Color(0xFFF1F8E9),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(
            Icons.arrow_back_ios_new,
            color: isDark ? Colors.white : Colors.black,
          ),
        ),
        title: TitleTextWidget(
          // SADA ĆE OVO RADITI ISPRAVNO:
          label: isEditing ? "Izmeni Biljku" : "Nova Biljka",
          color: isDark ? Colors.white : Colors.black,
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.green))
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    // --- PRIKAZ SLIKE ---
                    GestureDetector(
                      onTap: _localImagePicker,
                      child: Container(
                        height: size.width * 0.6,
                        width: size.width * 0.6,
                        decoration: BoxDecoration(
                          color: isDark
                              ? const Color(0xFF00382A)
                              : Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: Colors.green.withOpacity(0.3),
                          ),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: _pickedImage != null
                              ? Image.file(
                                  File(_pickedImage!.path),
                                  fit: BoxFit.cover,
                                )
                              : (isEditing &&
                                    widget.plantModel!.imageUrl.isNotEmpty)
                              ? (widget.plantModel!.imageUrl.startsWith(
                                      'assets',
                                    )
                                    ? Image.asset(
                                        widget.plantModel!.imageUrl,
                                        fit: BoxFit.cover,
                                        errorBuilder:
                                            (context, error, stackTrace) =>
                                                const Icon(
                                                  Icons.broken_image,
                                                  size: 50,
                                                ),
                                      )
                                    : Image.network(
                                        widget.plantModel!.imageUrl,
                                        fit: BoxFit.cover,
                                        errorBuilder:
                                            (context, error, stackTrace) =>
                                                const Icon(
                                                  Icons.broken_image,
                                                  size: 50,
                                                ),
                                      ))
                              : const Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.add_a_photo_outlined,
                                      size: 50,
                                      color: Colors.green,
                                    ),
                                    SizedBox(height: 10),
                                    Text(
                                      "Dodaj sliku",
                                      style: TextStyle(color: Colors.green),
                                    ),
                                  ],
                                ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 25),

                    // --- KATEGORIJA ---
                    DropdownButtonFormField<String>(
                      value: _categoryValue,
                      items: _categoriesList.map((String categoryId) {
                        // Ovde mapiramo ID-ove u lepša imena samo za prikaz
                        String displayName = "";
                        switch (categoryId) {
                          case "indoor":
                            displayName = "Sobne biljke";
                            break;
                          case "garden":
                            displayName = "Baštenske biljke";
                            break;
                          case "succulents":
                            displayName = "Sukulenti";
                            break;
                          case "trees":
                            displayName = "Drveće";
                            break;
                          default:
                            displayName = categoryId;
                        }
                        return DropdownMenuItem(
                          value: categoryId,
                          child: Text(displayName),
                        );
                      }).toList(),
                      onChanged: (v) => setState(() => _categoryValue = v),
                      decoration: const InputDecoration(
                        labelText: "Kategorija",
                      ),
                    ),
                    const SizedBox(height: 15),

                    // --- NAZIV ---
                    TextFormField(
                      controller: _titleController,
                      key: const ValueKey('Title'),
                      validator: (value) =>
                          MyValidators.uploadProdTitleValidator(value),
                      textInputAction: TextInputAction.next,
                      decoration: const InputDecoration(
                        hintText: 'Naziv biljke (npr. Fikus)',
                        filled: true,
                      ),
                    ),
                    const SizedBox(height: 15),

                    // --- CENA ---
                    TextFormField(
                      controller: _priceController,
                      key: const ValueKey('Price'),
                      keyboardType: TextInputType.number,
                      validator: (value) =>
                          MyValidators.uploadProdPriceValidator(value),
                      textInputAction: TextInputAction.next,
                      decoration: const InputDecoration(
                        hintText: 'Cena (RSD)',
                        filled: true,
                        prefixText: "RSD ",
                      ),
                    ),
                    const SizedBox(height: 15),

                    // --- KOLIČINA NA STANJU ---
                    TextFormField(
                      controller: _stockController,
                      key: const ValueKey('Stock'),
                      keyboardType: TextInputType.number,
                      validator: (value) =>
                          MyValidators.uploadProdStockValidator(value),
                      textInputAction: TextInputAction.next,
                      decoration: const InputDecoration(
                        hintText: 'Količina na stanju',
                        filled: true,
                        prefixIcon: Icon(Icons.inventory_2_outlined),
                      ),
                    ),
                    const SizedBox(height: 15),
                    
                    // --- OPIS ---
                    TextFormField(
                      controller: _descriptionController,
                      maxLines: 5,
                      maxLength: 500,
                      validator: (value) =>
                          MyValidators.uploadProdDescriptionValidator(value),
                      decoration: const InputDecoration(
                        labelText: "Opis proizvoda i održavanje",
                        alignLabelWithHint: true,
                      ),
                    ),
                    const SizedBox(height: 30),

                    // --- DUGME ---
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green.shade700,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: _uploadProduct,
                        icon: Icon(
                          isEditing ? Icons.check : Icons.upload,
                          color: Colors.white,
                        ),
                        label: Text(
                          isEditing ? "SAČUVAJ IZMENE" : "DODAJ U ZELENI RAJ",
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
