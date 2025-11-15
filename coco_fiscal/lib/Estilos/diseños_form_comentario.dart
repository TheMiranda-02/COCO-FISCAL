import 'package:flutter/material.dart';

class FormComentarioDesigns {
  static AppBar buildAppBar() {
    return AppBar(
      // automaticallyImplyLeading: false,
      toolbarHeight: 60,
      title: Row(
        children: [
          Text(
            'Calificar y opinar',
            style: TextStyle(
              color: const Color.fromARGB(255, 0, 0, 0),
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
        ],
      ),
      backgroundColor: Colors.white,
      elevation: 0,
      actions: [
        // Puedes agregar acciones si las necesitas
      ],
    );
  }

  // INFORMACIÓN DEL CURSO (Imagen + Título + Descripción)
  static Widget buildInfoCurso({
    required String imagen,
    required String titulo,
    required String descripcion,
    double alturaImagen = 80,
    double anchoImagen = 80,
  }) {
    return Row(
      children: [
        // IMAGEN (tamaño personalizable)
        Container(
          width: anchoImagen,
          height: alturaImagen,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: Colors.grey[100],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.asset(
              imagen,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  decoration: BoxDecoration(
                    color: Colors.green[50],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.play_circle_fill,
                    size: 30,
                    color: Colors.green,
                  ),
                );
              },
            ),
          ),
        ),
        SizedBox(width: 15),

        // TÍTULO Y DESCRIPCIÓN
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                titulo,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 4),
              Text(
                descripcion,
                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // CALIFICACIÓN CON ESTRELLAS
  static Widget buildCalificacionEstrellas({
    required double puntuacion,
    required Function(double) onPuntuacionCambiada,
    double tamanoEstrellas = 30,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start, // ← CAMBIAR A START
      children: [
        Text(
          'Califica este curso',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
        SizedBox(height: 10),

        // ESTRELLAS - Ahora alineadas a la izquierda
        Row(
          mainAxisAlignment: MainAxisAlignment.center, // ← CAMBIAR A START
          children: List.generate(5, (index) {
            return IconButton(
              onPressed: () {
                onPuntuacionCambiada((index + 1).toDouble());
              },
              icon: Icon(
                index < puntuacion ? Icons.star : Icons.star_border,
                color: Colors.amber,
                size: tamanoEstrellas,
              ),
              padding: EdgeInsets.symmetric(horizontal: 4),
            );
          }),
        ),
      ],
    );
  }

  /// CAMPO DE COMENTARIO
  static Widget buildCampoComentario({
    required TextEditingController controller,
    required Function(String) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // SOLUCIÓN CORRECTA: Usar TextField normal con underline
        TextField(
          controller: controller,
          onChanged: onChanged,
          maxLines: 5,
          minLines: 1, // ← Esto ayuda a controlar la altura inicial
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            contentPadding: EdgeInsets.symmetric(horizontal: 0, vertical: 12),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: Colors.grey[700]!, // ← Línea gris obscura
                width: 1.5,
              ),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: Colors.green, // ← Línea verde cuando está enfocado
                width: 1.5,
              ),
            ),
            hintText: '¿Qué opinas de este curso?',
            hintStyle: TextStyle(color: Colors.grey[500]),
          ),
        ),
      ],
    );
  }

  // BOTÓN ENVIAR COMO IMAGEN - TAMAÑO AUMENTADO
  static Widget buildBotonEnviar({required VoidCallback onPressed}) {
    return Center(
      child: GestureDetector(
        onTap: onPressed,
        child: Container(
          width: 270, // ← AUMENTADO de 150 a 250
          height: 50, // ← AUMENTADO de 50 a 70
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 8,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Image.asset(
            'assets/images/btnEnviar.png',
            width: 400, // ← AUMENTADO para coincidir con el contenedor
            height: 70, // ← AUMENTADO para coincidir con el contenedor
            fit: BoxFit.cover, // ← Cambiado a cover para mejor ajuste
            errorBuilder: (context, error, stackTrace) {
              // Fallback si la imagen no carga
              return Container(
                width: 250,
                height: 70,
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Center(
                  child: Text(
                    'ENVIAR COMENTARIO',
                    style: TextStyle(
                      fontSize: 18, // ← TEXTO MÁS GRANDE
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
    );
  }
}
