import 'package:flutter/material.dart';

class TercerCFDIScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        // automaticallyImplyLeading: false,
        toolbarHeight: 60,
        title: Row(children: [
          ],
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 16.0),
            child: Container(
              width: 40,
              height: 40,
              child: IconButton(
                padding: EdgeInsets.zero,
                icon: Image.asset(
                  'assets/images/Editar.png',
                  fit: BoxFit.contain,
                ),
                onPressed: () {
                  // Acción de editar
                },
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
            image: AssetImage(
              'assets/images/CFDI-C.png',
            ), // Cambia por tu imagen
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
