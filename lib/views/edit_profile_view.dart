import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart'; 
import '../../controllers/auth_controller.dart';
import '../../models/user_model.dart';
import '../../utils/icon_mapper.dart';

class EditProfileView extends StatefulWidget {
  const EditProfileView({super.key});

  @override
  State<EditProfileView> createState() => _EditProfileViewState();
}

// Esta vista permite al usuario editar su perfil, incluyendo nombre y contraseña.
class _EditProfileViewState extends State<EditProfileView> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _passwordController = TextEditingController();

  // Muestra el avatar del perfil basado en el género del usuario.
  // Si el género es masculino, muestra un avatar masculino, si es femenino, muestra uno
  bool _saving = false;

// Muestra el avatar del perfil basado en el género del usuario.
  Widget buildProfileAvatar(String? gender) {
    final asset = getProfileIconAssetPath(gender);
    if (asset.endsWith('.json')) {
      return Lottie.asset(asset, width: 300, height: 300);
    }
    return CircleAvatar(radius: 150, backgroundImage: AssetImage(asset));
  }

  // Guarda los cambios realizados en el perfil del usuario.
  Future<void> _saveChanges() async {
    if (!_formKey.currentState!.validate()) return;

    final authController = Provider.of<AuthController>(context, listen: false);

    setState(() => _saving = true);

    try {
      await authController.updateProfileData(
        newName: _nameController.text.trim(),
        newPassword: _passwordController.text.trim().isNotEmpty
            ? _passwordController.text.trim()
            : null,
      );

      // Si se actualiza correctamente, muestra un mensaje de éxito
      // y redirige al usuario a la vista de configuración.
      if (!mounted) return; 
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text(" Cambios guardados correctamente"),
          backgroundColor: Colors.green.shade600,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );

      // Redirige al usuario a la vista de configuración
      Navigator.pushNamed(context, '/settings_view'); // Redirige a la vista de configuración
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(" ${e.message}"),
          backgroundColor: Colors.redAccent,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
        // Si ocurre un error, muestra un mensaje de error
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(" Error inesperado: $e"),
          backgroundColor: Colors.redAccent,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  // Construye la vista del perfil editable.
  // Muestra el nombre de usuario, la foto de perfil y un formulario para editar el
  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthController>(context, listen: false);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: FutureBuilder<UserModel?>(
          future: auth.getCurrentUserModel(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
            final user = snapshot.data!;

            _nameController.text = _nameController.text.isEmpty ? user.name : _nameController.text;

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  //  Botón atrás
                  Align(
                    alignment: Alignment.centerLeft,
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.black87),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),

                  //  Avatar
                  buildProfileAvatar(user.gender),
                  const SizedBox(height: 8),
                  Text(user.name, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                  Text(user.email, style: const TextStyle(color: Colors.grey)),
                  const SizedBox(height: 20),

                  //  Formulario
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        // Nombre
                        TextFormField(
                          controller: _nameController,
                          decoration: const InputDecoration(
                            labelText: 'Nombre de usuario',
                            prefixIcon: Icon(Icons.person, color: Colors.purple),
                            border: OutlineInputBorder(),
                          ),
                          validator: (v) {
                            if (v == null || v.trim().isEmpty) {
                              return 'Ingresa un nombre';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 10),

                        // Contraseña
                        TextFormField(
                          controller: _passwordController,
                          obscureText: true,
                          decoration: const InputDecoration(
                            labelText: 'Nueva contraseña (opcional)',
                            prefixIcon: Icon(Icons.lock, color: Colors.orange),
                            border: OutlineInputBorder(),
                          ),
                          validator: (v) {
                            if (v != null && v.isNotEmpty && v.length < 6) {
                              return 'La contraseña debe tener al menos 6 caracteres';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),

                        // Botón guardar cambios
                        ElevatedButton.icon(
                          onPressed: _saving ? null : _saveChanges,
                          icon: _saving
                              ? const SizedBox(
                                  width: 18,
                                  height: 18,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                )
                              : const Icon(Icons.save),
                          label: Text(_saving ? "Guardando..." : "Guardar cambios"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.purple,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                          ),
                        ),
                      ],
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
