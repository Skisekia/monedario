import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import '../../controllers/auth_controller.dart';
import '../../controllers/settings_controller.dart';
import '../../models/user_model.dart';
import '../../utils/icon_mapper.dart';
import 'modals_view.dart';

class SettingsView extends StatefulWidget {
  const SettingsView({super.key});

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  File? _profileImage;
  final picker = ImagePicker();
  bool fbConnected = false;
  bool googleConnected = false;

  Future<void> _pickImage() async {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.photo_camera),
              title: const Text('Tomar foto'),
              onTap: () async {
                final pickedFile = await picker.pickImage(source: ImageSource.camera);
                if (pickedFile != null) {
                  setState(() => _profileImage = File(pickedFile.path));
                }
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Seleccionar de galería'),
              onTap: () async {
                final pickedFile = await picker.pickImage(source: ImageSource.gallery);
                if (pickedFile != null) {
                  setState(() => _profileImage = File(pickedFile.path));
                }
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget buildProfileAvatar(String? gender) {
    final asset = getProfileIconByGender(gender);
    if (_profileImage != null) {
      return CircleAvatar(radius: 50, backgroundImage: FileImage(_profileImage!));
    }
    if (asset.endsWith('.json')) {
      return Lottie.asset(asset, width: 100, height: 100);
    }
    return CircleAvatar(radius: 100, backgroundImage: AssetImage(asset));
  }

  @override
  Widget build(BuildContext context) {
    const sectionTitleStyle = TextStyle(fontSize: 14, color: Colors.grey, fontWeight: FontWeight.bold);
    final auth = Provider.of<AuthController>(context, listen: false);
    final settingsController = SettingsController(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: FutureBuilder<UserModel?>(
          future: auth.getCurrentUserModel(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
            final user = snapshot.data!;

            fbConnected = user.provider == "facebook.com";
            googleConnected = user.provider == "google.com";

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // Avatar con botón de cámara
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      buildProfileAvatar(user.gender),
                      Positioned(
                        bottom: 0,
                        right: MediaQuery.of(context).size.width / 2 - 70,
                        child: GestureDetector(
                          onTap: _pickImage,
                          child: Container(
                            padding: const EdgeInsets.all(6),
                            decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.white),
                            child: const Icon(Icons.camera_alt, size: 18, color: Colors.purple),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(user.name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  Text(user.email, style: const TextStyle(color: Colors.grey)),
                  const SizedBox(height: 20),

                  // ===== CUENTA =====
                  Align(alignment: Alignment.centerLeft, child: Text("Cuenta", style: sectionTitleStyle)),
                  ListTile(
                    leading: const Icon(Icons.person),
                    title: const Text("Editar perfil"),
                    onTap: settingsController.goToEditProfile,
                  ),

                  const SizedBox(height: 10),

                  // ===== CONFIGURACIÓN =====
                  Align(alignment: Alignment.centerLeft, child: Text("Configuración", style: sectionTitleStyle)),
                  ListTile(
                    leading: const Icon(Icons.attach_money),
                    title: const Text("Cambiar tipo de moneda"),
                    onTap: () => showCurrencyModal(context, (selected) {
                      settingsController.changeCurrency(selected);
                    }),
                  ),
                  ListTile(
                    leading: const Icon(Icons.language),
                    title: const Text("Cambiar idioma"),
                    onTap: () => showLanguageModal(context, (selected) {
                      settingsController.changeLanguage(selected);
                    }),
                  ),
                  ListTile(
                    leading: const Icon(Icons.history),
                    title: const Text("Historial de archivos"),
                    onTap: settingsController.goToHistory,
                  ),

                  const SizedBox(height: 10),

                  // ===== CONEXIONES DE CUENTA =====
                  Align(alignment: Alignment.centerLeft, child: Text("Conexiones de cuenta", style: sectionTitleStyle)),
                  SwitchListTile(
                    value: fbConnected,
                    onChanged: (_) {},
                    title: const Text("Facebook"),
                    secondary: const Icon(Icons.facebook, color: Colors.blue),
                  ),
                  SwitchListTile(
                    value: googleConnected,
                    onChanged: (_) {},
                    title: const Text("Google"),
                    secondary: const Icon(Icons.g_mobiledata, color: Colors.red),
                  ),

                  const SizedBox(height: 20),

                  // ===== BOTÓN CERRAR SESIÓN =====
                  TextButton(
                    onPressed: () => settingsController.confirmLogout(() async {
                      await auth.signOut();
                      if (!context.mounted) return;
                      Navigator.pushNamedAndRemoveUntil(context, '/welcome', (_) => false);
                    }),
                    child: const Text("Cerrar sesión", style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
