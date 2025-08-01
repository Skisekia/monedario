// lib/controllers/edit_profile_controller.dart

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'auth_controller.dart';
import 'settings_controller.dart';
import '../models/user_model.dart';

class EditProfileController extends ChangeNotifier {
  final BuildContext context;
  final formKey = GlobalKey<FormState>();

  // Campos
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  // Estados UI
  String selectedGender = 'Otro';
  String selectedCountry = 'México';
  bool showPassword = false;
  bool loading = false;
  File? pickedImage;

  // Lista de países
  List<String> countryList = [
    'México', 'Estados Unidos', 'España', 'Colombia', 'Argentina', 'Otro'
  ];

  EditProfileController(this.context) {
    _loadCurrentUser();
  }

  Future<void> _loadCurrentUser() async {
    final auth = Provider.of<AuthController>(context, listen: false);
    final UserModel? user = await auth.getCurrentUserModel();
    if (user != null) {
      nameController.text = user.name;
      emailController.text = user.email;
      if ((user.gender ?? '').isNotEmpty) selectedGender = user.gender!;
      // selectedCountry se podría cargar de user.country si lo guardas
    }
    notifyListeners();
  }

  Future<void> pickImageFromCamera() async {
    final p = await ImagePicker().pickImage(source: ImageSource.camera, imageQuality: 80);
    if (p != null) {
      pickedImage = File(p.path);
      notifyListeners();
    }
  }

  Future<void> pickImageFromGallery() async {
    final p = await ImagePicker().pickImage(source: ImageSource.gallery, imageQuality: 80);
    if (p != null) {
      pickedImage = File(p.path);
      notifyListeners();
    }
  }

  void changeGender(String? g) {
    if (g != null) {
      selectedGender = g;
      notifyListeners();
    }
  }

  void changeCountry(String? c) {
    if (c != null) {
      selectedCountry = c;
      notifyListeners();
    }
  }

  void toggleShowPassword() {
    showPassword = !showPassword;
    notifyListeners();
  }

  Future<void> saveProfile() async {
    if (!formKey.currentState!.validate()) return;
    loading = true;
    notifyListeners();

    final settings = SettingsController(context);
    await settings.updateProfile(
      name: nameController.text.trim(),
      email: emailController.text.trim(),
      password: passwordController.text.trim(),
      imageFile: pickedImage,
    );

    loading = false;
    notifyListeners();
    Navigator.pop(context);
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void selectImage(BuildContext context) {
  showModalBottomSheet(
    context: context,
    builder: (_) => SafeArea(
      child: Wrap(
        children: [
          ListTile(
            leading: const Icon(Icons.photo_camera),
            title: const Text('Tomar foto'),
            onTap: () {
              Navigator.pop(context);
              pickImageFromCamera();
            },
          ),
          ListTile(
            leading: const Icon(Icons.photo_library),
            title: const Text('Seleccionar imagen'),
            onTap: () {
              Navigator.pop(context);
              pickImageFromGallery();
            },
          ),
        ],
      ),
    ),
  );
}

}
