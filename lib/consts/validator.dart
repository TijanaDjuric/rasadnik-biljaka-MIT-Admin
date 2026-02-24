class MyValidators {
  // --- VALIDATORI ZA PROIZVODE (ADMIN) ---

  static String? uploadProdTitleValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Molimo unesite naziv biljke';
    }
    if (value.length < 3 || value.length > 50) {
      return 'Naziv mora imati između 3 i 50 karaktera';
    }
    return null;
  }

  static String? uploadProdDescriptionValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Molimo unesite opis proizvoda';
    }
    if (value.length < 5) {
      return 'Opis je prekratak (minimum 5 karaktera)';
    }
    return null;
  }

  static String? uploadProdPriceValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Unesite cenu';
    }
    // Provera da li je unet ispravan broj (ne dopušta slova)
    if (double.tryParse(value) == null) {
      return 'Unesite validan broj (npr. 1200)';
    }
    return null;
  }

  // --- TVOJI POSTOJEĆI VALIDATORI ZA KORISNIKE ---

  static String? displayNameValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Ime i prezime ne mogu biti prazni';
    }
    if (value.length < 3 || value.length > 30) {
      return 'Ime mora imati između 3 i 30 karaktera';
    }
    return null;
  }

  static String? emailValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Unesite email adresu';
    }
    if (!RegExp(r'^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$')
        .hasMatch(value)) {
      return 'Unesite ispravnu email adresu';
    }
    return null;
  }

  static String? passwordValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Unesite lozinku';
    }
    if (value.length < 6) {
      return 'Lozinka mora imati najmanje 6 karaktera';
    }
    return null;
  }

  static String? repeatPasswordValidator({
    required String? value,
    required String password,
  }) {
    if (value == null || value.isEmpty) {
      return 'Ponovite lozinku';
    }
    if (value != password) {
      return 'Lozinke se ne poklapaju';
    }
    return null;
  }
}