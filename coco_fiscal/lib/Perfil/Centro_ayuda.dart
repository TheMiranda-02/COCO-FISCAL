import 'package:flutter/material.dart';
import 'Sub_Centro_ayuda.dart'; // Asegúrate de importar la ruta correcta

class CentroAyudaScreen extends StatefulWidget {
  @override
  _CentroAyudaScreenState createState() => _CentroAyudaScreenState();
}

class _CentroAyudaScreenState extends State<CentroAyudaScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/fondo_centro_ayuda.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              // AppBar con fondo transparente
              _buildAppBarTransparente(),

              // Contenido principal
              _buildContenidoPrincipal(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppBarTransparente() {
    return Container(
      decoration: BoxDecoration(color: Colors.transparent),
      child: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: const Color.fromARGB(255, 0, 0, 0),
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Text(
          'Centro de Ayuda',
          style: TextStyle(
            color: const Color.fromARGB(255, 0, 0, 0),
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        actions: [
          // TEXT SKIP EN EL LADO DERECHO
          Padding(
            padding: EdgeInsets.only(right: 16.0),
            child: GestureDetector(
              onTap: () {
                // REDIRECCIONAR A SUB_Centro_ayuda.dart
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        PerfilCategoria(), // Ajusta el nombre según tu clase
                  ),
                );
              },
              child: Text(
                'SKIP',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContenidoPrincipal() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 30),

          // Título alineado a la izquierda
          _buildTitulo(),
          SizedBox(height: 30),

          // Texto descriptivo con margen derecho
          _buildTextoDescriptivo(),
          SizedBox(height: 40),

          // Imagen centrada
          _buildImagenCentrada(),
          SizedBox(height: 80),

          // Botón centrado
          _buildBotonImagenCentrado(),
        ],
      ),
    );
  }

  Widget _buildTitulo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'BIENVENIDO A LA',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        Text(
          'GUIA DE USUARIO',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ],
    );
  }

  Widget _buildTextoDescriptivo() {
    return Container(
      // MARGEN IZQUIERDO para mover todo el contenedor a la derecha
      margin: EdgeInsets.only(left: 17.0), // ← AQUÍ AJUSTAS LA POSICIÓN
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Lorem Ipsum is simply dummy text of the printing and typesetting industry's.",
            style: TextStyle(fontSize: 16, color: Colors.black, height: 1.5),
          ),
          SizedBox(height: 10),
        ],
      ),
    );
  }

  Widget _buildImagenCentrada() {
    return Container(
      width: 300,
      height: 300,
      margin: EdgeInsets.only(left: 20.0),
      child: Image.asset(
        'assets/images/Coco_Icono.png',
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            color: Colors.white.withOpacity(0.9),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.help_outline, size: 60, color: Colors.grey),
                  SizedBox(height: 10),
                  Text(
                    'Imagen Guía de Usuario',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildBotonImagenCentrado() {
    return Center(
      child: GestureDetector(
        onTap: () {
          print('Botón Explorar más presionado');
        },
        child: Image.asset(
          'assets/images/btnExplorar.png',
          width: 200,
          height: 100,
          fit: BoxFit.contain,
          errorBuilder: (context, error, stackTrace) {
            return Container(
              width: 200,
              height: 60,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
              ),
              child: Center(
                child: Text(
                  'Explorar más',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
