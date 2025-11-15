import 'package:flutter/material.dart';
import '/Form_crear_suscripcion.dart'; // ← IMPORTAR FormSuscripcionScreen

class ApartadoEScreen extends StatefulWidget {
  final Map<String, dynamic> datosUsuario;

  const ApartadoEScreen({super.key, required this.datosUsuario});

  @override
  State<ApartadoEScreen> createState() => _ApartadoEScreenState();
}

class _ApartadoEScreenState extends State<ApartadoEScreen> {
  bool _mostrarDatos = false;

  @override
  void initState() {
    super.initState();
    _mostrarDatosEnConsola();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // IMAGEN DE FONDO (LA MISMA)
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/OnboardingE.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),

          // PANEL DE DATOS (SI ESTÁ ACTIVADO)
          if (_mostrarDatos) _buildPanelDatos(),

          // BOTÓN-IMAGEN PARA IR A SUSCRIPCIÓN
          Positioned(
            left: MediaQuery.of(context).size.width / 2 - 145,
            top: MediaQuery.of(context).size.height / 2 + 276,
            child: GestureDetector(
              onTap: () {
                print(
                  'Botón de Apartado E presionado - Navegando a Suscripción',
                );
                _navegarASuscripcion(); // ← NUEVO MÉTODO
              },
              child: Container(
                width: 280,
                height: 100,
                child: Image.asset(
                  'assets/images/btnSiguiente.png', // ← RUTA DE TU IMAGEN
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    // Esto se muestra si la imagen no carga
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
                          'Ir a Suscripción',
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
                    'Datos en Apartado E (Final)',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
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
              _buildDatoItem(
                '🎯 Categorías:',
                widget.datosUsuario['categoriasSeleccionadas']?.toString() ??
                    'No especificadas',
              ),

              // RESUMEN DEL VIAJE
              SizedBox(height: 15),
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.green.shade200),
                ),
                child: Row(
                  children: [
                    Icon(Icons.flag, color: Colors.green),
                    SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Los datos han viajado exitosamente a través de 5 pantallas',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.green.shade800,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
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

  // NUEVO MÉTODO PARA NAVEGAR A FORM_SUSCRIPCION
  void _navegarASuscripcion() {
    _mostrarDatosEnConsola();

    // Navegar a FormSuscripcionScreen pasando los datos
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            FormSuscripcionScreen(datosUsuario: widget.datosUsuario),
      ),
    );
  }

  void _mostrarDatosEnConsola() {
    print('=== DATOS RECIBIDOS EN APARTADO_E (FINAL) ===');
    widget.datosUsuario.forEach((key, value) {
      print('$key: $value');
    });
    print('🔐 CONTRASEÑA EN E: ${widget.datosUsuario['pass']}');
    print(
      '✅ FLUJO COMPLETADO: Los datos han viajado desde CrearCuenta hasta Apartado_E',
    );
  }
}
