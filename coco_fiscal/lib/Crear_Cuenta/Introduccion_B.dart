import 'package:flutter/material.dart';
import 'Apartado_C.dart'; // ← IMPORTAR Apartado_C

class ApartadoBScreen extends StatefulWidget {
  final Map<String, dynamic> datosUsuario;

  const ApartadoBScreen({super.key, required this.datosUsuario});

  @override
  State<ApartadoBScreen> createState() => _ApartadoBScreenState();
}

class _ApartadoBScreenState extends State<ApartadoBScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // IMAGEN DE FONDO (LA MISMA QUE APARTADO A)
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/OnboardingB.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),

          // BOTÓN-IMAGEN CENTRADO PARA IR A APARTADO C
          Positioned(
            left: MediaQuery.of(context).size.width / 2 - 140,
            top: MediaQuery.of(context).size.height / 2 + 276,
            child: GestureDetector(
              onTap: () {
                print('Botón de Apartado B presionado');
                _navegarAApartadoC(); // ← NAVEGA DIRECTAMENTE
              },
              child: Container(
                width: 280,
                height: 80,
                child: Image.asset(
                  'assets/images/btnSiguiente.png', // MISMA IMAGEN
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: Text(
                          'Continuar a C',
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

  // MÉTODO PARA NAVEGAR A APARTADO_C
  void _navegarAApartadoC() {
    _mostrarDatosEnConsola();

    // Navegar a Apartado_C pasando los datos
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            ApartadoCScreen(datosUsuario: widget.datosUsuario),
      ),
    );
  }

  void _mostrarDatosEnConsola() {
    print('=== DATOS RECIBIDOS EN APARTADO_B ===');
    widget.datosUsuario.forEach((key, value) {
      print('$key: $value');
    });

    // VERIFICAR ESPECÍFICAMENTE LA CONTRASEÑA
    print('🔐 CONTRASEÑA EN B: ${widget.datosUsuario['pass']}');

    if (widget.datosUsuario['categoriasSeleccionadas'] != null) {
      print(
        'Categorías seleccionadas: ${widget.datosUsuario['categoriasSeleccionadas']}',
      );
    }
  }
}
