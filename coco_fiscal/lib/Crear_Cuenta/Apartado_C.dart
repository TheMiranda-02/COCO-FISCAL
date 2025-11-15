import 'package:flutter/material.dart';
import 'Apartado_D.dart'; // ← IMPORTAR Apartado_D

class ApartadoCScreen extends StatefulWidget {
  final Map<String, dynamic> datosUsuario;

  const ApartadoCScreen({super.key, required this.datosUsuario});

  @override
  State<ApartadoCScreen> createState() => _ApartadoCScreenState();
}

class _ApartadoCScreenState extends State<ApartadoCScreen> {
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
                image: AssetImage('assets/images/OnboardingC.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),

          // PANEL DE DATOS (SI ESTÁ ACTIVADO)
          if (_mostrarDatos) _buildPanelDatos(),

          // BOTÓN-IMAGEN CENTRADO PARA IR A APARTADO D
          Positioned(
            left: MediaQuery.of(context).size.width / 2 - 140,
            top: MediaQuery.of(context).size.height / 2 + 296,
            child: GestureDetector(
              onTap: () {
                print('Botón de Apartado C presionado');
                _navegarAApartadoD(); // ← NUEVO MÉTODO
              },
              child: Container(
                width: 280,
                height: 80,
                child: Image.asset(
                  'assets/images/btnSiguiente.png',
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      decoration: BoxDecoration(
                        color: Colors.purple, // Color diferente
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
                          'Ir a D',
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

  // WIDGET PARA MOSTRAR EL PANEL DE DATOS (IGUAL QUE EN A)
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
                    'Datos en Apartado C',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.purple, // Color que combine
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

  // NUEVO MÉTODO PARA NAVEGAR A APARTADO_D
  void _navegarAApartadoD() {
    _mostrarDatosEnConsola();

    // Navegar a Apartado_D pasando los datos
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            ApartadoDScreen(datosUsuario: widget.datosUsuario),
      ),
    );
  }

  void _mostrarDatosEnConsola() {
    print('=== DATOS RECIBIDOS EN APARTADO_C ===');
    widget.datosUsuario.forEach((key, value) {
      print('$key: $value');
    });
    print('🔐 CONTRASEÑA EN C: ${widget.datosUsuario['pass']}');
  }
}
