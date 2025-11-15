import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'Estilos/diseños_form_comentario.dart';

class FormComentarioCurso extends StatefulWidget {
  @override
  _FormComentarioCursoState createState() => _FormComentarioCursoState();
}

class _FormComentarioCursoState extends State<FormComentarioCurso> {
  double _puntuacion = 0.0;
  final TextEditingController _comentarioController = TextEditingController();
  bool _guardando = false;

  // Método para guardar en la base de datos
  Future<void> _guardarCalificacion() async {
    if (_puntuacion == 0) {
      _mostrarError('Por favor selecciona una calificación');
      return;
    }

    setState(() {
      _guardando = true;
    });

    try {
      final url = Uri.parse(
        'http://192.168.100.8/api_coco/guardar_calificacion.php',
      );

      Map<String, dynamic> datosCalificacion = {
        'puntuacion': _puntuacion.toInt(),
        'comentario': _comentarioController.text,
      };

      print('Enviando datos: $datosCalificacion'); // DEBUG

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(datosCalificacion),
      );

      print('Respuesta del servidor: ${response.statusCode}'); // DEBUG
      print('Cuerpo de respuesta: ${response.body}'); // DEBUG

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success'] == true) {
          _mostrarExito(data['message']);
        } else {
          _mostrarError(data['message']);
        }
      } else {
        _mostrarError('Error del servidor: ${response.statusCode}');
      }
    } catch (e) {
      print('Error completo: $e'); // DEBUG
      _mostrarError('Error de conexión: $e');
    } finally {
      setState(() {
        _guardando = false;
      });
    }
  }

  void _mostrarError(String mensaje) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(mensaje),
        backgroundColor: Colors.red,
        duration: Duration(seconds: 3),
      ),
    );
  }

  void _mostrarExito(String mensaje) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(mensaje),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 3),
      ),
    );
  }

  void _enviarComentario() {
    _guardarCalificacion();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: FormComentarioDesigns.buildAppBar(),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // IMAGEN Y DESCRIPCIÓN DEL CURSO
            FormComentarioDesigns.buildInfoCurso(
              imagen: 'assets/images/curso_ejemplo.png',
              titulo: 'Nombre del Curso',
              descripcion: 'Nombre del profesional',
              alturaImagen: 100,
              anchoImagen: 140,
            ),
            SizedBox(height: 30),

            // CALIFICACIÓN CON ESTRELLAS
            FormComentarioDesigns.buildCalificacionEstrellas(
              puntuacion: _puntuacion,
              onPuntuacionCambiada: (double nuevaPuntuacion) {
                setState(() {
                  _puntuacion = nuevaPuntuacion;
                });
              },
              tamanoEstrellas: 30,
            ),
            SizedBox(height: 25),

            // FORMULARIO DE COMENTARIO
            FormComentarioDesigns.buildCampoComentario(
              controller: _comentarioController,
              onChanged: (valor) {
                // Puedes usar este callback si necesitas
              },
            ),
            SizedBox(height: 30),

            // BOTÓN ENVIAR
            _guardando
                ? Center(child: CircularProgressIndicator())
                : FormComentarioDesigns.buildBotonEnviar(
                    onPressed: _enviarComentario,
                  ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _comentarioController.dispose();
    super.dispose();
  }
}
