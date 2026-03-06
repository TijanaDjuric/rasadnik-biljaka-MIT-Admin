import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:skriptarnica_admin/consts/validator.dart';
import 'package:skriptarnica_admin/models/plant_model.dart';
import 'package:skriptarnica_admin/services/cloudinary_service.dart'; 
import 'package:skriptarnica_admin/services/my_app_functions.dart';
import 'package:skriptarnica_admin/widgets/title_text.dart';
import 'package:uuid/uuid.dart';

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
  String productImageUrl = "";
  bool isLoading = false;

  bool get isEditing => widget.plantModel != null;

  final List<String> _categoriesList = ["indoor", "garden", "trees", "succulents"];

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.plantModel?.name ?? "");
    _priceController = TextEditingController(text: widget.plantModel?.price.toString() ?? "");
    _descriptionController = TextEditingController(text: widget.plantModel?.description ?? "");
    _stockController = TextEditingController(text: widget.plantModel?.stock.toString() ?? "");

    if (widget.plantModel != null && _categoriesList.contains(widget.plantModel!.category)) {
      _categoryValue = widget.plantModel!.category;
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

  void clearForm() {
    _titleController.clear();
    _priceController.clear();
    _descriptionController.clear();
    _stockController.clear();
    setState(() {
      _pickedImage = null;
      _categoryValue = null;
    });
  }

  // --- LOGIKA ZA DODAVANJE (UPLOAD) ---
  Future<void> _processUpload() async {
    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();

    if (_pickedImage == null) {
      _showWarning("Molimo izaberite sliku biljke");
      return;
    }
    if (_categoryValue == null) {
      _showWarning("Molimo izaberite kategoriju");
      return;
    }

    if (isValid) {
      try {
        setState(() => isLoading = true);

        // 1. Upload na Cloudinary
        productImageUrl = await CloudinaryService.uploadImage(File(_pickedImage!.path));

        // 2. Slanje u Firestore
        final productId = const Uuid().v4();
        await FirebaseFirestore.instance.collection("plants").doc(productId).set({
          'id': productId,
          'name': _titleController.text,
          'price': double.parse(_priceController.text),
          'imageUrl': productImageUrl,
          'category': _categoryValue,
          'description': _descriptionController.text,
          'stock': int.parse(_stockController.text),
          'isAvailable': true,
          'createdAt': Timestamp.now(),
        });

        Fluttertoast.showToast(msg: "Biljka je dodata u zeleni raj!");
        if (!mounted) return;
        _askToClearForm();
      } catch (error) {
        _showError(error.toString());
      } finally {
        setState(() => isLoading = false);
      }
    }
  }

  // --- LOGIKA ZA IZMENU (EDIT) ---
  Future<void> _processEdit() async {
    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();

    // Provera slike: mora postojati ili nova izabrana ili stara sa mreže
    if (_pickedImage == null && widget.plantModel?.imageUrl == null) {
      await MyAppFunctions.showErrorOrWarningDialog(
        context: context,
        subtitle: "Molimo vas da izaberete sliku za biljku",
        fct: () {},
      );
      return;
    }

    if (isValid) {
      try {
        setState(() {
          isLoading = true; // Kod tebe se zove isLoading bez donje crte
        });

        // 1. Ako je admin izabrao novu sliku, šaljemo na Cloudinary
        if (_pickedImage != null) {
          productImageUrl = await CloudinaryService.uploadImage(File(_pickedImage!.path));
        }

        // 2. Određujemo koja slika ide u bazu (nova ili postojeća)
        final imageToSave = productImageUrl.isNotEmpty 
            ? productImageUrl 
            : (widget.plantModel?.imageUrl ?? "");

        // 3. UPDATE u Firebase-u
        await FirebaseFirestore.instance
            .collection("plants") 
            .doc(widget.plantModel!.id) 
            .update({
          'id': widget.plantModel!.id,
          'name': _titleController.text,
          'price': double.parse(_priceController.text),
          'imageUrl': imageToSave,
          'category': _categoryValue,
          'description': _descriptionController.text,
          'stock': int.parse(_stockController.text),
          'createdAt': widget.plantModel!.createdAt, // Zadržavamo originalno vreme kreiranja
        });

        Fluttertoast.showToast(
          msg: "Podaci o biljci su uspešno izmenjeni",
          textColor: Colors.white,
        );

        if (!mounted) return;

       // Umesto dijaloga za čišćenje forme, samo se vraćamo nazad
        Navigator.pop(context);
      } on FirebaseException catch (error) {
        await MyAppFunctions.showErrorOrWarningDialog(
          context: context,
          subtitle: error.message.toString(),
          fct: () {},
        );
      } catch (error) {
        await MyAppFunctions.showErrorOrWarningDialog(
          context: context,
          subtitle: error.toString(),
          fct: () {},
        );
      } finally {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  // --- POMOĆNE FUNKCIJE ---
  void _showError(String message) {
    MyAppFunctions.showErrorOrWarningDialog(context: context, subtitle: message, fct: () {});
  }

  void _showWarning(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  void _askToClearForm() {
    MyAppFunctions.showErrorOrWarningDialog(
      isError: false,
      context: context, 
      subtitle: "Očistiti formu?", 
      fct: () => clearForm()
    );
  }

 Future<void> _localImagePicker() async {
    final ImagePicker picker = ImagePicker();
    await MyAppFunctions.imagePickerDialog(
      context: context,
      cameraFCT: () async {
        final XFile? image = await picker.pickImage(source: ImageSource.camera);
        if (image != null) {
          setState(() {
            _pickedImage = image;
          });
        }
      },
      galleryFCT: () async {
        final XFile? image = await picker.pickImage(source: ImageSource.gallery);
        if (image != null) {
          setState(() {
            _pickedImage = image;
          });
        }
      },
      removeFCT: () {
        setState(() {
          _pickedImage = null;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF002117) : const Color(0xFFF1F8E9),
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: TitleTextWidget(
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
                    // --- IMAGE PICKER ---
                    GestureDetector(
                      onTap: _localImagePicker,
                      child: Container(
                        height: size.width * 0.5,
                        width: size.width * 0.5,
                        decoration: BoxDecoration(
                          color: isDark ? const Color(0xFF00382A) : Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.green.withOpacity(0.3)),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: _pickedImage != null
                              ? Image.file(File(_pickedImage!.path), fit: BoxFit.cover)
                              : (isEditing)
                                  ? Image.network(widget.plantModel!.imageUrl, fit: BoxFit.cover)
                                  : const Icon(Icons.add_a_photo_outlined, size: 50, color: Colors.green),
                        ),
                      ),
                    ),
                    const SizedBox(height: 25),

                    // --- DROP DOWN ---
                    DropdownButtonFormField<String>(
                      value: _categoryValue,
                      items: _categoriesList.map((cat) => DropdownMenuItem(value: cat, child: Text(cat))).toList(),
                      onChanged: (v) => setState(() => _categoryValue = v),
                      decoration: const InputDecoration(labelText: "Kategorija"),
                    ),
                    const SizedBox(height: 15),

                    // --- TEXT FIELDS ---
                    TextFormField(
                      controller: _titleController,
                      validator: (value) => MyValidators.uploadProdTitleValidator(value),
                      decoration: const InputDecoration(hintText: 'Naziv biljke'),
                    ),
                    const SizedBox(height: 15),
                    TextFormField(
                      controller: _priceController,
                      keyboardType: TextInputType.number,
                      validator: (value) => MyValidators.uploadProdPriceValidator(value),
                      decoration: const InputDecoration(hintText: 'Cena (RSD)', prefixText: "RSD "),
                    ),
                    const SizedBox(height: 15),
                    TextFormField(
                      controller: _stockController,
                      keyboardType: TextInputType.number,
                      validator: (value) => MyValidators.uploadProdStockValidator(value),
                      decoration: const InputDecoration(hintText: 'Količina na stanju'),
                    ),
                    const SizedBox(height: 15),
                    TextFormField(
                      controller: _descriptionController,
                      maxLines: 5,
                      validator: (value) => MyValidators.uploadProdDescriptionValidator(value),
                      decoration: const InputDecoration(labelText: "Opis proizvoda"),
                    ),
                    const SizedBox(height: 30),

                    // --- DUGME ---
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green.shade700,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        onPressed: isEditing ? _processEdit : _processUpload,
                        icon: Icon(isEditing ? Icons.check : Icons.upload, color: Colors.white),
                        label: Text(
                          isEditing ? "SAČUVAJ IZMENE" : "DODAJ U ZELENI RAJ",
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
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