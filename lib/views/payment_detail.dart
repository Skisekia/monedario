import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/payment_model.dart';
import '../utils/table_calendar.dart';

/// Detalle de un pago específico
/// Muestra información detallada del pago, incluyendo monto, fecha y comprobante.
class PaymentDetailView extends StatelessWidget {
  final PaymentModel payment;
  const PaymentDetailView({super.key, required this.payment});

/// Construye la vista del detalle del pago
  @override
  Widget build(BuildContext context) {
    final df = DateFormat('dd/MM/yyyy HH:mm');
    final isDark = Theme.of(context).brightness == Brightness.dark;
    // Retorna el widget principal de la vista
    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF22223B) : Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 16,
            offset: const Offset(0, -8),
          )
        ],
      ),
      padding: const EdgeInsets.fromLTRB(24, 18, 24, 36),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 48,
            height: 6,
            margin: const EdgeInsets.only(bottom: 18),
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          const Icon(Icons.payments, color: Color(0xFF837AB6), size: 48),
          const SizedBox(height: 8),
          Text(
            'Detalle del Pago',
            style: TextStyle(
              fontSize: 20, fontWeight: FontWeight.bold, color: isDark ? Colors.white : const Color(0xFF23223B)),
          ),
          const SizedBox(height: 16),
          _row('Monto pagado', '\$${payment.amount.toStringAsFixed(2)}'),
          _row('Fecha', df.format(payment.date)),
          const Divider(height: 36),
          Align(
            alignment: Alignment.centerLeft,
            child: const Text('Comprobante',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          ),
          const SizedBox(height: 14),
          _buildComprobante(context),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              icon: const Icon(Icons.close, size: 22),
              label: const Text('Cerrar', style: TextStyle(fontSize: 16)),
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: const Color(0xFF837AB6),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              onPressed: () => Navigator.pop(context),
            ),
          )
        ],
      ),
    );
  }
}
// Construye una fila con etiqueta y valor
  // Permite personalizar el color del valor si se proporciona
  Widget _row(String label, String value) => Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Row(
          children: [
            Expanded(child: Text(label, style: const TextStyle(fontSize: 15))),
            Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
            ),
          ],
        ),
      );

// Construye el widget del comprobante
  // Si no hay comprobante, muestra un mensaje
  Widget _buildComprobante(BuildContext context) {
    if (payment.comprobanteUrl == null || payment.comprobanteUrl!.isEmpty) {
      return const Text('Sin comprobante adjunto',
          style: TextStyle(color: Colors.grey));
    }
    // Detecta si es archivo local (file://) o url web
    if (payment.comprobanteUrl!.startsWith('file://')) {
      return GestureDetector(
        onTap: () => _showFullImage(context, File(payment.comprobanteUrl!.substring(7))),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.file(
            File(payment.comprobanteUrl!.substring(7)),
            height: 220,
            fit: BoxFit.contain,
          ),
        ),
      );
    } else {
      return GestureDetector(
        onTap: () => _showFullImage(context, payment.comprobanteUrl!),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.network(
            payment.comprobanteUrl!,
            height: 220,
            fit: BoxFit.contain,
            loadingBuilder: (ctx, child, progress) => progress == null
                ? child
                : const Center(child: CircularProgressIndicator()),
            errorBuilder: (_, __, ___) => const Text(
                'No se pudo cargar el comprobante',
                style: TextStyle(color: Colors.red)),
          ),
        ),
      );
    }
  }

// Muestra la imagen completa en un diálogo al hacer clic
  // Permite cerrar el diálogo al tocar la imagen
  void _showFullImage(BuildContext context, dynamic imgSource) {
    showDialog(
      context: context,
      builder: (_) => Dialog(
        backgroundColor: Colors.transparent,
        child: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: imgSource is File
              ? Image.file(imgSource)
              : Image.network(imgSource),
        ),
      ),
    );
  }
}
