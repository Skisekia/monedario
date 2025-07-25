import 'package:flutter/material.dart';
import '../../models/user_model.dart';
import '../../utils/icon_mapper.dart';

class Dashboard extends StatelessWidget {
  const Dashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final UserModel user = UserModel(
      name: 'Mauricio Briones',
      gender: 'Masculino',
      provider: 'google', // puede ser google, facebook, apple o email
    );

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        elevation: 0,
        title: Row(
          children: [
            getUserIcon(user.gender, user.provider),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Hola ${user.name.split(' ')[0]} 👋', style: const TextStyle(fontWeight: FontWeight.bold)),
                const Text('Bienvenido de nuevo', style: TextStyle(fontSize: 12, color: Colors.grey)),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.grid_view_rounded),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 📊 Balance general
            _buildBalanceChartPlaceholder(),

            const SizedBox(height: 24),

            // 📅 Calendario con fechas de pago
            _buildCalendarPlaceholder(context),

            const SizedBox(height: 24),

            // 🧾 Últimas transacciones
            const Text("Últimos movimientos", style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            _buildTransactionTile("Spotify Premium", "-\$3", "Entretenimiento", "14:00 6 Jul", Icons.music_note),
            _buildTransactionTile("Pago luz", "-\$8", "Servicios", "13:00 5 Jul", Icons.lightbulb),
          ],
        ),
      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.pinkAccent,
        onPressed: () => Navigator.pushNamed(context, '/add_transaction_menu'),
        child: const Icon(Icons.add, size: 32),
      ),

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        onTap: (index) {
          switch (index) {
            case 0: break;
            case 1: Navigator.pushNamed(context, '/statistics_view'); break;
            case 2: Navigator.pushNamed(context, '/settings_view'); break;
          }
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_rounded), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.bar_chart_rounded), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.settings_rounded), label: ''),
        ],
      ),
    );
  }

  Widget _buildBalanceChartPlaceholder() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.indigo[50],
        borderRadius: BorderRadius.circular(20),
      ),
      width: double.infinity,
      child: Column(
        children: const [
          Text("Balance Mensual", style: TextStyle(fontWeight: FontWeight.bold)),
          SizedBox(height: 12),
          Icon(Icons.bar_chart_rounded, size: 80, color: Colors.indigo),
          Text("Aquí irá la gráfica de ingresos vs egresos", style: TextStyle(fontSize: 12, color: Colors.grey)),
        ],
      ),
    );
  }

  Widget _buildCalendarPlaceholder(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, '/payment_calendar_detail'),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.orange[50],
          borderRadius: BorderRadius.circular(20),
        ),
        width: double.infinity,
        child: Column(
          children: const [
            Text("Calendario de pagos", style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 12),
            Icon(Icons.calendar_month_rounded, size: 80, color: Colors.orange),
            Text("Tap para ver detalles", style: TextStyle(fontSize: 12, color: Colors.grey)),
          ],
        ),
      ),
    );
  }

  Widget _buildTransactionTile(String title, String amount, String category, String time, IconData iconData) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      elevation: 0.5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.grey[200],
          child: Icon(iconData, color: Colors.grey[800]),
        ),
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
