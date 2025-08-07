class UserModel {
  final String name; // nombre del usuario
  final String email; // correo electrónico del usuario
  final String? gender; // género del usuario (opcional)
  final String? provider; // proveedor de autenticación (Google, Facebook, etc.)
  final String? profileIconAsset; // avatar personalizado
  final double? balance; // saldo del usuario
  final String? photoUrl; // URL de la foto del usuario

  UserModel({
    required this.name, // nombre del usuario
    required this.email, // correo electrónico del usuario
    this.gender, // género del usuario (opcional)
    this.provider, // proveedor de autenticación (Google, Facebook, etc.)
    this.profileIconAsset, // avatar personalizado
    this.balance, // saldo del usuario
    this.photoUrl, // URL de la foto del usuario
  });

  // Constructor para crear desde un Map (Firestore/JSON)
  // Si no se proporciona un valor, se usa un valor por defecto
  factory UserModel.fromMap(Map<String, dynamic> data) {
    return UserModel( // crea una instancia de UserModel desde un Map
      name: data['name'] ?? '', // nombre del usuario, por defecto vacío si no existe
      email: data['email'] ?? '', // correo electrónico del usuario, por defecto vacío si no existe
      gender: data['gender'], // género del usuario, puede ser nulo
      provider: data['provider'], // proveedor de autenticación (Google, Facebook, etc.)
      profileIconAsset: data['profileIconAsset'], // avatar personalizado
    balance: (data['balance'] != null)
          ? (data['balance'] is int ? (data['balance'] as int).toDouble() : data['balance'] as double)
          : 0.0,
      photoUrl: data['photoUrl'], // <-- AQUI SE LEE LA FOTO
    );
  }

  // Convierte la instancia a Map (para guardar en Firestore/JSON)
  // Si no se proporciona un valor, se usa un valor por defecto
  Map<String, dynamic> toMap() {
    return {
      'name': name, // nombre del usuario
      'email': email, // correo electrónico del usuario
      'gender': gender, // género del usuario (opcional)
      'balance': balance ?? 0.0, // saldo del usuario, por defecto 0.0 si no existe
      'provider': provider, // proveedor de autenticación (Google, Facebook, etc.)
      'profileIconAsset': profileIconAsset, // avatar personalizado
      'photoUrl': photoUrl, // <-- AQUI SE GUARDA LA FOTO
    };
  }
}
