// 📄 lib/views/add_payment.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../controllers/debt_controller.dart';
//import '../models/transaction_model.dart';
import '../models/payment_model.dart';

// ----- Helper para detalle del pago -----
void showPaymentDetail(BuildContext context, PaymentModel payment) {
  showDialog(
    context: context,
    builder: (ctx) => AlertDialog(
      title: Text('Detalle del pago'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Monto: \$${payment.amount.toStringAsFixed(2)}'),
          if (payment.comprobanteUrl != null)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Image.network(payment.comprobanteUrl!, height: 120),
            ),
          Text('Fecha: ${payment.date.toString().substring(0, 16)}'),
        ],
      ),
      actions: [
        TextButton(
            onPressed: () => Navigator.pop(context), child: const Text('Cerrar'))
      ],
    ),
  );
}

class AddPaymentView extends StatelessWidget {
  const AddPaymentView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text('Pagos', style: TextStyle(color: Colors.black87)),
        iconTheme: const IconThemeData(color: Colors.black54),
      ),
      body: Column(
        children: [
          const SizedBox(height: 18),
          const _PaymentsSummaryCard(),
          const SizedBox(height: 8),
          Expanded(child: _PaymentsList()),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,
        elevation: 6,
        child: const Icon(Icons.add, color: Color(0xFF7F30FF)),
        onPressed: () => _showPaymentForm(context),
      ),
    );
  }
}

void _showPaymentForm(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => const _PaymentForm(),
  );
}

// --- Card resumen (puedes conectar a tus controladores) ---
class _PaymentsSummaryCard extends StatelessWidget {
  const _PaymentsSummaryCard();

  @override
  Widget build(BuildContext context) {
    // Puedes conectar a tus controladores para totales reales.
    return Card(
      color: const Color(0xFFF7F2FF),
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: const [
            _SummaryItem(label: 'Pagos este mes', value: '\$0.00'),
            _SummaryItem(label: 'Total abonado', value: '\$0.00'),
          ],
        ),
      ),
    );
  }
}

class _SummaryItem extends StatelessWidget {
  final String label;
  final String value;
  const _SummaryItem({required this.label, required this.value});
  @override
  Widget build(BuildContext context) => Column(
        children: [
          Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
          const SizedBox(height: 4),
          Text(value, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black87)),
        ],
      );
}

// --- Lista de pagos reales ---
class _PaymentsList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final debtCtrl = context.watch<DebtController>();
    final allPayments = debtCtrl.allPayments; // <- Debes exponer esto desde el controlador

    if (allPayments.isEmpty) {
      return const Center(
        child: Text(
          'Aún no tienes pagos registrados.\n¡Agrega uno!',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 18, color: Color(0xFF837AB6)),
        ),
      );
    }

    return ListView.separated(
      itemCount: allPayments.length,
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      itemBuilder: (context, i) {
        final p = allPayments[i];
        return Card(
          elevation: 1,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            leading: p.comprobanteUrl != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(p.comprobanteUrl!, width: 48, height: 48, fit: BoxFit.cover))
                : const Icon(Icons.receipt_long, size: 36, color: Color(0xFF837AB6)),
            title: Text('\$${p.amount.toStringAsFixed(2)}',
                style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text(p.date.toString().substring(0, 16)),
            trailing: const Icon(Icons.arrow_forward_ios, size: 18, color: Colors.black38),
            onTap: () => showPaymentDetail(context, p),
          ),
        );
      },
    );
  }
}

// =========================
// FORMULARIO MODAL CON FOTO
// =========================

class _PaymentForm extends StatefulWidget {
  const _PaymentForm();

  @override
  State<_PaymentForm> createState() => _PaymentFormState();
}

class _PaymentFormState extends State<_PaymentForm> {
  final _formKey = GlobalKey<FormState>();
  final _amountCtrl = TextEditingController();
  String? _paymentType; // "debt" o "loan"
  String? _selectedId;
  File? _imageFile;
  bool _uploading = false;

  @override
  void dispose() {
    _amountCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: source, imageQuality: 80);
    if (picked != null) {
      setState(() => _imageFile = File(picked.path));
    }
  }

  @override
  Widget build(BuildContext context) {
    final debtsCtrl = context.read<DebtController>();
    final debts = debtsCtrl.activeDebts;
    final loans = debtsCtrl.activeLoans;
    final padding = MediaQuery.of(context).viewInsets;

    List<dynamic> options = [];
    if (_paymentType == 'debt') options = debts;
    if (_paymentType == 'loan') options = loans;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: LayoutBuilder(
        builder: (context, constraints) => Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.only(
                  bottom: padding.bottom + 18, left: 20, right: 20, top: 32),
              child: Container(
                width: constraints.maxWidth > 430 ? 410 : null,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(32),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 12,
                      offset: Offset(0, -6),
                    )
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(24, 18, 24, 20),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          'Registrar pago',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 26,
                              color: Color(0xFF250E2C)),
                        ),
                        const SizedBox(height: 18),
                        DropdownButtonFormField<String>(
                          value: _paymentType,
                          decoration: _decoration('¿Qué vas a pagar?'),
                          items: const [
                            DropdownMenuItem(value: 'debt', child: Text('Deuda')),
                            DropdownMenuItem(value: 'loan', child: Text('Préstamo')),
                          ],
                          onChanged: (v) {
                            setState(() {
                              _paymentType = v;
                              _selectedId = null;
                            });
                          },
                          validator: (v) => v == null ? 'Requerido' : null,
                        ),
                        const SizedBox(height: 14),
                        if (_paymentType != null)
                          DropdownButtonFormField<String>(
                            value: _selectedId,
                            decoration: _decoration(
                                _paymentType == 'debt'
                                    ? 'Selecciona la deuda'
                                    : 'Selecciona el préstamo'),
                            items: options
                                .map<DropdownMenuItem<String>>(
                                  (item) => DropdownMenuItem(
                                    value: item.id,
                                    child: Text(
                                      '${item.concept} (\$${(item.amount - item.paid).toStringAsFixed(2)})',
                                    ),
                                  ),
                                )
                                .toList(),
                            onChanged: (v) => setState(() => _selectedId = v),
                            validator: (v) => v == null ? 'Requerido' : null,
                          ),
                        if (_paymentType != null) const SizedBox(height: 14),
                        TextFormField(
                          controller: _amountCtrl,
                          keyboardType: TextInputType.number,
                          decoration: _decoration('Monto del pago (\$)').copyWith(
                            prefixIcon: const Icon(Icons.attach_money_rounded, color: Color(0xFF837AB6)),
                          ),
                          validator: (v) =>
                              (double.tryParse(v ?? '') ?? 0) <= 0 ? 'Inválido' : null,
                        ),
                        const SizedBox(height: 20),
                        Row(
                          children: [
                            Text(
                              "Comprobante:",
                              style: TextStyle(
                                  fontWeight: FontWeight.w500, fontSize: 16, color: Colors.black87),
                            ),
                            const SizedBox(width: 12),
                            OutlinedButton.icon(
                              onPressed: _uploading
                                  ? null
                                  : () async {
                                      await showModalBottomSheet(
                                        context: context,
                                        builder: (_) => SafeArea(
                                          child: Wrap(
                                            children: [
                                              ListTile(
                                                leading: Icon(Icons.photo_camera),
                                                title: Text('Tomar foto'),
                                                onTap: () {
                                                  Navigator.pop(context);
                                                  _pickImage(ImageSource.camera);
                                                },
                                              ),
                                              ListTile(
                                                leading: Icon(Icons.photo_library),
                                                title: Text('Subir desde galería'),
                                                onTap: () {
                                                  Navigator.pop(context);
                                                  _pickImage(ImageSource.gallery);
                                                },
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                              icon: const Icon(Icons.camera_alt_rounded, color: Color(0xFF837AB6)),
                              label: const Text("Agregar"),
                              style: OutlinedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                          ],
                        ),
                        if (_imageFile != null) ...[
                          const SizedBox(height: 8),
                          Stack(
                            alignment: Alignment.topRight,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.file(
                                  _imageFile!,
                                  width: 130,
                                  height: 130,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Positioned(
                                top: 0,
                                right: 0,
                                child: GestureDetector(
                                  onTap: () => setState(() => _imageFile = null),
                                  child: Container(
                                    decoration: const BoxDecoration(
                                      color: Colors.white,
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(Icons.close, color: Colors.red, size: 24),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                        const SizedBox(height: 24),
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: _uploading ? null : _save,
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.zero,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16)),
                            ).copyWith(
                              backgroundColor: WidgetStateProperty.all(
                                const Color(0xFF837AB6)),
                            ),
                            child: _uploading
                                ? const CircularProgressIndicator(color: Colors.white)
                                : const Text(
                                    'Guardar pago',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 17,
                                      color: Colors.white,
                                    ),
                                  ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration _decoration(String label) => InputDecoration(
        labelText: label,
        filled: true,
        fillColor: const Color(0xFFF4F6FA),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
      );

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _uploading = true);

    final amount = double.parse(_amountCtrl.text);

    String? comprobanteUrl;
    if (_imageFile != null) {
      // Aquí debes subir la imagen a Firebase Storage y obtener la url.
      // comprobanteUrl = await uploadToFirebaseStorage(_imageFile!);
    }

    final ctrl = context.read<DebtController>();

    if (_paymentType == 'debt') {
      await ctrl.registerPayment(_selectedId!, amount, comprobanteUrl: comprobanteUrl);
    } else if (_paymentType == 'loan') {
      await ctrl.registerLoanPayment(_selectedId!, amount, comprobanteUrl: comprobanteUrl);
    }

    setState(() => _uploading = false);
    if (mounted) Navigator.of(context).pop();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Pago de \$${amount.toStringAsFixed(2)} registrado correctamente',
        ),
      ),
    );
  }
}
