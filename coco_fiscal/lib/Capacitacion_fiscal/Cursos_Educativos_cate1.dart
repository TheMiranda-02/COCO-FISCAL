import 'package:flutter/material.dart';
import 'curso_tarjeta.dart';

class CursosEducativosCate1 extends StatefulWidget {
  @override
  _CursosEducativosCate1State createState() => _CursosEducativosCate1State();
}

class _CursosEducativosCate1State extends State<CursosEducativosCate1> {
  // Lista de cursos para esta categoría
  final List<Map<String, dynamic>> cursos = [
    {
      'titulo': '¿Comó formalizar tu emprendimiento sin morir en el intento?',
      'imagen': 'assets/images/Miranda.png',
    },
    {
      'titulo': 'Tu primer registro fiscal, ¿Cómo darle de alta correctamente?',
      'imagen': 'assets/images/curso_rfc.png',
    },
    {
      'titulo': 'Emprender con propósito: Crea un negocio rentable',
      'imagen': 'assets/images/curso_regimenes.png',
    },
    {
      'titulo': 'Errores comunes al iniciar tu negocio',
      'imagen': 'assets/images/curso_cedula.png',
    },
    {
      'titulo': 'Guía práctica para elegir tu régimen fiscal ideal',
      'imagen': 'assets/images/curso_firma.png',
    },
    {
      'titulo': '¿Cómo emitir tus primeras facturas?',
      'imagen': 'assets/images/curso_password.png',
    },
    {
      'titulo': 'Crea tu marca, protege tu negocio y cumple con el SAT',
      'imagen': 'assets/images/curso_buzon.png',
    },
    {
      'titulo': 'Del sueño al plan: Finanzas para nuevos emprendedores',
      'imagen': 'assets/images/curso_cuentas.png',
    },
  ];

  // VARIABLES PARA CONTROLAR TAMAÑOS (Puedes modificar estos valores)
  final double anchoTarjeta = 180; // Cambia este valor para el ancho
  final double altoImagen =
      120; // Cambia este valor para la altura de la imagen
  final double tamanoLetra = 12; // Cambia este valor para el tamaño de letra
  final double altoTarjeta = 190; // Cambia este valor para la altura total

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBarPersonalizado(),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            // CONTENIDO - 4 FILAS CON 2 TARJETAS CADA UNA
            _buildGridCursos(),
          ],
        ),
      ),
    );
  }

  // AppBar personalizado para esta página
  AppBar _buildAppBarPersonalizado() {
    return AppBar(
      toolbarHeight: 60,
      title: Row(
        children: [
          Text(
            'Emprende y crece',
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
      leading: IconButton(
        icon: Icon(Icons.arrow_back, color: Colors.black),
        onPressed: () => Navigator.of(context).pop(),
      ),
    );
  }

  Widget _buildGridCursos() {
    return Column(
      children: [
        // Fila 1
        _buildFilaCursos(0, 1),
        SizedBox(height: 20),

        // Fila 2
        _buildFilaCursos(2, 3),
        SizedBox(height: 20),

        // Fila 3
        _buildFilaCursos(4, 5),
        SizedBox(height: 20),

        // Fila 4
        _buildFilaCursos(6, 7),
      ],
    );
  }

  Widget _buildFilaCursos(int index1, int index2) {
    return Row(
      children: [
        Expanded(
          child: _buildTarjetaCursoPersonalizada(
            titulo: cursos[index1]['titulo'],
            imagen: cursos[index1]['imagen'],
            onTap: () {
              if (index1 == 0) {
                // Solo para la primera tarjeta
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CursoTarjetaPage(
                      titulo: cursos[index1]['titulo'],
                      imagen: cursos[index1]['imagen'],
                    ),
                  ),
                );
              } else {
                print('Navegar a: ${cursos[index1]['titulo']}');
              }
            },
          ),
        ),
        SizedBox(width: 15),
        Expanded(
          child: _buildTarjetaCursoPersonalizada(
            titulo: cursos[index2]['titulo'],
            imagen: cursos[index2]['imagen'],
            onTap: () {
              print('Navegar a: ${cursos[index2]['titulo']}');
            },
          ),
        ),
      ],
    );
  }

  // TARJETA PERSONALIZADA CON TAMAÑOS INDEPENDIENTES
  Widget _buildTarjetaCursoPersonalizada({
    required String titulo,
    required String imagen,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: altoTarjeta, // Altura total personalizable
        margin: EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 6,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // IMAGEN DEL CURSO
            Container(
              height: altoImagen, // Altura de imagen personalizable
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                color: Colors.grey[300],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                child: Image.asset(
                  imagen,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: Colors.grey[200],
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.play_circle_fill,
                              size: 30,
                              color: Colors.green,
                            ),
                            SizedBox(height: 5),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),

            // TÍTULO DEL CURSO
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      titulo,
                      style: TextStyle(
                        fontSize: tamanoLetra, // Tamaño de letra personalizable
                        fontWeight: FontWeight.w500,
                        color: Colors.grey[800],
                        height: 1.0,
                      ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
