class UserModel {
  final String name;
  final String gender; // Masculino, Femenino, Otro
  final String provider; // google, facebook, apple, email

  UserModel({
    required this.name,
    required this.gender,
    required this.provider,
  });
}

