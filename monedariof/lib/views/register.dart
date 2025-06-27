import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  State<Register> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<Register> {
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final headerHeight = constraints.maxHeight * 0.35;
            final cardHeight = constraints.maxHeight * 0.65;
            final sidePadding = constraints.maxWidth * 0.06;
            return Stack(
              clipBehavior: Clip.none,
              children: [
                // HEADER
                ClipRRect(
                  borderRadius: BorderRadius.vertical(bottom: Radius.circular(headerHeight * 0.15)),
                  child: Container(
                    height: headerHeight,
                    color: Color(0xFFB39DDB),
                    padding: EdgeInsets.symmetric(
                      horizontal: sidePadding,
                      vertical: headerHeight * 0.15,
                    ),
                    child: Stack(
                      children: [
                        Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            'Monedario',
                            style: TextStyle(
                              fontSize: constraints.maxWidth * 0.08,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF512DA8),
                            ),
                          ),
                        ),
                        Positioned(
                          top: -headerHeight * 0.2,
                          right: -constraints.maxWidth * 0.1,
                          width: constraints.maxWidth * 0.6,
                          height: headerHeight * 1.5,
                          child: Lottie.asset('assets/cat_typing.json'),
                        ),
                      ],
                    ),
                  ),
                ),
                // CARD
                Positioned(
                  top: headerHeight - 40,
                  left: sidePadding,
                  right: sidePadding,
                  child: Container(
                    height: cardHeight + 40,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 10)],
                    ),
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(
                        sidePadding,
                        32,
                        sidePadding,
                        16,
                      ),
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Crea una cuenta',
                              style: TextStyle(
                                fontSize: constraints.maxWidth * 0.065,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: constraints.maxHeight * 0.02),
                            _buildTextField(
                              controller: _nameCtrl,
                              hint: 'Tu nombre',
                              icon: Icons.person,
                              width: constraints.maxWidth,
                            ),
                            SizedBox(height: constraints.maxHeight * 0.015),
                            _buildTextField(
                              controller: _emailCtrl,
                              hint: 'ejemplo@gmail.com',
                              icon: Icons.email,
                              keyboardType: TextInputType.emailAddress,
                              width: constraints.maxWidth,
                            ),
                            SizedBox(height: constraints.maxHeight * 0.015),
                            _buildTextField(
                              controller: _passCtrl,
                              hint: '********',
                              icon: Icons.lock,
                              obscure: true,
                              width: constraints.maxWidth,
                            ),
                            SizedBox(height: constraints.maxHeight * 0.03),
                            SizedBox(
                              width: double.infinity,
                              height: constraints.maxHeight * 0.07,
                              child: ElevatedButton(
                                onPressed: () => Navigator.pushReplacementNamed(context, '/welcome'),
                                style: ElevatedButton.styleFrom(
                                  padding: EdgeInsets.zero,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                child: Ink(
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [Color(0xFF9575CD), Color(0xFFD1C4E9)],
                                    ),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Center(
                                    child: Text(
                                      'Crear cuenta',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: constraints.maxWidth * 0.045,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: constraints.maxHeight * 0.02),
                            Row(
                              children: [
                                Expanded(child: Divider()),
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 8),
                                  child: Text('Continuar con'),
                                ),
                                Expanded(child: Divider()),
                              ],
                            ),
                            SizedBox(height: constraints.maxHeight * 0.02),
                            Row(
                              children: [
                                Expanded(
                                  child: OutlinedButton.icon(
                                    onPressed: () {},
                                    icon: Image.asset('assets/google.png', width: 24, height: 24),
                                    label: Text('Google'),
                                    style: OutlinedButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      padding: EdgeInsets.symmetric(vertical: 12),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 16),
                                Expanded(
                                  child: OutlinedButton.icon(
                                    onPressed: () {},
                                    icon: Image.asset('assets/facebook.png', width: 24, height: 24),
                                    label: Text('Facebook'),
                                    style: OutlinedButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      padding: EdgeInsets.symmetric(vertical: 12),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    bool obscure = false,
    required double width,
  }) {
    return SizedBox(
      width: width,
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        obscureText: obscure,
        decoration: InputDecoration(
          hintText: hint,
          prefixIcon: Icon(icon, color: Color(0xFF555555)),
          filled: true,
          fillColor: Color(0xFFF5F5F5),
          contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 12),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}
