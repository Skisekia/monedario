//libreria de utilidades para mapear iconos de perfil segun el genero
String getProfileIconByGender(String? gender) {
// Esta función devuelve un icono de perfil basado en el género del usuario
  switch (gender?.toLowerCase()) {
    case 'masculino':
    case 'hombre':
      return 'assets/avatar_boy.json';
    case 'femenino':
    case 'mujer':
      return 'assets/avatar_girl.json';
    default:
      return 'assets/avatar_default.json';
  }
}
