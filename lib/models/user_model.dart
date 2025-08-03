class UserModel {
  final String name;
  final String email;
  final String? gender;
  final String? provider;
  final String? profileIconAsset; // avatar personalizado 

  UserModel({
    required this.name,
    required this.email,
    this.gender,
    this.provider,
    this.profileIconAsset, // <-- nuevo campo opcional
  });

  // Constructor para crear desde un Map (por ejemplo, Firestore o JSON)
  factory UserModel.fromMap(Map<String, dynamic> data) {
    return UserModel(
      name: data['name'] ?? '',
      email: data['email'] ?? '',
      gender: data['gender'],
      provider: data['provider'],
      profileIconAsset: data['profileIconAsset'], // <-- lee el campo si existe
    );
  }

  // Convierte la instancia a Map (para guardar en Firestore/JSON)
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'gender': gender,
      'provider': provider,
      'profileIconAsset': profileIconAsset, // <-- guarda el campo si existe
    };
  }
}
