import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../controllers/edit_profile_controller.dart';
import '../../utils/icon_mapper.dart';
import '../../controllers/auth_controller.dart';
import '../../models/user_model.dart';

class EditProfileView extends StatelessWidget {
  const EditProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => EditProfileController(context),
      child: Consumer<EditProfileController>(
        builder: (context, controller, _) {
          final auth = Provider.of<AuthController>(context, listen: false);

          return Scaffold(
            appBar: AppBar(
              title: const Text("Editar Perfil"),
              flexibleSpace: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF250E2C), Color(0xFF837AB6), Color(0xFFF6A5C0)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
              ),
            ),
            body: FutureBuilder<UserModel?>(
              future: auth.getCurrentUserModel(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }
                final user = snapshot.data!;

                Widget avatar() {
                  if (controller.pickedImage != null) {
                    return CircleAvatar(radius: 50, backgroundImage: FileImage(controller.pickedImage!));
                  }
                  final asset = getProfileIconByGender(user.gender);
                  return CircleAvatar(radius: 50, backgroundImage: AssetImage(asset));
                }

                return SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Stack(
                        children: [
                          avatar(),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: GestureDetector(
                              onTap: () {
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
                                            controller.pickImageFromCamera();
                                          },
                                        ),
                                        ListTile(
                                          leading: const Icon(Icons.photo_library),
                                          title: const Text('Seleccionar de galería'),
                                          onTap: () {
                                            Navigator.pop(context);
                                            controller.pickImageFromGallery();
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                              child: Container(
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                ),
                                padding: const EdgeInsets.all(6),
                                child: const Icon(Icons.camera_alt, color: Colors.purple),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      TextField(
                        controller: controller.nameController,
                        decoration: const InputDecoration(
                          labelText: 'Nombre de usuario',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 16),

                      DropdownButtonFormField<String>(
                        decoration: const InputDecoration(
                          labelText: 'Tipo de moneda',
                          border: OutlineInputBorder(),
                        ),
                        value: controller.currency,
                        onChanged: (value) {
                          if (value != null) controller.changeCurrency(value);
                        },
                        items: const [
                          DropdownMenuItem(value: 'MXN', child: Text('Peso Mexicano (MXN)')),
                          DropdownMenuItem(value: 'USD', child: Text('Dólar Estadounidense (USD)')),
                          DropdownMenuItem(value: 'EUR', child: Text('Euro (EUR)')),
                        ],
                      ),
                      const SizedBox(height: 16),

                      DropdownButtonFormField<String>(
                        decoration: const InputDecoration(
                          labelText: 'Idioma',
                          border: OutlineInputBorder(),
                        ),
                        value: controller.language,
                        onChanged: (value) {
                          if (value != null) controller.changeLanguage(value);
                        },
                        items: const [
                          DropdownMenuItem(value: 'es', child: Text('Español')),
                          DropdownMenuItem(value: 'en', child: Text('Inglés')),
                        ],
                      ),
                      const SizedBox(height: 24),

                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF837AB6),
                          minimumSize: const Size(double.infinity, 48),
                        ),
                        onPressed: () {
                          controller.saveProfile();
                          Navigator.pop(context);
                        },
                        child: const Text('Guardar cambios'),
                      ),
                    ],
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
