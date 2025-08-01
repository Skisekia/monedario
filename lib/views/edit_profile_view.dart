// edit_profile_view.dart

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/edit_profile_controller.dart';
import '../utils/icon_mapper.dart';

class EditProfileView extends StatelessWidget {
  const EditProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => EditProfileController(context),
      child: Consumer<EditProfileController>(
        builder: (context, ctrl, _) {
          const primaryColor = Color(0xFF78A3EB);

          return Scaffold(
            backgroundColor: Colors.white,
            body: SafeArea(
              child: Form(
                key: ctrl.formKey,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      // ===== HEADER =====
                      Stack(
                        children: [
                          ClipPath(
                            clipper: _CurveClipper(),
                            child: Container(height: 280, color: primaryColor),
                          ),

                          // Botón back
                          Positioned(
                            top: 12,
                            left: 12,
                            child: IconButton(
                              icon: const Icon(Icons.arrow_back, color: Colors.white),
                              onPressed: () => Navigator.pop(context),
                            ),
                          ),

                          // Avatar y botón
                          Container(
                            height: 280,
                            alignment: Alignment.center,
                            padding: const EdgeInsets.only(top: 40),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ClipOval(
                                  child: Container(
                                    width: 140,
                                    height: 140,
                                    color: Colors.white,
                                    child: ctrl.pickedImage != null
                                        ? Image.file(ctrl.pickedImage!, fit: BoxFit.cover)
                                        : Image.asset(
                                            getProfileIconByGender(ctrl.selectedGender),
                                            fit: BoxFit.cover,
                                          ),
                                  ),
                                ),
                                const SizedBox(height: 16),
                                ElevatedButton(
                                  onPressed: () => ctrl.selectImage(context),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.white,
                                    foregroundColor: primaryColor,
                                    elevation: 2,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                  ),
                                  child: const Text('Editar imagen'),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 40),

                      // ===== CAMPOS OPCIONALES =====
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          children: [
                            ExpansionTile(
                              title: const Text("Opciones avanzadas"),
                              children: [
                                TextFormField(
                                  controller: ctrl.nameController,
                                  decoration: const InputDecoration(
                                    labelText: 'Nombre de usuario',
                                    prefixIcon: Icon(Icons.person, color: primaryColor),
                                    border: OutlineInputBorder(),
                                  ),
                                  validator: (v) => (v == null || v.trim().isEmpty)
                                      ? 'Ingresa un nombre'
                                      : null,
                                ),
                                const SizedBox(height: 16),
                                TextFormField(
                                  controller: ctrl.emailController,
                                  decoration: const InputDecoration(
                                    labelText: 'Correo electrónico',
                                    prefixIcon: Icon(Icons.email, color: primaryColor),
                                    border: OutlineInputBorder(),
                                  ),
                                  validator: (v) => (v == null || !v.contains('@'))
                                      ? 'Correo no válido'
                                      : null,
                                ),
                              ],
                            ),

                            const SizedBox(height: 16),

                            TextFormField(
                              controller: ctrl.passwordController,
                              obscureText: !ctrl.showPassword,
                              decoration: InputDecoration(
                                labelText: 'Nueva contraseña',
                                prefixIcon: const Icon(Icons.lock, color: primaryColor),
                                border: const OutlineInputBorder(),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    ctrl.showPassword
                                        ? Icons.visibility
                                        : Icons.visibility_off,
                                    color: primaryColor,
                                  ),
                                  onPressed: ctrl.toggleShowPassword,
                                ),
                              ),
                              validator: (v) =>
                                  v != null && v.isNotEmpty && v.length < 6
                                      ? 'Mínimo 6 caracteres'
                                      : null,
                            ),
                            const SizedBox(height: 16),

                            DropdownButtonFormField<String>(
                              value: ctrl.selectedGender,
                              decoration: const InputDecoration(
                                labelText: 'Género',
                                prefixIcon: Icon(Icons.transgender, color: primaryColor),
                                border: OutlineInputBorder(),
                              ),
                              items: const [
                                DropdownMenuItem(value: 'Masculino', child: Text('Masculino')),
                                DropdownMenuItem(value: 'Femenino', child: Text('Femenino')),
                                DropdownMenuItem(value: 'Otro', child: Text('Otro')),
                              ],
                              onChanged: ctrl.changeGender,
                            ),
                            const SizedBox(height: 16),

                            DropdownButtonFormField<String>(
                              value: ctrl.selectedCountry,
                              decoration: const InputDecoration(
                                labelText: 'País',
                                prefixIcon: Icon(Icons.public, color: primaryColor),
                                border: OutlineInputBorder(),
                              ),
                              items: ctrl.countryList
                                  .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                                  .toList(),
                              onChanged: ctrl.changeCountry,
                            ),
                            const SizedBox(height: 32),

                            ElevatedButton(
                              onPressed: ctrl.loading ? null : () async {
                                await ctrl.saveProfile();
                                if (context.mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text("Cambios guardados")),
                                  );
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: primaryColor,
                                foregroundColor: Colors.white,
                                elevation: 2,
                                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                              ),
                              child: ctrl.loading
                                  ? const SizedBox(
                                      width: 18,
                                      height: 18,
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                        strokeWidth: 2,
                                      ),
                                    )
                                  : const Text('Guardar cambios'),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _CurveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, size.height - 60);
    path.quadraticBezierTo(size.width / 2, size.height, size.width, size.height - 60);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
