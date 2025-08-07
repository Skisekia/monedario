import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/services.dart' show rootBundle;
import '../../controllers/auth_controller.dart';
import '../../controllers/settings_controller.dart';
import '../../models/user_model.dart';
import '../../utils/icon_mapper.dart';
import '../../utils/modals_view.dart';
// import 'package:open_file/open_file.dart'; // abrir el PDF tras descargarlo

// Solicitar permisos de almacenamiento
  Future<bool> requestStoragePermission() async {
    if (Platform.isAndroid) {
      var status = await Permission.manageExternalStorage.request();
      return status.isGranted;
    }
    return true; // iOS no necesita esto
  }

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

  /// FUNCIÓN PARA DESCARGAR PDF DESDE ASSETS
  Future<void> _downloadManualPdf(BuildContext context) async {
    try {
      // Solicita permisos de almacenamiento si es Android
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
      // 2. Lee el PDF de assets
      final byteData = await rootBundle.load('assets/prueba.pdf');

      // 3. Obtiene la carpeta de descargas
      Directory? directory;
      if (Platform.isAndroid) {
        directory = Directory('/storage/emulated/0/Download');
      } else if (Platform.isIOS) {
        directory = await getApplicationDocumentsDirectory();
      }
      if (directory == null) throw Exception('No se pudo acceder a la carpeta de descargas');

      // 4. Crea el archivo en esa carpeta
      final file = File('${directory.path}/prueba.pdf');
      await file.writeAsBytes(byteData.buffer.asUint8List());

      // 5. Notificación de éxito
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('PDF descargado en ${file.path}')),
        );
      }

      // 6. (Opcional) Abre el archivo PDF automáticamente:
      // await OpenFile.open(file.path);

    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al descargar PDF: $e')),
        );
      }
    }
  }

  Widget buildProfileAvatar(String? gender) {
    final asset = getProfileIconAssetPath(gender);
    if (_profileImage != null) {
      return CircleAvatar(radius: 90, backgroundImage: FileImage(_profileImage!));
    }
    if (asset.endsWith('.json')) {
      return Lottie.asset(asset, width: 180, height: 180);
    }
    return CircleAvatar(radius: 90, backgroundImage: AssetImage(asset));
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
                // Avatar
                Stack(
                  alignment: Alignment.center,
                  children: [
                    buildProfileAvatar(user.gender),
                    Positioned(
                      bottom: 8,
                      left: 0,
                      right: 0,
                      child: GestureDetector(
                        onTap: _pickImage,
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
