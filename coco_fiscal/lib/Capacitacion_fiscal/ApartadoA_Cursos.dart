import 'package:flutter/material.dart';
import '../Estilos/diseños_cursos.dart';
import 'Cursos_Educativos_cate1.dart';

class ApartadoACursos extends StatefulWidget {
  @override
  _ApartadoACursosState createState() => _ApartadoACursosState();
}

class _ApartadoACursosState extends State<ApartadoACursos> {
  // Datos de ejemplo para las categorías de cursos
  final List<Map<String, dynamic>> cursosCategoria1 = [
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
  ];

  final List<Map<String, dynamic>> cursosCategoria2 = [
    {'titulo': 'CFDI 4.0', 'imagen': 'assets/images/curso_cfdi.png'},
    {'titulo': 'Timbre Digital', 'imagen': 'assets/images/curso_timbre.png'},
    {
      'titulo': 'Complementos',
      'imagen': 'assets/images/curso_complementos.png',
    },
    {'titulo': 'Factura Global', 'imagen': 'assets/images/curso_global.png'},
  ];

  final List<Map<String, dynamic>> cursosCategoria3 = [
    {'titulo': 'Declaración Anual', 'imagen': 'assets/images/curso_anual.png'},
    {
      'titulo': 'Declaración Mensual',
      'imagen': 'assets/images/curso_mensual.png',
    },
    {
      'titulo': 'Pagos Provisionales',
      'imagen': 'assets/images/curso_pagos.png',
    },
    {
      'titulo': 'Devoluciones',
      'imagen': 'assets/images/curso_devoluciones.png',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CursosDesigns.buildAppBar(context),
      body: Column(
        children: [
          // Usar Expanded para que ocupe el espacio disponible
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(20),
              child: _buildCursosPorCategoria(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCursosPorCategoria() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CursosDesigns.buildCategoriaCursos(
          titulo: 'Emprende y crece',
          cursos: cursosCategoria1,
          onVerTodo: () {
            Navigator.push(
              context,
              PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) =>
                    CursosEducativosCate1(),
                transitionsBuilder:
                    (context, animation, secondaryAnimation, child) {
                      const begin = Offset(1.0, 0.0);
                      const end = Offset.zero;
                      const curve = Curves.easeInOut;
                      var tween = Tween(
                        begin: begin,
                        end: end,
                      ).chain(CurveTween(curve: curve));
                      var offsetAnimation = animation.drive(tween);
                      return SlideTransition(
                        position: offsetAnimation,
                        child: child,
                      );
                    },
                transitionDuration: Duration(milliseconds: 500),
              ),
            );
          },
        ),
        SizedBox(height: 20),
        CursosDesigns.buildCategoriaCursos(
          titulo: 'Todo Sobre RESICO',
          cursos: cursosCategoria2,
          onVerTodo: () {
            print('Navegar a categoría Facturación Electrónica');
          },
        ),
        SizedBox(height: 20),
        CursosDesigns.buildCategoriaCursos(
          titulo: 'Seguridad Social',
          cursos: cursosCategoria3,
          onVerTodo: () {
            print('Navegar a categoría Declaraciones');
          },
        ),
        SizedBox(height: 20),
        CursosDesigns.buildCategoriaCursos(
          titulo: 'Evita multas',
          cursos: cursosCategoria3,
          onVerTodo: () {
            print('Navegar a categoría Declaraciones');
          },
        ),
        SizedBox(height: 20),
        CursosDesigns.buildCategoriaCursos(
          titulo: 'Educación financiera',
          cursos: cursosCategoria3,
          onVerTodo: () {
            print('Navegar a categoría Declaraciones');
          },
        ),
        SizedBox(height: 40), // Espacio extra al final para mejor scroll
      ],
    );
  }
}
