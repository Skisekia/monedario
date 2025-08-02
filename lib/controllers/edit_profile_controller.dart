import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../controllers/auth_controller.dart';
import '../controllers/settings_controller.dart';
import '../models/user_model.dart';

class EditProfileController extends ChangeNotifier {
  final BuildContext context;

  final nameController = TextEditingController();
  String currency = 'MXN';
  String language = 'es';
  File? pickedImage;
  final picker = ImagePicker();

  EditProfileController(this.context) {
    _loadUserData();
  }

  /// Cargar datos actuales del usuario
  Future<void> _loadUserData() async {
    final auth = Provider.of<AuthController>(context, listen: false);
    final user = await auth.getCurrentUserModel();
    if (user != null) {
      nameController.text = user.name;
    }
    notifyListeners();
  }

  /// Seleccionar imagen desde cámara
  Future<void> pickImageFromCamera() async {
    final picked = await picker.pickImage(source: ImageSource.camera);
    if (picked != null) {
      pickedImage = File(picked.path);
      notifyListeners();
    }
  }

  /// Seleccionar imagen desde galería
  Future<void> pickImageFromGallery() async {
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      pickedImage = File(picked.path);
      notifyListeners();
    }
  }

  /// Cambiar moneda globalmente
  Future<void> changeCurrency(String value) async {
    currency = value;
    final settings = SettingsController(context);
    await settings.changeCurrency(value);
    notifyListeners();
  }

  /// Cambiar idioma globalmente
  Future<void> changeLanguage(String value) async {
    language = value;
    final settings = SettingsController(context);
    await settings.changeLanguage(value);
    notifyListeners();
  }

  /// Guardar cambios de perfil
  Future<void> saveProfile() async {
    debugPrint("Guardando perfil:");
    debugPrint("Nombre: ${nameController.text}");
    debugPrint("Moneda: $currency");
    debugPrint("Idioma: $language");
    debugPrint("Imagen: ${pickedImage?.path}");
    // Aquí iría la lógica para guardar en Firestore/Firebase
  }
}
