import 'package:flutter/material.dart';
import '../Form_Comentario_Curso.dart';

class CursoTarjetaPage extends StatefulWidget {
  final String titulo;
  final String imagen;

  const CursoTarjetaPage({Key? key, required this.titulo, required this.imagen})
    : super(key: key);

  @override
  _CursoTarjetaPageState createState() => _CursoTarjetaPageState();
}

class _CursoTarjetaPageState extends State<CursoTarjetaPage> {
  bool _estaInscrito = false;

  // MÉTODO PARA MOSTRAR EL DIÁLOGO DE INSCRIPCIÓN
  void _mostrarDialogoInscripcion() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        if (_estaInscrito) {
          // DIÁLOGO DE INSCRIPCIÓN EXITOSA
          return AlertDialog(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.check_circle, color: Colors.green, size: 60),
                SizedBox(height: 16),
                Text(
                  '¡Inscripción Exitosa!',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 8),
                Text(
                  'Se ha inscrito a este curso correctamente',
                  style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    minimumSize: Size(120, 40),
                  ),
                  child: Text('Aceptar', style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          );
        } else {
          // DIÁLOGO DE CONFIRMACIÓN DE INSCRIPCIÓN
          return AlertDialog(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            title: Text(
              'Confirmar Inscripción',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '¿Estás seguro de que quieres inscribirte al curso "${widget.titulo}"?',
                  style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          Navigator.of(context).pop(); // Cerrar diálogo
                        },
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.grey,
                          side: BorderSide(color: Colors.grey),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: EdgeInsets.symmetric(vertical: 12),
                        ),
                        child: Text('Cancelar'),
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          // Confirmar inscripción
                          setState(() {
                            _estaInscrito = true;
                          });
                          Navigator.of(context).pop(); // Cerrar primer diálogo
                          _mostrarDialogoInscripcion(); // Mostrar diálogo de éxito
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: EdgeInsets.symmetric(vertical: 12),
                        ),
                        child: Text(
                          'Confirmar',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: _buildAppBarTransparente(),
      body: Stack(
        children: [
          // IMAGEN DE FONDO
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(widget.imagen),
                fit: BoxFit.cover,
              ),
            ),
          ),

          // BOTONES POSICIONADOS MANUALMENTE
          Positioned(
            top: 150,
            left: 20,
            child: _buildBotonPersonalizado(
              texto: 'Iniciar Curso',
              icono: Icons.play_arrow,
              onTap: () {
                print('Iniciar curso: ${widget.titulo}');
              },
            ),
          ),

          Positioned(
            top: 220,
            left: 20,
            child: _buildBotonPersonalizado(
              texto: 'Contenido',
              icono: Icons.list,
              onTap: () {
                print('Ver contenido del curso');
              },
            ),
          ),

          Positioned(
            top: 290,
            left: 20,
            child: _buildBotonPersonalizado(
              texto: 'Calificar (funciona)',
              icono: Icons.description,
              onTap: () {
                // Navegar a FormComentarioCurso
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => FormComentarioCurso(),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // APPBAR TRANSPARENTE
  AppBar _buildAppBarTransparente() {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: Container(
        margin: EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.3),
          shape: BoxShape.circle,
        ),
        child: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      actions: [
        Container(
          margin: EdgeInsets.all(8),
          child: IconButton(
            icon: Image.asset(
              'assets/images/Agregar.png',
              width: 20,
              height: 20,
              color: Colors.white,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) {
                return Icon(Icons.add, size: 20, color: Colors.white);
              },
            ),
            onPressed:
                _mostrarDialogoInscripcion, // ← AQUÍ SE LLAMA AL MÉTODO DEL DIÁLOGO
          ),
        ),
      ],
    );
  }

  // BOTÓN PERSONALIZADO
  Widget _buildBotonPersonalizado({
    required String texto,
    required IconData icono,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.9),
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 8,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icono, color: Colors.green, size: 20),
            SizedBox(width: 8),
            Text(
              texto,
              style: TextStyle(
                color: Colors.grey[800],
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
