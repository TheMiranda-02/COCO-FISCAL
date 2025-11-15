import 'package:flutter/material.dart';
import 'Estilos/diseños_categoria_noticias.dart';
import '../CFDI_recientes/tercer_cfdi.dart'; // ← IMPORTAR LA PANTALLA DESTINO

class NoticiasRecomendadaCate1 extends StatefulWidget {
  @override
  _NoticiasRecomendadaCate1State createState() =>
      _NoticiasRecomendadaCate1State();
}

class _NoticiasRecomendadaCate1State extends State<NoticiasRecomendadaCate1> {
  // Lista de noticias para esta categoría
  final List<Map<String, dynamic>> noticias = [
    {
      'titulo': 'Reformas Fiscales 2024',
      'imagen': 'assets/images/noticia_reformas.png',
      'destino': null, // ← AGREGAR DESTINO ESPECÍFICO
    },
    {
      'titulo': 'Nuevas Obligaciones',
      'imagen': 'assets/images/noticia_obligaciones.png',
      'destino': null,
    },
    {
      'titulo': 'Declaraciones',
      'imagen': 'assets/images/noticia_cambios.png',
      'destino':
          TercerCFDIScreen(), // ← ESPECIFICAR DESTINO PARA "DECLARACIONES"
    },
    {
      'titulo': 'Plazos Fiscales',
      'imagen': 'assets/images/noticia_plazos.png',
      'destino': null,
    },
    {
      'titulo': 'Actualización CFDI',
      'imagen': 'assets/images/noticia_cfdi.png',
      'destino': null,
    },
    {
      'titulo': 'Guía Rápida SAT',
      'imagen': 'assets/images/noticia_guia.png',
      'destino': null,
    },
    {
      'titulo': 'Deducciones Personales',
      'imagen': 'assets/images/noticia_deducciones.png',
      'destino': null,
    },
    {
      'titulo': 'Tips Fiscales',
      'imagen': 'assets/images/noticia_tips.png',
      'destino': null,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CategoriaNoticiasDesigns.buildAppBar(titulo: 'Noticias Fiscales'),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            // CONTENIDO - 4 FILAS CON 2 TARJETAS CADA UNA
            _buildGridNoticias(),
          ],
        ),
      ),
    );
  }

  Widget _buildGridNoticias() {
    return Column(
      children: [
        // Fila 1
        _buildFilaNoticias(0, 1),
        SizedBox(height: 20),

        // Fila 2
        _buildFilaNoticias(2, 3),
        SizedBox(height: 20),

        // Fila 3
        _buildFilaNoticias(4, 5),
        SizedBox(height: 20),

        // Fila 4
        _buildFilaNoticias(6, 7),
      ],
    );
  }

  Widget _buildFilaNoticias(int index1, int index2) {
    return Row(
      children: [
        Expanded(
          child: CategoriaNoticiasDesigns.buildTarjetaNoticia(
            titulo: noticias[index1]['titulo'],
            imagen: noticias[index1]['imagen'],
            onTap: () {
              _navegarADestino(
                noticias[index1]['destino'],
                noticias[index1]['titulo'],
              );
            },
          ),
        ),
        SizedBox(width: 15),
        Expanded(
          child: CategoriaNoticiasDesigns.buildTarjetaNoticia(
            titulo: noticias[index2]['titulo'],
            imagen: noticias[index2]['imagen'],
            onTap: () {
              _navegarADestino(
                noticias[index2]['destino'],
                noticias[index2]['titulo'],
              );
            },
          ),
        ),
      ],
    );
  }

  // MÉTODO PARA MANEJAR LA NAVEGACIÓN
  void _navegarADestino(Widget? destino, String titulo) {
    if (destino != null) {
      Navigator.push(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => destino,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const begin = Offset(1.0, 0.0);
            const end = Offset.zero;
            const curve = Curves.easeInOut;
            var tween = Tween(
              begin: begin,
              end: end,
            ).chain(CurveTween(curve: curve));
            var offsetAnimation = animation.drive(tween);
            return SlideTransition(position: offsetAnimation, child: child);
          },
          transitionDuration: Duration(milliseconds: 500),
        ),
      );
    } else {
      // TODO: Navegar a página genérica de noticias o mostrar detalle
      print('Navegar a noticia: $titulo');
    }
  }
}
