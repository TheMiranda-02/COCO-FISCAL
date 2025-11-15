import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import './Crear_Cuenta/Apartado_F.dart';

class FormSuscripcionScreen extends StatefulWidget {
  final Map<String, dynamic> datosUsuario;

  const FormSuscripcionScreen({super.key, required this.datosUsuario});

  @override
  State<FormSuscripcionScreen> createState() => _FormSuscripcionScreenState();
}

class _FormSuscripcionScreenState extends State<FormSuscripcionScreen> {
  String _suscripcionSeleccionada = 'Freemium';
  bool _guardando = false;
  bool _datosGuardados = false;

  void _seleccionarSuscripcion(String tipo) {
    setState(() {
      _suscripcionSeleccionada = tipo;
    });
  }

  // MÉTODO PARA GUARDAR EN LA BASE DE DATOS
  Future<void> _guardarUsuario() async {
    if (_datosGuardados) {
      _navegarAHome();
      return;
    }

    setState(() {
      _guardando = true;
    });

    try {
      final url = Uri.parse(
        'http://192.168.100.8/api_coco/guardar_usuario.php',
      );

      // Preparar datos para el INSERT - SOLO CAMPOS DE LA TABLA usuario
      Map<String, dynamic> datos = {
        'nombre': widget.datosUsuario['nombre'] ?? '',
        'rfc': widget.datosUsuario['rfc'] ?? '',
        'regimenFiscal': widget.datosUsuario['regimenFiscal'] ?? '',
        'email': widget.datosUsuario['email'] ?? '',
        'pass': widget.datosUsuario['pass'] ?? '',
        'lada': widget.datosUsuario['lada'] ?? '',
        'celular': widget.datosUsuario['celular'] ?? '',
        'fechaNacimiento': widget.datosUsuario['fechaNacimiento'] ?? '',
        'calle': widget.datosUsuario['calle'] ?? '',
        'colonia': widget.datosUsuario['colonia'] ?? '',
        'numero': widget.datosUsuario['numero'] ?? '',
        'cp': widget.datosUsuario['cp'] ?? '',
        'ciudad': widget.datosUsuario['ciudad'] ?? '',
        'estado': widget.datosUsuario['estado'] ?? '',
        'pais': widget.datosUsuario['pais'] ?? '',
      };

      print('🎯 Enviando datos a: http://192.168.100.8/guardar_usuario.php');
      print('📊 Datos a enviar:');
      datos.forEach((key, value) {
        print('   $key: $value');
      });

      final response = await http
          .post(
            url,
            headers: {'Content-Type': 'application/json; charset=UTF-8'},
            body: jsonEncode(datos),
          )
          .timeout(Duration(seconds: 15));

      print('📡 Respuesta del servidor:');
      print('   Status Code: ${response.statusCode}');
      print('   Body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success'] == true) {
          // MOSTRAR DIÁLOGO EMERGENTE EN LUGAR DEL SNACKBAR
          _mostrarDialogoExito();
          setState(() {
            _datosGuardados = true;
          });
        } else {
          _mostrarError('Error: ${data['message']}');
        }
      } else {
        _mostrarError('Error HTTP: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ Error en la conexión: $e');
      _mostrarError('Error de conexión: $e');
    } finally {
      setState(() {
        _guardando = false;
      });
    }
  }

  // MÉTODO PARA MOSTRAR EL DIÁLOGO DE ÉXITO
  void _mostrarDialogoExito() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center, // Centrar título
            children: [
              Icon(Icons.check_circle, color: Colors.green, size: 20),
              SizedBox(width: 10),
              Text(
                "¡Registro Completado!",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
            ],
          ),
          content: Text(
            "Tu cuenta ha sido registrada exitosamente. Ahora puedes continuar a la siguiente pantalla.",
            style: TextStyle(fontSize: 16),
            textAlign: TextAlign.center,
          ),
          actionsAlignment: MainAxisAlignment.center, // ← AQUÍ CENTRAMOS
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _navegarAHome();
              },
              style: TextButton.styleFrom(
                backgroundColor: Color(0xFF6BB187),
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(
                "Siguiente",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        );
      },
    );
  }

  void _navegarAHome() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            ApartadoFScreen(datosUsuario: widget.datosUsuario),
      ),
    );
  }

  void _mostrarError(String mensaje) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(mensaje),
        backgroundColor: Colors.red,
        duration: Duration(seconds: 4),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Escoge tu suscripción'),
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // CONTENEDOR OVALADO MEJORADO - SIMULA SER UNO SOLO
            Container(
              width: double.infinity,
              height: 46,
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(30),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Stack(
                children: [
                  // FONDO VERDE QUE SE MUEVE (EL "OVALITO" INTERNO)
                  AnimatedPositioned(
                    duration: Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                    left: _suscripcionSeleccionada == 'Freemium'
                        ? 0
                        : MediaQuery.of(context).size.width / 2 - 40,
                    right: _suscripcionSeleccionada == 'Freemium'
                        ? MediaQuery.of(context).size.width / 2 - 40
                        : 0,
                    top: 0,
                    bottom: 0,
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 20, 143, 75),
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                  ),

                  // TEXTO FREEMIUM
                  Positioned(
                    left: 0,
                    right: MediaQuery.of(context).size.width / 2,
                    top: 0,
                    bottom: 0,
                    child: GestureDetector(
                      onTap: () => _seleccionarSuscripcion('Freemium'),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(30),
                            bottomLeft: Radius.circular(30),
                          ),
                        ),
                        child: Center(
                          child: Text(
                            'Freemium',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: _suscripcionSeleccionada == 'Freemium'
                                  ? Colors.white
                                  : Colors.grey.shade700,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  // TEXTO PREMIUM
                  Positioned(
                    left: MediaQuery.of(context).size.width / 2,
                    right: 0,
                    top: 0,
                    bottom: 0,
                    child: GestureDetector(
                      onTap: () => _seleccionarSuscripcion('Premium'),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(30),
                            bottomRight: Radius.circular(30),
                          ),
                        ),
                        child: Center(
                          child: Text(
                            'Premium',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: _suscripcionSeleccionada == 'Premium'
                                  ? Colors.white
                                  : Colors.grey.shade700,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // CONTENEDOR CON IMAGEN Y BOTÓN SUPERPUESTO
            Container(
              width: double.infinity,
              child: Stack(
                children: [
                  // IMAGEN DE FONDO
                  Container(
                    width: double.infinity,
                    child: _suscripcionSeleccionada == 'Freemium'
                        ? Image.asset(
                            'assets/images/PlanFreemium.png',
                            fit: BoxFit.fitWidth,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                decoration: BoxDecoration(
                                  color: const Color.fromARGB(
                                    255,
                                    255,
                                    255,
                                    255,
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Center(
                                  child: Text('Error cargando imagen Freemium'),
                                ),
                              );
                            },
                          )
                        : Image.asset(
                            'assets/images/PlanPremium.png',
                            fit: BoxFit.fitWidth,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                decoration: BoxDecoration(
                                  color: Colors.green.shade50,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Center(
                                  child: Text('Error cargando imagen Premium'),
                                ),
                              );
                            },
                          ),
                  ),

                  // BOTÓN SUPERPUESTO SOBRE LA IMAGEN
                  Positioned(
                    left: 20,
                    right: 20,
                    bottom: 32,
                    child: _guardando
                        ? Center(child: CircularProgressIndicator())
                        : GestureDetector(
                            onTap: _guardarUsuario,
                            child: Container(
                              width: double.infinity,
                              child: _suscripcionSeleccionada == 'Freemium'
                                  ? Image.asset(
                                      'assets/images/btnFree.png',
                                      fit: BoxFit.contain,
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                            return Container(
                                              padding: EdgeInsets.symmetric(
                                                vertical: 12,
                                                horizontal: 20,
                                              ),
                                              decoration: BoxDecoration(
                                                color: _datosGuardados
                                                    ? Colors.green
                                                    : Colors.blue,
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                              ),
                                              child: Center(
                                                child: Text(
                                                  _datosGuardados
                                                      ? 'Ir a Home'
                                                      : 'Continuar con Freemium',
                                                  style: TextStyle(
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.w600,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ),
                                            );
                                          },
                                    )
                                  : Image.asset(
                                      'assets/images/btnPremium.png',
                                      fit: BoxFit.contain,
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                            return Container(
                                              padding: EdgeInsets.symmetric(
                                                vertical: 12,
                                                horizontal: 20,
                                              ),
                                              decoration: BoxDecoration(
                                                color: _datosGuardados
                                                    ? Colors.green
                                                    : Colors.green,
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                              ),
                                              child: Center(
                                                child: Text(
                                                  _datosGuardados
                                                      ? 'Ir a Home'
                                                      : 'Continuar con Premium',
                                                  style: TextStyle(
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.w600,
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
            ),

            // MENSAJE INFORMATIVO CUANDO LOS DATOS YA SE GUARDARON
            if (_datosGuardados)
              Container(
                width: double.infinity,
                margin: EdgeInsets.only(top: 20),
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.green.shade200),
                ),
                child: Row(
                  children: [
                    Icon(Icons.check_circle, color: Color(0xFF6BB187)),
                    SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        '✅ Cuenta registrada exitosamente. Presiona el botón nuevamente para continuar.',
                        style: TextStyle(
                          color: Color(0xFF6BB187),
                          fontSize: 14,
                        ),
                      ),
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
