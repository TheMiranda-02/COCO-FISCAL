import 'package:flutter/material.dart';
import 'info_asesor.dart';

class ListasAsesoresPage extends StatefulWidget {
  @override
  _ListasAsesoresPageState createState() => _ListasAsesoresPageState();
}

class _ListasAsesoresPageState extends State<ListasAsesoresPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: Stack(
        children: [
          // IMAGEN DE FONDO
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
            top: 190, // AJUSTA ESTA POSICIÓN VERTICAL
            left: 90, // AJUSTA ESTA POSICIÓN HORIZONTAL
            child: Container(
              margin: EdgeInsets.all(10), // PUEDES AJUSTAR ESTE MARGEN
              child: GestureDetector(
                onTap: () {
                  // AQUÍ VA LA ACCIÓN DEL BOTÓN
                  print('Botón presionado');
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => InfoAsesorPage()),
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

  // ENCABEZADO
  AppBar _buildAppBar() {
    return AppBar(
      toolbarHeight: 60,
      title: Row(
        children: [
          Text(
            'Listas de  Asesores',
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
    );
  }
}
