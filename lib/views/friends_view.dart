import 'package:flutter/material.dart';
import '../utils/app_header.dart'; // Ajusta la ruta si es necesario

class FriendsView extends StatelessWidget {
  const FriendsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppHeader(
          showHome: true, // Cambia a false si no quieres mostrar el icono home
         onHomeTap: () {
          Navigator.pushNamedAndRemoveUntil(context, '/home_view', (route) => false);
        },
          showNotif: false, // Cambia a true si quieres mostrar el icono de notificaciones

        ),
        const Expanded(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.people_alt_rounded, size: 80, color: Color(0xFF837AB6)),
                SizedBox(height: 20),
                Text(
                  "Tus amigos",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Text(
                  "Aquí podrás ver y gestionar tus amigos.",
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
