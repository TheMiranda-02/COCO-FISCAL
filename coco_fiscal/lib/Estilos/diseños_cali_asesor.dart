import 'package:flutter/material.dart';

class CaliAsesorDesigns {
  static AppBar buildAppBar() {
    return AppBar(
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

  // INFORMACIÓN DEL ASESOR (Imagen + Título + Descripción)
  static Widget buildInfoAsesor({
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
                    color: Colors.blue[50], // ← Color diferente para asesor
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(Icons.person, size: 30, color: Colors.blue),
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

  // CALIFICACIÓN CON ESTRELLAS - TEXTO IZQUIERDA, ESTRELLAS CENTRADAS
  static Widget buildCalificacionEstrellas({
    required double puntuacion,
    required Function(double) onPuntuacionCambiada,
    double tamanoEstrellas = 30,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start, // ← TEXTO A LA IZQUIERDA
      children: [
        Text(
          '¿Qué opinas de esta asesoría?',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
        SizedBox(height: 10),

        // ESTRELLAS CENTRADAS
        Row(
          mainAxisAlignment: MainAxisAlignment.center, // ← ESTRELLAS CENTRADAS
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

  // CAMPO DE COMENTARIO
  static Widget buildCampoComentario({
    required TextEditingController controller,
    required Function(String) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 10),
        Container(
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: Colors.grey[700]!, // ← Línea gris obscura
                width: 1.5,
              ),
            ),
          ),
          child: TextField(
            controller: controller,
            onChanged: onChanged,
            maxLines: 5,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              contentPadding: EdgeInsets.only(bottom: -80),
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              hintText: 'Escribe tu opinión',
              hintStyle: TextStyle(color: Colors.grey[500]),
            ),
          ),
        ),
      ],
    );
  }

  // BOTÓN ENVIAR COMO IMAGEN - MISMO TAMAÑO QUE EL ANTERIOR
  static Widget buildBotonEnviarImagen({required VoidCallback onPressed}) {
    return Center(
      child: GestureDetector(
        onTap: onPressed,
        child: Container(
          width: 270, // ← MISMO TAMAÑO (270)
          height: 50, // ← MISMO TAMAÑO (50)
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
            width: 270, // ← MISMO TAMAÑO
            height: 50, // ← MISMO TAMAÑO
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              // Fallback si la imagen no carga
              return Container(
                width: 270,
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Center(
                  child: Text(
                    'ENVIAR COMENTARIO',
                    style: TextStyle(
                      fontSize: 16, // ← TEXTO AJUSTADO
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
