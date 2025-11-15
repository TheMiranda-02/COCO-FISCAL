import 'package:flutter/material.dart';

class GeneralCFDIScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        toolbarHeight: 60,
        title: Row(
          children: [
            Text(
              'Cfdi Recientes',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ],
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Stack(
        children: [
          // IMAGEN DE FONDO
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/CFDI-D.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),

          // ✅ BOTÓN 1 - POSICIÓN MANUAL
          Positioned(
            top: 100, // ← AJUSTA ESTA POSICIÓN
            left: 50, // ← AJUSTA ESTA POSICIÓN
            child: _buildBotonSobreImagen(
              texto: 'Botón 1',
              onTap: () {
                print('Botón 1 presionado');
                // Navigator.push(context, MaterialPageRoute(builder: (context) => Pantalla1()));
              },
            ),
          ),

          // ✅ BOTÓN 2 - POSICIÓN MANUAL
          Positioned(
            top: 100, // ← AJUSTA ESTA POSICIÓN
            right: 50, // ← AJUSTA ESTA POSICIÓN
            child: _buildBotonSobreImagen(
              texto: 'Botón 2',
              onTap: () {
                print('Botón 2 presionado');
                // Navigator.push(context, MaterialPageRoute(builder: (context) => Pantalla2()));
              },
            ),
          ),

          // ✅ BOTÓN 3 - POSICIÓN MANUAL
          Positioned(
            top: 200, // ← AJUSTA ESTA POSICIÓN
            left: 80, // ← AJUSTA ESTA POSICIÓN
            child: _buildBotonSobreImagen(
              texto: 'Botón 3',
              onTap: () {
                print('Botón 3 presionado');
                // Navigator.push(context, MaterialPageRoute(builder: (context) => Pantalla3()));
              },
            ),
          ),

          // ✅ BOTÓN 4 - POSICIÓN MANUAL
          Positioned(
            top: 200, // ← AJUSTA ESTA POSICIÓN
            right: 80, // ← AJUSTA ESTA POSICIÓN
            child: _buildBotonSobreImagen(
              texto: 'Botón 4',
              onTap: () {
                print('Botón 4 presionado');
                // Navigator.push(context, MaterialPageRoute(builder: (context) => Pantalla4()));
              },
            ),
          ),

          // ✅ BOTÓN 5 - POSICIÓN MANUAL
          Positioned(
            top: 300, // ← AJUSTA ESTA POSICIÓN
            left: 60, // ← AJUSTA ESTA POSICIÓN
            child: _buildBotonSobreImagen(
              texto: 'Botón 5',
              onTap: () {
                print('Botón 5 presionado');
                // Navigator.push(context, MaterialPageRoute(builder: (context) => Pantalla5()));
              },
            ),
          ),

          // ✅ BOTÓN 6 - POSICIÓN MANUAL
          Positioned(
            top: 300, // ← AJUSTA ESTA POSICIÓN
            right: 60, // ← AJUSTA ESTA POSICIÓN
            child: _buildBotonSobreImagen(
              texto: 'Botón 6',
              onTap: () {
                print('Botón 6 presionado');
                // Navigator.push(context, MaterialPageRoute(builder: (context) => Pantalla6()));
              },
            ),
          ),

          // ✅ BOTÓN 7 - POSICIÓN MANUAL
          Positioned(
            bottom: 200, // ← AJUSTA ESTA POSICIÓN
            left: 70, // ← AJUSTA ESTA POSICIÓN
            child: _buildBotonSobreImagen(
              texto: 'Botón 7',
              onTap: () {
                print('Botón 7 presionado');
                // Navigator.push(context, MaterialPageRoute(builder: (context) => Pantalla7()));
              },
            ),
          ),

          // ✅ BOTÓN 8 - POSICIÓN MANUAL
          Positioned(
            bottom: 200, // ← AJUSTA ESTA POSICIÓN
            right: 70, // ← AJUSTA ESTA POSICIÓN
            child: _buildBotonSobreImagen(
              texto: 'Botón 8',
              onTap: () {
                print('Botón 8 presionado');
                // Navigator.push(context, MaterialPageRoute(builder: (context) => Pantalla8()));
              },
            ),
          ),

          // ✅ BOTÓN 9 - POSICIÓN MANUAL
          Positioned(
            bottom: 100, // ← AJUSTA ESTA POSICIÓN
            left: 90, // ← AJUSTA ESTA POSICIÓN
            child: _buildBotonSobreImagen(
              texto: 'Botón 9',
              onTap: () {
                print('Botón 9 presionado');
                // Navigator.push(context, MaterialPageRoute(builder: (context) => Pantalla9()));
              },
            ),
          ),

          // ✅ BOTÓN 10 - POSICIÓN MANUAL
          Positioned(
            bottom: 100, // ← AJUSTA ESTA POSICIÓN
            right: 90, // ← AJUSTA ESTA POSICIÓN
            child: _buildBotonSobreImagen(
              texto: 'Botón 10',
              onTap: () {
                print('Botón 10 presionado');
                // Navigator.push(context, MaterialPageRoute(builder: (context) => Pantalla10()));
              },
            ),
          ),
        ],
      ),
    );
  }

  // ✅ BOTÓN GRIS SOBRE IMAGEN - TOTALMENTE PERSONALIZABLE
  Widget _buildBotonSobreImagen({
    required String texto,
    required VoidCallback onTap,
    double? ancho,
    double? alto,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: ancho ?? 80, // Ancho por defecto
        height: alto ?? 30, // Alto por defecto
        decoration: BoxDecoration(
          color: const Color.fromARGB(252, 19, 18, 18).withOpacity(0.0),
          border: Border.all(
            color: const Color.fromARGB(216, 184, 75, 75),
            width: 1,
          ),
        ),
        child: Center(
          child: Text(
            texto,
            style: TextStyle(
              color: const Color.fromARGB(255, 17, 17, 17),
              fontWeight: FontWeight.w600,
              fontSize: 12,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
