import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Dashboard extends StatelessWidget {
  const Dashboard({super.key});

  @override
  Widget build(BuildContext context) {
    // Obtén el usuario actual de Firebase
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        actions: [
          // Botón para cerrar sesión
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              if (context.mounted) {
                Navigator.pushReplacementNamed(context, '/login');
              }
            },
            tooltip: 'Cerrar sesión',
          ),
        ],
      ),
      body: user == null
          ? const Center(child: Text('No hay usuario autenticado'))
          : Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Foto de perfil (si tiene)
                  if (user.photoURL != null)
                    CircleAvatar(
                      radius: 40,
                      backgroundImage: NetworkImage(user.photoURL!),
                    ),
                  const SizedBox(height: 20),
                  // Nombre
                  if (user.displayName != null)
                    Text(
                      user.displayName!,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  const SizedBox(height: 8),
                  // Correo
                  Text(
                    user.email ?? '',
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 40),
                  // Mensaje de bienvenida
                  const Text(
                    '¡Bienvenido a Monedario!',
                    style: TextStyle(fontSize: 18),
                  ),
                ],
              ),
            ),
    );
  }
}
