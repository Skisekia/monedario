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

  @override
  void initState() {
    super.initState();
    _loadProviderStatus();
  }

  void _loadProviderStatus() async {
    final auth = Provider.of<AuthController>(context, listen: false);
    final user = await auth.getCurrentUserModel();
    if (user != null) {
      setState(() {
        fbConnected = user.provider == "facebook.com";
        googleConnected = user.provider == "google.com";
      });
    }
  }

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

  @override
  Widget build(BuildContext context) {
    const sectionTitleStyle =
        TextStyle(fontSize: 14, color: Colors.grey, fontWeight: FontWeight.bold);

    final auth = Provider.of<AuthController>(context, listen: false);
    final controller = SettingsController(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: FutureBuilder<UserModel?>(
          future: auth.getCurrentUserModel(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }
            final user = snapshot.data!;

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // ===== Avatar con animación Lottie o foto subida =====
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        width: 110,
                        height: 110,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                        ),
                        child: ClipOval(
                          child: _profileImage != null
                              ? Image.file(_profileImage!, fit: BoxFit.cover)
                              : Lottie.asset(
                                  getProfileIconByGender(user.gender),
                                  fit: BoxFit.cover,
                                ),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: MediaQuery.of(context).size.width / 2 - 70,
                        child: GestureDetector(
                          onTap: _pickImage,
                          child: Container(
                            padding: const EdgeInsets.all(6),
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white,
                            ),
                            child: const Icon(Icons.camera_alt,
                                size: 18, color: Colors.purple),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(user.name,
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold)),
                  Text(user.email, style: const TextStyle(color: Colors.grey)),

                  const SizedBox(height: 20),

                  // ===== Sección Cuenta =====
                  Align(
                      alignment: Alignment.centerLeft,
                      child: Text("Cuenta", style: sectionTitleStyle)),
                  ListTile(
                    leading: const Icon(Icons.person),
                    title: const Text("Editar perfil"),
                    onTap: controller.goToEditProfile,
                  ),

                  const SizedBox(height: 10),

                  // ===== Configuración =====
                  Align(
                      alignment: Alignment.centerLeft,
                      child: Text("Configuración", style: sectionTitleStyle)),
                  ListTile(
                    leading: const Icon(Icons.attach_money),
                    title: const Text("Cambiar tipo de moneda"),
                    onTap: () => showCurrencyModal(context, (selected) {
                      controller.changeCurrency(selected);
                    }),
                  ),
                  ListTile(
                    leading: const Icon(Icons.language),
                    title: const Text("Cambiar idioma"),
                    onTap: () => showLanguageModal(context, (selected) {
                      controller.changeLanguage(selected);
                    }),
                  ),
                  ListTile(
                    leading: const Icon(Icons.history),
                    title: const Text("Historial de archivos"),
                    onTap: controller.goToHistory,
                  ),

                  const SizedBox(height: 10),

                  // ===== Redes sociales =====
                  Align(
                      alignment: Alignment.centerLeft,
                      child: Text("Conexiones de cuenta",
                          style: sectionTitleStyle)),
                  SwitchListTile(
                    value: fbConnected,
                    onChanged: (val) {
                      setState(() => fbConnected = val);
                      controller.toggleFacebook(val);
                    },
                    title: const Text("Facebook"),
                    secondary:
                        const Icon(Icons.facebook, color: Colors.blue),
                  ),
                  SwitchListTile(
                    value: googleConnected,
                    onChanged: (val) {
                      setState(() => googleConnected = val);
                      controller.toggleGoogle(val);
                    },
                    title: const Text("Google"),
                    secondary: const Icon(Icons.g_mobiledata, color: Colors.red),
                  ),

                  ListTile(
                    leading: const Icon(Icons.share),
                    title: const Text("Síguenos en nuestras redes"),
                    onTap: controller.goToSocialLinks,
                  ),

                  const SizedBox(height: 10),

                  // ===== Ayuda y soporte =====
                  ListTile(
                    leading: const Icon(Icons.help_outline),
                    title: const Text("Ayuda y soporte"),
                    onTap: controller.goToHelp,
                  ),

                  const SizedBox(height: 20),

                  // ===== Botón cerrar sesión =====
                  TextButton(
                    onPressed: () => controller.confirmLogout(() async {
                      await auth.signOut();
                      if (!context.mounted) return;
                      Navigator.pushNamedAndRemoveUntil(
                          context, '/welcome', (_) => false);
                    }),
                    child: const Text(
                      "Cerrar sesión",
                      style: TextStyle(
                          color: Colors.red, fontWeight: FontWeight.bold),
                    ),
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
