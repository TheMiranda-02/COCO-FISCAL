import 'package:flutter/material.dart';
import './/Estilos/form_crearcuenta.dart';
import 'introduccion_A.dart'; // ← AGREGAR ESTE IMPORT

class CategoriaCrearCuentaScreen extends StatefulWidget {
  final Map<String, dynamic> datosUsuario;

  const CategoriaCrearCuentaScreen({super.key, required this.datosUsuario});

  @override
  State<CategoriaCrearCuentaScreen> createState() =>
      _CategoriaCrearCuentaScreenState();
}

class _CategoriaCrearCuentaScreenState
    extends State<CategoriaCrearCuentaScreen> {
  // Lista para almacenar las categorías seleccionadas
  final Set<int> _categoriasSeleccionadas = <int>{};

  // Lista de categorías CON IMÁGENES Y COLORES
  final List<Map<String, dynamic>> _categorias = [
    {
      'id': 1,
      'nombre': 'Emprende y crece',
      'imagen': 'assets/images/CategoriaA.png',
      'color': Color(0xFFA6D3AF),
    },
    {
      'id': 2,
      'nombre': 'Todo sobre RESICO',
      'imagen': 'assets/images/CategoriaB.png',
      'color': Color(0xFFB4DAB8),
    },
    {
      'id': 3,
      'nombre': 'Facturación fácil',
      'imagen': 'assets/images/CategoriaC.png',
      'color': Color(0xFFC2E1C3),
    },
    {
      'id': 4,
      'nombre': 'Declaraciones sin estrés',
      'imagen': 'assets/images/CategoriaD.png',
      'color': Color(0xFFCFE9CE),
    },
    {
      'id': 5,
      'nombre': 'Deducciones personales',
      'imagen': 'assets/images/CategoriaE.png',
      'color': Color(0xFFDCF0D9),
    },
    {
      'id': 6,
      'nombre': 'Seguridad social',
      'imagen': 'assets/images/CategoriaF.png',
      'color': Color(0xFFE6F5E5),
    },
    {
      'id': 7,
      'nombre': 'Evita multas',
      'imagen': 'assets/images/CategoriaG.png',
      'color': Color(0xFFEBF7ED),
    },
    {
      'id': 8,
      'nombre': 'Educación financiera',
      'imagen': 'assets/images/CategoriaH.png',
      'color': Color(0xFFEEF8F0),
    },
  ];

  // Método para navegar a la pantalla de introducción
  void _irAIntroduccion() {
    if (_categoriasSeleccionadas.isEmpty) {
      _mostrarError('Selecciona al menos una categoría');
      return;
    }

    // Agregar las categorías seleccionadas a los datos del usuario
    Map<String, dynamic> datosCompletos = Map.from(widget.datosUsuario);
    datosCompletos['categoriasSeleccionadas'] = _categoriasSeleccionadas
        .toList();

    // Navegar a la pantalla de introducción A
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => IntroduccionAScreen(datosUsuario: datosCompletos),
      ),
    );
  }

  // Método para alternar selección
  void _toggleCategoria(int id) {
    setState(() {
      if (_categoriasSeleccionadas.contains(id)) {
        _categoriasSeleccionadas.remove(id);
      } else {
        _categoriasSeleccionadas.add(id);
      }
    });
  }

  void _mostrarError(String mensaje) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(mensaje),
        backgroundColor: Colors.red,
        duration: Duration(seconds: 4),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Catálogo de categorías'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Título
            Text(
              '¿En qué podemos ayudarte?',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.textColor,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '(selecciona todas las que quieras)',
              style: TextStyle(fontSize: 16, color: AppColors.hintColor),
            ),
            const SizedBox(height: 30),

            // Grid de categorías
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 10,
                childAspectRatio: 1.4,
              ),
              itemCount: _categorias.length,
              itemBuilder: (context, index) {
                final categoria = _categorias[index];
                final bool isSelected = _categoriasSeleccionadas.contains(
                  categoria['id'],
                );

                return CategoriaCard(
                  nombre: categoria['nombre'],
                  imagen: categoria['imagen'],
                  isSelected: isSelected,
                  onTap: () => _toggleCategoria(categoria['id']),
                  color: categoria['color'],
                );
              },
            ),

            const SizedBox(height: 30),

            // Botón Siguiente Simple con Imagen
            Container(
              width: double.infinity,
              child: GestureDetector(
                onTap: _irAIntroduccion, // Cambiado a _irAIntroduccion
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.asset(
                    'assets/images/btnSiguiente.png',
                    width: double.infinity,
                    height: 60,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        height: 60,
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 20, 143, 75),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Center(
                          child: Text(
                            'Siguiente',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),

            // SECCIÓN PARA MOSTRAR LOS DATOS RECIBIDOS
            // _buildDatosUsuario(),
          ],
        ),
      ),
    );
  }

  // Widget para mostrar los datos ACTUALIZADO CON LADA
  // Widget _buildDatosUsuario() {
  //   return Container(
  //     width: double.infinity,
  //     padding: const EdgeInsets.all(16),
  //     margin: const EdgeInsets.only(top: 20),
  //     decoration: BoxDecoration(
  //       color: Colors.grey.shade50,
  //       borderRadius: BorderRadius.circular(12),
  //       border: Border.all(color: Colors.grey.shade300),
  //     ),
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         Text(
  //           'Datos del Usuario:',
  //           style: TextStyle(
  //             fontSize: 18,
  //             fontWeight: FontWeight.bold,
  //             color: AppColors.textColor,
  //           ),
  //         ),
  //         const SizedBox(height: 16),

  //         // Información personal
  //         _buildInfoItem('Nombre:', widget.datosUsuario['nombre']),
  //         _buildInfoItem('RFC:', widget.datosUsuario['rfc']),
  //         _buildInfoItem(
  //           'Régimen Fiscal:',
  //           widget.datosUsuario['regimenFiscal'],
  //         ),
  //         _buildInfoItem('Email:', widget.datosUsuario['email']),
  //         _buildInfoItem('Pass:', widget.datosUsuario['pass']),
  //         _buildInfoItem('Lada:', widget.datosUsuario['lada']), // LADA SEPARADA
  //         _buildInfoItem(
  //           'Celular:',
  //           widget.datosUsuario['celular'],
  //         ), // SOLO NÚMERO
  //         _buildInfoItem(
  //           'Fecha Nacimiento:',
  //           widget.datosUsuario['fechaNacimiento'],
  //         ),

  //         const SizedBox(height: 12),
  //         Text(
  //           'Domicilio:',
  //           style: TextStyle(
  //             fontSize: 16,
  //             fontWeight: FontWeight.bold,
  //             color: AppColors.textColor,
  //           ),
  //         ),
  //         const SizedBox(height: 8),

  //         // Campos de domicilio individuales
  //         _buildInfoItem('Calle:', widget.datosUsuario['calle']),
  //         _buildInfoItem('Colonia:', widget.datosUsuario['colonia']),
  //         _buildInfoItem('Número:', widget.datosUsuario['numero']),
  //         _buildInfoItem('CP:', widget.datosUsuario['cp']),
  //         _buildInfoItem('Ciudad:', widget.datosUsuario['ciudad']),
  //         _buildInfoItem('Estado:', widget.datosUsuario['estado']),
  //         _buildInfoItem('País:', widget.datosUsuario['pais']),
  //       ],
  //     ),
  //   );
  // }

  // // Widget auxiliar para mostrar cada item de información
  // Widget _buildInfoItem(String label, String? value) {
  //   return Padding(
  //     padding: const EdgeInsets.symmetric(vertical: 4),
  //     child: Row(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         Text(
  //           label,
  //           style: TextStyle(
  //             fontSize: 14,
  //             fontWeight: FontWeight.w600,
  //             color: Colors.grey.shade700,
  //           ),
  //         ),
  //         const SizedBox(width: 8),
  //         Expanded(
  //           child: Text(
  //             value ?? 'No especificado',
  //             style: TextStyle(fontSize: 14, color: Colors.grey.shade800),
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }
}
