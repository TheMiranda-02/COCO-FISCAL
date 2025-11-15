import 'package:flutter/material.dart';
import 'Apartado_E.dart'; // ← IMPORTAR Apartado_E

class ApartadoDScreen extends StatefulWidget {
  final Map<String, dynamic> datosUsuario;

  const ApartadoDScreen({super.key, required this.datosUsuario});

  @override
  State<ApartadoDScreen> createState() => _ApartadoDScreenState();
}

class _ApartadoDScreenState extends State<ApartadoDScreen> {
  bool _mostrarDatos = false;

  // Método para mostrar el diálogo de notificaciones
  void _mostrarDialogoNotificaciones() {
    showDialog(
      context: context,
      barrierColor: Colors.black54, // Fondo semi-obscuro
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: EdgeInsets.all(20),
          child: Container(
            padding: EdgeInsets.all(30),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 20,
                  offset: Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // CAMPANITA EN VERDE
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: Color(0xFF6BB187), // Verde
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.notifications,
                    color: Colors.white,
                    size: 40,
                  ),
                ),

                SizedBox(height: 25),

                // PREGUNTA
                Text(
                  '¿Permitir que Coco Fiscal te envíe notificaciones?',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),

                SizedBox(height: 30),

                // BOTONES PERMITIR - NO PERMITIR
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // BOTÓN NO PERMITIR
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.only(right: 10),
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pop(); // Cerrar diálogo
                            _navegarAApartadoE(); // Navegar a Apartado E
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey.shade300,
                            foregroundColor: Colors.black87,
                            padding: EdgeInsets.symmetric(vertical: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 2,
                          ),
                          child: Text(
                            'No Permitir',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),

                    // BOTÓN PERMITIR
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.only(left: 10),
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pop(); // Cerrar diálogo
                            _navegarAApartadoE(); // Navegar a Apartado E
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF6BB187), // Verde
                            foregroundColor: Colors.white,
                            padding: EdgeInsets.symmetric(vertical: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 2,
                          ),
                          child: Text(
                            'Permitir',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

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
                image: AssetImage('assets/images/OnboardingD.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),

          // PANEL DE DATOS (SI ESTÁ ACTIVADO)
          if (_mostrarDatos) _buildPanelDatos(),

          // BOTÓN-IMAGEN CENTRADO PARA IR A APARTADO E
          Positioned(
            left: MediaQuery.of(context).size.width / 2 - 140,
            top: MediaQuery.of(context).size.height / 2 + 276,
            child: GestureDetector(
              onTap: () {
                print('Botón de Apartado D presionado');
                _mostrarDialogoNotificaciones(); // ← AHORA ABRE EL DIÁLOGO
              },
              child: Container(
                width: 280,
                height: 100,
                child: Image.asset(
                  'assets/images/btnSiguiente.png', // MISMA IMAGEN
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      decoration: BoxDecoration(
                        color: Colors.orange, // Color diferente para distinguir
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: Text(
                          'Ir a E',
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
                    'Datos en Apartado D',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.orange,
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

  // MÉTODO PARA NAVEGAR A APARTADO_E
  void _navegarAApartadoE() {
    _mostrarDatosEnConsola();

    // Navegar a Apartado_E pasando los datos
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            ApartadoEScreen(datosUsuario: widget.datosUsuario),
      ),
    );
  }

  void _mostrarDatosEnConsola() {
    print('=== DATOS RECIBIDOS EN APARTADO_D ===');
    widget.datosUsuario.forEach((key, value) {
      print('$key: $value');
    });
    print('🔐 CONTRASEÑA EN D: ${widget.datosUsuario['pass']}');
  }
}
