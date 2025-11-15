import 'package:flutter/material.dart';
import 'login_capsule.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          // Fondo con imagen
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                  'assets/images/FondoB.png',
                ), // 🔁 Cambia por tu imagen
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Slogan arriba a la izquierda

          // Cápsula de login
          LoginCapsule(
            onLoginSuccess: () {
              Navigator.pushNamed(context, '/home'); // 🔁 Cambia por tu ruta
            },
            onCreateAccount: () {
              Navigator.pushNamed(
                context,
                '/crear_cuenta',
              ); // 🔁 Cambia por tu ruta
            },
          ),
        ],
      ),
    );
  }
}
