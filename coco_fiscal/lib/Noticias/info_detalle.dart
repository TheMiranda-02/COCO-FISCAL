import 'package:flutter/material.dart';

class InfoDetalleScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        toolbarHeight: 60,
        title: Text(
          'Ingresos Acumulables',
          style: TextStyle(
            color: const Color.fromARGB(255, 0, 0, 0),
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 16.0),
            child: GestureDetector(
              onTap: () {
                // Navegar a Perfil_Usuario.dart si lo necesitas
              },
              child: Container(
                width: 40,
                height: 40,
                child: Padding(
                  padding: EdgeInsets.all(8),
                  child: Image.asset(
                    'assets/images/Editar.png',
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/CFDI_A.png'),
            fit: BoxFit
                .cover, // ← ESTO HACE QUE OCUPE TODO EL ESPACIO DISPONIBLE
          ),
        ),
      ),
    );
  }
}
