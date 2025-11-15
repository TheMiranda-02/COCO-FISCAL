import 'package:flutter/material.dart';
import '../Crear_Cuenta/Introduccion_B.dart'; // ← IMPORTAR Introduccion_B

class IntroduccionAScreen extends StatefulWidget {
  final Map<String, dynamic> datosUsuario;

  const IntroduccionAScreen({super.key, required this.datosUsuario});

  @override
  State<IntroduccionAScreen> createState() => _IntroduccionAScreenState();
}

class _IntroduccionAScreenState extends State<IntroduccionAScreen> {
  bool _mostrarDatos = false; // ← Controla si mostrar o no los datos

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // IMAGEN DE FONDO
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/OnboardingA.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),

          // PANEL DE DATOS (SI ESTÁ ACTIVADO)
          if (_mostrarDatos) _buildPanelDatos(),

          // BOTÓN-IMAGEN CENTRADO
          Positioned(
            left: MediaQuery.of(context).size.width / 2 - 140,
            top: MediaQuery.of(context).size.height / 2 + 276,
            child: GestureDetector(
              onTap: _navegarAIntroduccionB,
              child: Container(
                width: 280,
                height: 80,
                child: Image.asset(
                  'assets/images/btnContinuar.png',
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: Text(
                          'Continuar',
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

  // WIDGET PARA MOSTRAR EL PANEL DE DATOS
  Widget _buildPanelDatos() {
    return Positioned(
      top: 80,
      left: 20,
      right: 20,
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 10,
              offset: Offset(0, 4),
            ),
          ],
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Datos del Usuario',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.close, size: 20),
                    onPressed: () {
                      setState(() {
                        _mostrarDatos = false;
                      });
                    },
                  ),
                ],
              ),
              SizedBox(height: 10),

              // DATOS PERSONALES
              _buildDatoItem('📧 Email:', widget.datosUsuario['email']),
              _buildDatoItem('🔐 Contraseña:', widget.datosUsuario['pass']),
              _buildDatoItem('👤 Nombre:', widget.datosUsuario['nombre']),
              _buildDatoItem('📄 RFC:', widget.datosUsuario['rfc']),
              _buildDatoItem(
                '🏛️ Régimen:',
                widget.datosUsuario['regimenFiscal'],
              ),
              _buildDatoItem(
                '📱 Celular:',
                '${widget.datosUsuario['lada']} ${widget.datosUsuario['celular']}',
              ),

              // CATEGORÍAS SELECCIONADAS
              if (widget.datosUsuario['categoriasSeleccionadas'] != null) ...[
                SizedBox(height: 10),
                Text(
                  'Categorías Seleccionadas:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 5),
                Text(
                  widget.datosUsuario['categoriasSeleccionadas'].toString(),
                  style: TextStyle(fontSize: 12),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  // WIDGET AUXILIAR PARA MOSTRAR CADA DATO
  Widget _buildDatoItem(String label, String? value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade700,
            ),
          ),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              value ?? 'No especificado',
              style: TextStyle(fontSize: 14, color: Colors.grey.shade800),
            ),
          ),
        ],
      ),
    );
  }

  void _navegarAIntroduccionB() {
    _mostrarDatosEnConsola();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            ApartadoBScreen(datosUsuario: widget.datosUsuario),
      ),
    );
  }

  void _mostrarDatosEnConsola() {
    print('=== DATOS RECIBIDOS EN INTRODUCCION_A ===');
    widget.datosUsuario.forEach((key, value) {
      print('$key: $value');
    });
    print('🔐 CONTRASEÑA: ${widget.datosUsuario['pass']}');
  }
}
