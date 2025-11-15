import 'package:flutter/material.dart';
import '../Capacitacion_fiscal/mis_cursosA.dart';

class CursosDesigns {
  static AppBar buildAppBar(BuildContext context) {
    return AppBar(
      toolbarHeight: 60,
      title: Row(
        children: [
          Text(
            'Cursos Educativos',
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
        Padding(
          padding: EdgeInsets.only(right: 16.0),
          child: Container(
            width: 40,
            height: 40,
            child: IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        MisCursosAPage(), // ← Ajusta el nombre según tu clase
                  ),
                );
              },
              icon: Image.asset(
                'assets/images/ObligacionesA.png',
                width: 24,
                height: 24,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return Icon(Icons.more_vert, size: 24, color: Colors.black);
                },
              ),
              padding: EdgeInsets.zero,
            ),
          ),
        ),
      ],
    );
  }

  // CARRUSEL DE CURSOS POR CATEGORÍA
  static Widget buildCategoriaCursos({
    required String titulo,
    required List<Map<String, dynamic>> cursos,
    required VoidCallback onVerTodo,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              titulo,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.grey[800],
              ),
            ),
            Container(
              width: 35,
              height: 35,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.green,
              ),
              child: IconButton(
                onPressed: onVerTodo,
                icon: Icon(Icons.arrow_forward, color: Colors.white, size: 18),
                padding: EdgeInsets.zero,
              ),
            ),
          ],
        ),
        SizedBox(height: 15),
        Container(
          height: 140,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: cursos.length,
            itemBuilder: (context, index) {
              return _buildTarjetaCurso(cursos[index]);
            },
          ),
        ),
      ],
    );
  }

  static Widget _buildTarjetaCurso(Map<String, dynamic> curso) {
    return GestureDetector(
      onTap: () {
        print('Navegar a curso: ${curso['titulo']}');
      },
      child: Container(
        width: 190,
        margin: EdgeInsets.only(right: 15, top: 5, bottom: 5, left: 5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              blurRadius: 6,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: ClipRRect(
          // ← ENVOLVER TODO EN ClipRRect
          borderRadius: BorderRadius.circular(12),
          child: Container(
            height: 170, // ← ALTURA FIJA PARA TODA LA TARJETA
            width: double.infinity,
            decoration: BoxDecoration(color: Colors.grey[300]),
            child: Image.asset(
              curso['imagen'],
              fit: BoxFit.cover, // ← HACER QUE LA IMAGEN OCUPE TODO EL ESPACIO
              errorBuilder: (context, error, stackTrace) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.play_circle_fill,
                        size: 30,
                        color: Colors.green,
                      ),
                      SizedBox(height: 5),
                      Text(
                        'Curso',
                        style: TextStyle(fontSize: 10, color: Colors.grey),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  // Puedes mantener los otros métodos que ya tenías aquí
}
