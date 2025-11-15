import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LoginCapsule extends StatefulWidget {
  final Function onLoginSuccess;
  final Function onCreateAccount;

  const LoginCapsule({
    super.key,
    required this.onLoginSuccess,
    required this.onCreateAccount,
  });

  @override
  State<LoginCapsule> createState() => _LoginCapsuleState();
}

class _LoginCapsuleState extends State<LoginCapsule> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isLoading = false;
  bool showPassword = false;
  String errorMessage = '';

  Future<void> login() async {
    setState(() {
      isLoading = true;
      errorMessage = '';
    });

    final response = await http.post(
      Uri.parse('http://192.168.100.8/api_coco/login.php'),
      body: {
        'email': emailController.text.trim(),
        'password': passwordController.text.trim(),
      },
    );

    final data = json.decode(response.body);
    setState(() => isLoading = false);

    if (data['success']) {
      widget.onLoginSuccess();
    } else {
      setState(() => errorMessage = data['message']);
    }
  }

  Widget buildInputField({
    required String label,
    required String hint,
    required IconData icon,
    required TextEditingController controller,
    bool isPassword = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Container(
              margin: const EdgeInsets.only(right: 12),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color(0xFF62987B),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: Colors.white),
            ),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: TextField(
                  controller: controller,
                  obscureText: isPassword && !showPassword,
                  decoration: InputDecoration(
                    hintText: hint,
                    border: InputBorder.none,
                    suffixIcon: isPassword
                        ? IconButton(
                            icon: Icon(
                              showPassword
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: Colors.grey,
                            ),
                            onPressed: () {
                              setState(() {
                                showPassword = !showPassword;
                              });
                            },
                          )
                        : null,
                  ),
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: MediaQuery.of(context).size.height * 0.30, // 🔁 Ajusta altura aquí
      left: 0,
      right: 0,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.95),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Center(
                    child: Text(
                      'Inicia sesión en tu cuenta',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  buildInputField(
                    label: 'Correo electrónico',
                    hint: 'Correo electrónico',
                    icon: Icons.email,
                    controller: emailController,
                  ),
                  const SizedBox(height: 20),
                  buildInputField(
                    label: 'Contraseña',
                    hint: 'Contraseña',
                    icon: Icons.lock,
                    controller: passwordController,
                    isPassword: true,
                  ),
                  const SizedBox(height: 8),
                  Align(
                    alignment: Alignment.centerRight,
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          emailController.clear();
                          passwordController.clear();
                          errorMessage = '';
                        });
                      },
                      child: const Text(
                        '¿Has olvidado tu contraseña?',
                        style: TextStyle(
                          fontStyle: FontStyle.italic,
                          color: Colors.black,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  const SizedBox(height: 0),

                  Center(
                    child: SizedBox(
                      width: 290, // puedes cambiar libremente
                      height:
                          100, // también puedes cambiar la altura sin que se recorte
                      child: TextButton(
                        onPressed: isLoading ? null : login,
                        style: TextButton.styleFrom(padding: EdgeInsets.zero),
                        child: FittedBox(
                          // ← MAGIA: evita recortes
                          fit: BoxFit.contain, // ← mantiene la imagen completa
                          child: Image.asset(
                            'assets/images/btnSesion.png',
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                decoration: BoxDecoration(
                                  color: Colors.red,
                                  borderRadius: BorderRadius.circular(12),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black26,
                                      blurRadius: 6,
                                      offset: Offset(0, 3),
                                    ),
                                  ],
                                ),
                                child: Center(
                                  child: Text(
                                    'Iniciar sesión',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                  if (errorMessage.isNotEmpty)
                    Text(
                      errorMessage,
                      style: const TextStyle(color: Colors.red),
                    ),

                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        '¿Eres un usuario nuevo? ',
                        style: TextStyle(fontSize: 16, color: Colors.black),
                      ),
                      GestureDetector(
                        onTap: () => widget.onCreateAccount(),
                        child: const Text(
                          'Crear Cuenta',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF62987B),
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
