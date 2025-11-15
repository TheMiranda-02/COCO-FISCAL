import 'package:flutter/material.dart';
import 'termino_detalle.dart';

class GlosarioGeneralScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        toolbarHeight: 60,
        title: Row(
          children: [
            Text(
              'Todas las categorías',
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
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/OnboardingF.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Stack(
          children: [
            // BOTÓN 1 - ESQUINA SUPERIOR IZQUIERDA
            Positioned(
              top: 30,
              left: 20,
              child: _buildBotonImagen(
                imagen:
                    'assets/images/Miranda.png', // ← USA MIRANDA TEMPORALMENTE
                onTap: () {
                  print('Botón Término 1 presionado');
                },
              ),
            ),

            // BOTÓN 2 - CENTRO SUPERIOR
            Positioned(
              top: 100,
              left: MediaQuery.of(context).size.width / 2 - 40,
              child: _buildBotonImagen(
                imagen:
                    'assets/images/Miranda.png', // ← USA MIRANDA TEMPORALMENTE
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TerminoDetalleScreen(),
                    ),
                  );
                },
              ),
            ),

            // BOTÓN 3 - ESQUINA SUPERIOR DERECHA
            Positioned(
              top: 30,
              right: 20,
              child: _buildBotonImagen(
                imagen:
                    'assets/images/Miranda.png', // ← USA MIRANDA TEMPORALMENTE
                onTap: () {
                  print('Botón Término 3 presionado');
                },
              ),
            ),

            // BOTÓN 4 - CENTRO INFERIOR IZQUIERDA
            Positioned(
              bottom: 150,
              left: 40,
              child: _buildBotonImagen(
                imagen:
                    'assets/images/Miranda.png', // ← USA MIRANDA TEMPORALMENTE
                onTap: () {
                  print('Botón Término 4 presionado');
                },
              ),
            ),

            // BOTÓN 5 - CENTRO INFERIOR DERECHA
            Positioned(
              bottom: 150,
              right: 40,
              child: _buildBotonImagen(
                imagen:
                    'assets/images/Miranda.png', // ← USA MIRANDA TEMPORALMENTE
                onTap: () {
                  print('Botón Término 5 presionado');
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // WIDGET PARA BOTONES DE IMAGEN
  Widget _buildBotonImagen({
    required String imagen,
    required VoidCallback onTap,
    double width = 80,
    double height = 80,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.transparent,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.asset(imagen, fit: BoxFit.cover),
        ),
      ),
    );
  }
}
