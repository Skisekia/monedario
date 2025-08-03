import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import '../../controllers/auth_controller.dart';
import '../../models/user_model.dart';
import '../../utils/icon_mapper.dart';


class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  Widget buildProfileAvatar(String? gender) {
    final asset = getProfileIconAssetPath(gender);
    if (asset.endsWith('.json')) {
      return Lottie.asset(asset, width: 300, height: 300);
    }
    return CircleAvatar(radius: 150, backgroundImage: AssetImage(asset));
  }

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

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // Avatar grande
                  buildProfileAvatar(user.gender),
                  const SizedBox(height: 8),
                  Text(user.name, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                  Text(user.email, style: const TextStyle(color: Colors.grey)),
                  const SizedBox(height: 20),

                  // Información de perfil
                  Card(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    elevation: 2,
                    child: ListTile(
                      leading: const Icon(Icons.group_add, color: Colors.purple),
                      title: const Text("Vincular con otros usuarios"),
                      onTap: () {
                        // Podríamos reutilizar el mismo modal que en Settings
                        Navigator.pushNamed(context, '/settings');
                      },
                    ),
                  ),
                  const SizedBox(height: 10),

                  Card(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    elevation: 2,
                    child: ListTile(
                      leading: const Icon(Icons.history, color: Colors.orange),
                      title: const Text("Historial de transacciones"),
                      onTap: () {},
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
