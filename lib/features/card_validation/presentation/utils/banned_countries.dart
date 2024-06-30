class BannedCountries {
  static const List<String> countries = ['Aruba', 'Benin'];

  static bool isCountryBanned(String country) {
    return countries.contains(country);
  }
}

///Please note that I cannot put this part into the
///actual UI of the application because that would defeat the purpose -
///having the user being able to configure themselves that would cause not work for this.