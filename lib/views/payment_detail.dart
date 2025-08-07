import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/payment_model.dart';

class PaymentDetailView extends StatelessWidget {
  final PaymentModel payment;
  const PaymentDetailView({super.key, required this.payment});

  @override
  Widget build(BuildContext context) {
    final df = DateFormat('dd/MM/yyyy HH:mm');
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalle del pago'),
        backgroundColor: isDark ? const Color(0xFF22223B) : Colors.white,
        foregroundColor: isDark ? Colors.white : Colors.black87,
        elevation: 0,
        centerTitle: true,
      ),
      backgroundColor: isDark ? const Color(0xFF22223B) : Colors.white,
      body: ListView(
        padding: const EdgeInsets.fromLTRB(24, 30, 24, 36),
        children: [
          const Icon(Icons.payment, color: Color(0xFF837AB6), size: 48),
          const SizedBox(height: 12),
          Center(
            child: Text(
              'Detalle del Pago',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : const Color(0xFF23223B),
              ),
            ),
          ),
          const SizedBox(height: 24),
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
        ],
      ),
    );
  }

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

  Widget _buildComprobante(BuildContext context) {
    if (payment.comprobanteUrl == null || payment.comprobanteUrl!.isEmpty) {
      return const Text('Sin comprobante adjunto',
          style: TextStyle(color: Colors.grey));
    }
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
