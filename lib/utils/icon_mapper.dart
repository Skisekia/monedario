String getProfileIconByGender(String? gender) {
  switch (gender?.toLowerCase()) {
    case 'masculino':
    case 'hombre':
      return 'assets/icon_chikilin.png';
    case 'femenino':
    case 'mujer':
      return 'assets/icon_polita.png';
    default:
      return 'assets/icon_cata.png';
  }
}
