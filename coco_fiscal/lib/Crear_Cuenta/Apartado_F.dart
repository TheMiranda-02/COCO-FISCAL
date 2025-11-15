import 'package:flutter/material.dart';
import 'package:coco_fiscal/Apartado_A_home.dart';

class ApartadoFScreen extends StatefulWidget {
  final Map<String, dynamic> datosUsuario;

  const ApartadoFScreen({super.key, required this.datosUsuario});

  @override
  State<ApartadoFScreen> createState() => _ApartadoFScreenState();
}

class _ApartadoFScreenState extends State<ApartadoFScreen> {
  // MÉTODO PARA NAVEGAR A APARTADO A (HOME)
  void _navegarAApartadoA() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => ApartadoAHome()),
      (route) => false,
    );
  }

  @override
  void initState() {
    super.initState();
    // Mostrar datos en consola
    print('📋 DATOS RECIBIDOS EN APARTADO F:');
    widget.datosUsuario.forEach((key, value) {
      print('   $key: $value');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // IMAGEN DE FONDO
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/OnboardingF.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),

          // BOTÓN-IMAGEN CENTRADO - POSICIONA DONDE QUIERAS
          Positioned(
            left: MediaQuery.of(context).size.width / 2 - 140, // ← AJUSTA LEFT
            top: MediaQuery.of(context).size.height / 2 + 276, // ← AJUSTA TOP
            child: GestureDetector(
              onTap: () {
                print('Botón presionado - Navegando a Home');
                _navegarAApartadoA();
              },
              child: Container(
                width: 280, // ← AJUSTA ANCHO
                height: 100, // ← AJUSTA ALTO
                child: Image.asset(
                  'assets/images/btnComenzar.png',
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      decoration: BoxDecoration(
                        color: Colors.orange,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: Text(
                          'Continuar a Home',
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
        ],
      ),
    );
  }
}
