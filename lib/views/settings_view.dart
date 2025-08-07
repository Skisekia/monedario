import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/services.dart' show rootBundle;

import '../../controllers/auth_controller.dart';
import '../../controllers/settings_controller.dart';
import '../../models/user_model.dart';
import '../../utils/icon_mapper.dart';
import '../../utils/modals_view.dart';

Future<bool> requestStoragePermission() async {
  if (Platform.isAndroid) {
    var status = await Permission.manageExternalStorage.request();
    return status.isGranted;
  }
  return true;
}

class SettingsView extends StatefulWidget {
  const SettingsView({super.key});

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  File? _profileImage;
  bool _uploading = false;

  final picker = ImagePicker();
  bool fbConnected = false;
  bool googleConnected = false;

  // ==== FUNCIONES PARA LA FOTO DE PERFIL ====

  Future<void> _showImagePickerDialog() async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Seleccionar foto de perfil'),
        content: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
              icon: const Icon(Icons.photo_camera, size: 34, color: Colors.purple),
              onPressed: () async {
                Navigator.of(context).pop();
                final pickedFile = await picker.pickImage(source: ImageSource.camera, imageQuality: 75);
                if (pickedFile != null) {
                  await _saveProfileImage(File(pickedFile.path));
                }
              },
              tooltip: 'Tomar foto',
            ),
            IconButton(
              icon: const Icon(Icons.photo_library, size: 34, color: Colors.purple),
              onPressed: () async {
                Navigator.of(context).pop();
                final pickedFile = await picker.pickImage(source: ImageSource.gallery, imageQuality: 75);
                if (pickedFile != null) {
                  await _saveProfileImage(File(pickedFile.path));
                }
              },
              tooltip: 'Seleccionar de galería',
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _saveProfileImage(File image) async {
    setState(() => _uploading = true);
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) throw Exception("No hay usuario autenticado.");

      // Sube la imagen a Storage
      final ref = FirebaseStorage.instance.ref().child('profile_images/${user.uid}.jpg');
      await ref.putFile(image);

      // Obtiene la URL de descarga
      final imageUrl = await ref.getDownloadURL();

      // Actualiza Firestore
      await FirebaseFirestore.instance.collection('users').doc(user.uid).update({'photoUrl': imageUrl});

      setState(() {
        _profileImage = image;
        _uploading = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Foto de perfil actualizada')),
        );
      }
    } catch (e) {
      setState(() => _uploading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al guardar la foto: $e')),
        );
      }
    }
  }

  Widget buildProfileAvatar(String? gender, String? photoUrl) {
    if (_profileImage != null) {
      return CircleAvatar(radius: 90, backgroundImage: FileImage(_profileImage!));
    }
    if (photoUrl != null && photoUrl.isNotEmpty) {
      return CircleAvatar(radius: 90, backgroundImage: NetworkImage(photoUrl));
    }
    final asset = getProfileIconAssetPath(gender);
    if (asset.endsWith('.json')) {
      return Lottie.asset(asset, width: 180, height: 180);
    }
    return CircleAvatar(radius: 90, backgroundImage: AssetImage(asset));
  }

  /// FUNCIÓN PARA DESCARGAR PDF DESDE ASSETS (igual que la tuya)
  Future<void> _downloadManualPdf(BuildContext context) async {
    try {
      if (Platform.isAndroid) {
        bool granted = await requestStoragePermission();
        if (!granted) {
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Permiso denegado para guardar archivos.')),
            );
          }
          return;
        }
      }
      final byteData = await rootBundle.load('assets/prueba.pdf');
      Directory? directory;
      if (Platform.isAndroid) {
        directory = Directory('/storage/emulated/0/Download');
      } else if (Platform.isIOS) {
        directory = await getApplicationDocumentsDirectory();
      }
      if (directory == null) throw Exception('No se pudo acceder a la carpeta de descargas');
      final file = File('${directory.path}/prueba.pdf');
      await file.writeAsBytes(byteData.buffer.asUint8List());
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('PDF descargado en ${file.path}')),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al descargar PDF: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    const sectionTitleStyle = TextStyle(fontSize: 13, color: Colors.grey, fontWeight: FontWeight.bold);
    const iconColor = Colors.purple;

    final auth = Provider.of<AuthController>(context, listen: false);
    final settingsController = SettingsController(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(36),
        child: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          toolbarHeight: 36,
          automaticallyImplyLeading: false,
          titleSpacing: 0,
          actions: [
            IconButton(
              icon: const Icon(Icons.logout, color: iconColor),
              tooltip: "Cerrar sesión",
              onPressed: () => settingsController.confirmLogout(() async {
                await auth.signOut(
                  context,
                  mounted: () => mounted,
                );
                if (!mounted) return;
                Navigator.pushNamedAndRemoveUntil(context, '/welcome', (_) => false);
              }),
            ),
          ],
        ),
      ),
      body: FutureBuilder<UserModel?>(
        future: auth.getCurrentUserModel(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
          final user = snapshot.data!;

          fbConnected = user.provider == "facebook.com";
          googleConnected = user.provider == "google.com";

          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 10),
                // ===== AVATAR (centrado, editable, animación si sube) =====
                Stack(
                  alignment: Alignment.center,
                  children: [
                    buildProfileAvatar(user.gender, user.photoUrl),
                    if (_uploading)
                      Positioned.fill(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.black26,
                            shape: BoxShape.circle,
                          ),
                          child: const Center(child: CircularProgressIndicator()),
                        ),
                      ),
                    Positioned(
                      bottom: 8,
                      left: 0,
                      right: 0,
                      child: GestureDetector(
                        onTap: _showImagePickerDialog,
                        child: Container(
                          padding: const EdgeInsets.all(7),
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 6,
                              ),
                            ],
                          ),
                          child: const Icon(Icons.camera_alt, size: 22, color: iconColor),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                Text(user.name, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
                Text(user.email, style: const TextStyle(color: Colors.grey, fontSize: 13)),
                const SizedBox(height: 12),

                // ===== CUENTA =====
                Align(alignment: Alignment.centerLeft, child: Text("Cuenta", style: sectionTitleStyle)),
                ListTile(
                  dense: true,
                  minVerticalPadding: 0,
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.edit, color: iconColor, size: 21),
                  title: const Text("Editar perfil", style: TextStyle(fontSize: 15)),
                  onTap: () => Navigator.pushNamed(context, '/edit_profile_view'),
                ),
                ListTile(
                  dense: true,
                  minVerticalPadding: 0,
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.group_add, color: iconColor, size: 21),
                  title: const Text("Vincular con otros usuarios", style: TextStyle(fontSize: 15)),
                  onTap: () {
                    showFriendLinkModal(context);
                  },
                ),
                const SizedBox(height: 5),

                // ===== CONFIGURACIÓN =====
                Align(alignment: Alignment.centerLeft, child: Text("Configuración", style: sectionTitleStyle)),

                // BOTÓN DESCARGAR MANUAL
                ListTile(
                  dense: true,
                  minVerticalPadding: 0,
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.download, color: iconColor, size: 21),
                  title: const Text("Descargar manual", style: TextStyle(fontSize: 15)),
                  onTap: () => _downloadManualPdf(context),
                ),

                ListTile(
                  dense: true,
                  minVerticalPadding: 0,
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.attach_money, color: iconColor, size: 21),
                  title: const Text("Cambiar tipo de moneda", style: TextStyle(fontSize: 15)),
                  onTap: () => showCurrencyModal(context, (selected) {
                    settingsController.changeCurrency(selected);
                  }),
                ),
                ListTile(
                  dense: true,
                  minVerticalPadding: 0,
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.language, color: iconColor, size: 21),
                  title: const Text("Cambiar idioma", style: TextStyle(fontSize: 15)),
                  onTap: () => showLanguageModal(context, (selected) {
                    settingsController.changeLanguage(selected);
                  }),
                ),
                ListTile(
                  dense: true,
                  minVerticalPadding: 0,
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.history, color: iconColor, size: 21),
                  title: const Text("Historial de archivos", style: TextStyle(fontSize: 15)),
                  onTap: settingsController.goToHistory,
                ),
                const SizedBox(height: 5),

                // ===== CONEXIONES DE CUENTA =====
                Align(alignment: Alignment.centerLeft, child: Text("Conexiones de cuenta", style: sectionTitleStyle)),
                SwitchListTile(
                  dense: true,
                  contentPadding: EdgeInsets.zero,
                  value: fbConnected,
                  onChanged: (_) {},
                  title: const Text("Facebook", style: TextStyle(fontSize: 15)),
                  secondary: const Icon(Icons.facebook, color: Colors.blue, size: 22),
                ),
                SwitchListTile(
                  dense: true,
                  contentPadding: EdgeInsets.zero,
                  value: googleConnected,
                  onChanged: (_) {},
                  title: const Text("Google", style: TextStyle(fontSize: 15)),
                  secondary: const Icon(Icons.g_mobiledata, color: Colors.red, size: 22),
                ),
                const SizedBox(height: 5),
              ],
            ),
          );
        },
      ),
    );
  }
}
