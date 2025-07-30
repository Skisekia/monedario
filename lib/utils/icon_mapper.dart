String getLottieAssetByGender(String? gender) {
  switch (gender?.toLowerCase()) {
    case 'masculino':
    case 'hombre':
      return 'assets/icon_man.json';
    case 'femenino':
    case 'mujer':
      return 'assets/icon_woman.json';
    default:
      return 'assets/icon_default.json';
  }
}
