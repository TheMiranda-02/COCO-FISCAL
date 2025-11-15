import 'package:flutter/material.dart';
import '../Form_Comentario_Asesor.dart';

class InfoAsesorPage extends StatefulWidget {
  @override
  _InfoAsesorPageState createState() => _InfoAsesorPageState();
}

class _InfoAsesorPageState extends State<InfoAsesorPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true, // Para que el AppBar sea transparente
      appBar: _buildAppBarTransparente(),
      body: Stack(
        children: [
          // IMAGEN GRANDE (NO DE FONDO)
          Container(
            width: double.infinity,
            height: double.infinity,
            child: Image.asset(
              'assets/images/OnboardingF.png',
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.error_outline, size: 50, color: Colors.grey),
                      SizedBox(height: 10),
                      Text(
                        'Imagen no encontrada',
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'OnboardingF.png',
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),

          // BOTÓN POSICIONADO MANUALMENTE
          Positioned(
            top: 100, // AJUSTA ESTA POSICIÓN VERTICAL
            left: 20, // AJUSTA ESTA POSICIÓN HORIZONTAL
            child: Container(
              margin: EdgeInsets.all(10), // PUEDES AJUSTAR ESTE MARGEN
              child: GestureDetector(
                onTap: () {
                  // AQUÍ VA LA ACCIÓN DEL BOTÓN
                  print('Botón presionado');
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => FormComentarioAsesor(),
                    ),
                  );
                },
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
                      Icon(Icons.person, color: Colors.green, size: 20),
                      SizedBox(width: 8),
                      Text(
                        'Ver Asesores',
                        style: TextStyle(
                          color: Colors.grey[800],
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ENCABEZADO TRANSPARENTE
  AppBar _buildAppBarTransparente() {
    return AppBar(
      backgroundColor: Colors.transparent, // APPBAR TRANSPARENTE
      elevation: 0, // Sin sombra
      leading: Container(
        margin: EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: const Color.fromARGB(
            0,
            0,
            0,
            0,
          ).withOpacity(0.0), // Fondo semitransparente
          shape: BoxShape.circle,
        ),
        child: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: const Color.fromARGB(255, 0, 0, 0),
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      title: Text(
        //SE PUEDE QUITAR
        'Info Asesor',
        style: TextStyle(
          color: const Color.fromARGB(255, 37, 35, 35),
          fontWeight: FontWeight.bold,
          fontSize: 18,
        ),
      ),
    );
  }
}
