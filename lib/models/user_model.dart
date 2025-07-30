class UserModel {
  final String name;
  final String email;
  final String? gender;
  final String? provider;

  UserModel({
    required this.name,
    required this.email,
    this.gender,
    this.provider,
  });

  factory UserModel.fromMap(Map<String, dynamic> data) {
    return UserModel(
      name: data['name'] ?? '',
      email: data['email'] ?? '',
      gender: data['gender'],
      provider: data['provider'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'gender': gender,
      'provider': provider,
    };
  }
}
