// views/dashboard.dart
import 'package:flutter/material.dart';

class Dashboard extends StatelessWidget {
  const Dashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final userName = "Bill Paxton"; // ← esto luego vendrá de tu modelo de usuario

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        elevation: 0,
        title: Row(
          children: [
            const CircleAvatar(
              backgroundImage: AssetImage('assets/profile.png'), // o imagen de red
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Hello $userName', style: const TextStyle(fontWeight: FontWeight.bold)),
                const Text('Welcome back!', style: TextStyle(fontSize: 12, color: Colors.grey)),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.grid_view_rounded),
            onPressed: () {
              // futuras acciones
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // 📊 Activity Widget
            Row(
              children: [
                _buildActivityCard(),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    children: [
                      _buildInfoBox(
                        icon: Icons.fastfood,
                        label: 'Food Last Week',
                        amount: '\$18.4',
                        color: Colors.purple[100]!,
                      ),
                      const SizedBox(height: 12),
                      _buildInfoBox(
                        icon: Icons.paid,
                        label: 'Revenue Last Week',
                        amount: '\$18.4',
                        color: Colors.green[100]!,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // 🧾 Transactions
            _buildTransactionTile("Spotify Premium", "-\$3", "Entertainment / Music", "14:00 6 Jul", "assets/spotify.png"),
            _buildTransactionTile("Netflix", "-\$6", "Entertainment / Film", "14:00 6 Jul", "assets/netflix.png"),
          ],
        ),
      ),

      // ➕ Botón flotante para agregar ingreso, deuda, etc.
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.pinkAccent,
        onPressed: () {
          Navigator.pushNamed(context, '/add_transaction_menu');
        },
        child: const Icon(Icons.add, size: 32),
      ),

      // 🔽 Navegación inferior
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        onTap: (index) {
          // Aquí puedes navegar a /dashboard, /charts, /settings, etc.
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_rounded), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.bar_chart_rounded), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.settings_rounded), label: ''),
        ],
      ),
    );
  }

  Widget _buildActivityCard() {
    return Container(
      width: 140,
      height: 160,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFFFE5E5),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          const Text("Activity", style: TextStyle(fontWeight: FontWeight.bold)),
          const Text("of Current Week", style: TextStyle(fontSize: 12, color: Colors.grey)),
          const Spacer(),
          // Puedes agregar una bar chart aquí con un paquete
          Image.asset('assets/bar_chart.png', height: 70), // reemplazar con gráfico real si quieres
        ],
      ),
    );
  }

  Widget _buildInfoBox({required IconData icon, required String label, required String amount, required Color color}) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Icon(icon, size: 24),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: const TextStyle(fontSize: 12)),
              Text(amount, style: const TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionTile(String title, String amount, String category, String time, String iconAsset) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      elevation: 0.5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: ListTile(
        leading: CircleAvatar(backgroundImage: AssetImage(iconAsset), radius: 24),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(category),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(amount, style: const TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold)),
            Text(time, style: const TextStyle(fontSize: 12, color: Colors.grey)),
          ],
        ),
      ),
    );
  }
}
