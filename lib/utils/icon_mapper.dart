import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

/// Obtiene la **ruta** del asset del avatar según género o avatar personalizado.
/// Úsala solo si necesitas la ruta tipo String.
String getProfileIconAssetPath(String? gender, {String? customAsset}) {
  if (customAsset != null && customAsset.isNotEmpty) return customAsset;
  switch (gender?.toLowerCase()) {
    case 'masculino':
    case 'hombre':
      return 'assets/avatar_boy.json';
    case 'femenino':
    case 'mujer':
      return 'assets/avatar_girl.json';
    default:
      return 'assets/avatar_default.json';
  }
}

/// Devuelve el **Widget** listo para mostrar (Lottie o imagen estática),
/// detecta si es animación o imagen, puedes usarlo en cualquier parte de la app.
Widget getProfileIconWidget(String? gender, {String? customAsset, double size = 80}) {
  final asset = getProfileIconAssetPath(gender, customAsset: customAsset);

  if (asset.endsWith('.json')) {
    // Si es Lottie
    return Lottie.asset(
      asset,
      width: size,
      height: size,
      fit: BoxFit.contain,
      repeat: true,
    );
  } else {
    // Si es imagen estática
    return CircleAvatar(
      radius: size / 2,
      backgroundImage: AssetImage(asset),
      backgroundColor: Colors.transparent,
    );
  }
}
