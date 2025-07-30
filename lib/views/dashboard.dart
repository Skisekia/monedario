import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

// Controllers
import '../../controllers/auth_controller.dart';
import '../../models/user_model.dart';
import '../../utils/icon_mapper.dart';

// Views
import 'home_view.dart';
import 'statistics_view.dart';
import 'transaction_form_view.dart';
import 'settings_view.dart';
import '../../utils/bottom_nav_bar.dart';


class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  int _selectedIndex = 0;

  final List<Widget> _views = const [
  HomeView(),
  StatisticsView(),
  TransactionFormView(),
  SettingsView(),
];

  @override
  Widget build(BuildContext context) {
    final authController = Provider.of<AuthController>(context, listen: false);
    final Future<UserModel?> userFuture = authController.getCurrentUserModel();

    return Scaffold(
      backgroundColor: Colors.white,
      body: FutureBuilder<UserModel?>(
        future: userFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final user = snapshot.data;

          if (user == null) {
            return const Center(child: Text('Usuario no autenticado.'));
          }

          return SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  child: Row(
                    children: [
                      ClipOval(
                        child: SizedBox(
                          width: 48,
                          height: 48,
                          child: Lottie.asset(
                            getLottieAssetByGender(user.gender),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'Hola, ${user.name}',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Spacer(),
                      IconButton(
                        icon: const Icon(Icons.logout),
                        onPressed: () {
                          authController.signOut();
                          Navigator.pushReplacementNamed(context, '/login');
                        },
                      ),
                    ],
                  ),
                ),
                Expanded(child: _views[_selectedIndex]),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: AppBottomNavBar(
  selectedIndex: _selectedIndex,
  onTap: (index) => setState(() => _selectedIndex = index),
),

    );
  }
}
