import 'package:flutter/material.dart';

class MisCursosAPage extends StatefulWidget {
  @override
  _MisCursosAPageState createState() => _MisCursosAPageState();
}

class _MisCursosAPageState extends State<MisCursosAPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: Container(
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
                    'OnboardingA.png',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            );
          },
        ),
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
            'Mis Cursos',
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
}
