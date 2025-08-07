import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/payment_model.dart';
import 'dart:io';

class PaymentDetailView extends StatelessWidget {
  final PaymentModel payment;
  const PaymentDetailView({super.key, required this.payment});

  @override
  Widget build(BuildContext context) {
    final df = DateFormat('dd/MM/yyyy HH:mm');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalle del Pago'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: ListView(
          children: [
            _row('Monto pagado', '\$${payment.amount.toStringAsFixed(2)}'),
            _row('Fecha', df.format(payment.date)),
            const SizedBox(height: 24),
            const Text('Comprobante',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 14),
            _buildComprobante(context),
          ],
        ),
      ),
    );
  }

  Widget _row(String label, String value) => Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Row(
          children: [
            Expanded(child: Text(label)),
            Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ],
        ),
      );

  Widget _buildComprobante(BuildContext context) {
    if (payment.comprobanteUrl == null || payment.comprobanteUrl!.isEmpty) {
      return const Text('Sin comprobante adjunto',
          style: TextStyle(color: Colors.grey));
    }
    // Detecta si es un archivo local (file://) o url web
    if (payment.comprobanteUrl!.startsWith('file://')) {
      // Muestra la imagen local
      return ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Image.file(
          // Se quita el prefijo "file://"
          File(payment.comprobanteUrl!.substring(7)),
          height: 220,
          fit: BoxFit.contain,
        ),
      );
    } else {
      // Muestra la imagen de la web (Firebase Storage, por ejemplo)
      return ClipRRect(
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
      );
    }
  }
}
