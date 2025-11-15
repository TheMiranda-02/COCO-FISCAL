import 'package:flutter/material.dart';

class PlanUsuarioScreen extends StatefulWidget {
  @override
  _PlanUsuarioScreenState createState() => _PlanUsuarioScreenState();
}

class _PlanUsuarioScreenState extends State<PlanUsuarioScreen> {
  int _planSeleccionado = 0; // 0 = Freemium, 1 = Premium

  // MÉTODO build ALTERNATIVO CON MÁS OPCIONES DE POSICIÓN
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Text(
          'Plan de Usuario',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        actions: [],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 1),
            _buildSelectorPlanes(),
            SizedBox(height: 40),

            // STACK CON BOTÓN SUPERPUESTO
            Container(
              width: double.infinity,
              child: Stack(
                children: [
                  // Imagen del plan
                  _buildImagenPlan(),

                  // Botón superpuesto - POSICIONAMIENTO FLEXIBLE
                  Positioned(
                    top: 500, // DISTANCIA DESDE ARRIBA de la imagen
                    left:
                        MediaQuery.of(context).size.width *
                        0.15, // 25% del ancho
                    right:
                        MediaQuery.of(context).size.width *
                        0.15, // 25% del ancho
                    child: _buildBotonImagenSuperpuesto(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSelectorPlanes() {
    return Column(
      children: [
        // Fila de botones
        Row(
          children: [
            Expanded(
              child: _buildBotonPlan(
                texto: 'Freemium',
                seleccionado: _planSeleccionado == 0,
                onTap: () {
                  setState(() {
                    _planSeleccionado = 0;
                  });
                },
              ),
            ),
            SizedBox(width: 20),
            Expanded(
              child: _buildBotonPlan(
                texto: 'Premium',
                seleccionado: _planSeleccionado == 1,
                onTap: () {
                  setState(() {
                    _planSeleccionado = 1;
                  });
                },
              ),
            ),
          ],
        ),

        // Línea gris base
        Container(height: 2, color: Colors.grey[300]),
      ],
    );
  }

  Widget _buildBotonPlan({
    required String texto,
    required bool seleccionado,
    required VoidCallback onTap,
  }) {
    return Column(
      children: [
        // Botón
        GestureDetector(
          onTap: onTap,
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Text(
              texto,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: seleccionado ? Color(0xFF4CAF50) : Colors.grey[600],
              ),
            ),
          ),
        ),

        // Línea verde cuando está seleccionado
        if (seleccionado)
          Container(
            height: 2,
            color: Color(0xFF4CAF50),
            margin: EdgeInsets.only(
              top: 2,
            ), // Ajusta para alinear con línea gris
          )
        else
          SizedBox(height: 0), // Espacio para mantener la alineación
      ],
    );
  }

  Widget _buildImagenPlan() {
    String imagenPath = _planSeleccionado == 0
        ? 'assets/images/PlanFreemium.png'
        : 'assets/images/PlanPremium.png';

    return Container(
      width: double.infinity,
      child: Image.asset(
        imagenPath,
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            height: 400,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.credit_card, size: 60, color: Colors.grey),
                  SizedBox(height: 10),
                  Text(
                    'Imagen del Plan ${_planSeleccionado == 0 ? 'Freemium' : 'Premium'}',
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

  Widget _buildBotonImagenSuperpuesto() {
    return GestureDetector(
      onTap: () {
        // Acción del botón-imagen
        print(
          'Botón del plan ${_planSeleccionado == 0 ? 'Freemium' : 'Premium'} presionado',
        );
      },
      child: Image.asset(
        'assets/images/boton_plan.png', // Tu imagen de botón
        width: 200,
        height: 60,
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            width: 200,
            height: 60,
            decoration: BoxDecoration(
              color: Color(0xFF4CAF50),
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 6,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: Center(
              child: Text(
                _planSeleccionado == 0 ? 'Usar Freemium' : 'Obtener Premium',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
