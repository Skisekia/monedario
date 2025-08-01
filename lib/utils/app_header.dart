import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import '../controllers/auth_controller.dart';
import '../models/user_model.dart';
import '../utils/icon_mapper.dart';

class AppHeader extends StatelessWidget {
  final int currentIndex; // Índice de la pestaña seleccionada

  const AppHeader({
    super.key,
    required this.currentIndex,
  });

  @override
  Widget build(BuildContext context) {
    // En perfil (Settings) → no mostrar header
    if (currentIndex == 3) return const SizedBox.shrink();

    final auth = Provider.of<AuthController>(context, listen: false);

    return FutureBuilder<UserModel?>(
      future: auth.getCurrentUserModel(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Padding(
            padding: EdgeInsets.all(16.0),
            child: LinearProgressIndicator(),
          );
        }
        if (!snapshot.hasData) {
          return const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text("No se pudo cargar el usuario"),
          );
        }

        final user = snapshot.data!;

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          child: Row(
            children: [
              SizedBox(
                width: 60,
                height: 60,
                child: Lottie.asset(
                  getProfileIconByGender(user.gender),
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(width: 12),
              // Si es Dashboard (Home) → mostrar bienvenida y nombre
              if (currentIndex == 0) ...[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "¡Bienvenido!",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.black54,
                      ),
                    ),
                    Text(
                      user.name,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ]
            ],
          ),
        );
      },
    );
  }
}
