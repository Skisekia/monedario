import 'package:flutter/material.dart';

Icon getUserIcon(String gender, String provider) {
  if (provider == 'google') return const Icon(Icons.account_circle_rounded, color: Colors.redAccent, size: 36);
  if (provider == 'facebook') return const Icon(Icons.account_circle_rounded, color: Colors.blueAccent, size: 36);
  if (provider == 'apple') return const Icon(Icons.account_circle_rounded, color: Colors.black, size: 36);

  switch (gender.toLowerCase()) {
    case 'femenino':
      return const Icon(Icons.face_4_rounded, color: Colors.pinkAccent, size: 36);
    case 'masculino':
      return const Icon(Icons.face_5_rounded, color: Colors.blueAccent, size: 36);
    default:
      return const Icon(Icons.face_6_rounded, color: Colors.grey, size: 36);
  }
}
