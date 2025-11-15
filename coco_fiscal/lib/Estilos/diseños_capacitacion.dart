import 'package:flutter/material.dart';
import '../Perfil_Usuario.dart';

class CapacitacionDesigns {
  static AppBar buildAppBar(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      toolbarHeight: 60,
      title: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.asset(
                'assets/images/Coco_Icono.png',
                filterQuality: FilterQuality.high,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Icon(Icons.school, size: 30, color: Colors.green);
                },
              ),
            ),
          ),
          SizedBox(width: 15),
          Text(
            'Capacitación',
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
      actions: [
        Padding(
          padding: EdgeInsets.only(right: 16.0),
          child: Container(
            width: 40,
            height: 40,
            child: IconButton(
              onPressed: () {
                // Navegar a Perfil_Usuario.dart
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) =>
                        PerfilUsuario(), // Asegúrate de que esta clase exista
                  ),
                );
              },
              icon: Image.asset(
                'assets/images/Perfil.png',
                width: 24,
                height: 24,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return Icon(Icons.more_vert, size: 24, color: Colors.black);
                },
              ),
              padding: EdgeInsets.zero,
            ),
          ),
        ),
      ],
    );
  }

  //PIE DE PÁGINA
  static BottomNavigationBar buildBottomNavigationBar({
    required int currentIndex,
    required Function(int) onTabTapped,
  }) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: onTabTapped,
      type: BottomNavigationBarType.fixed,
      selectedItemColor: Colors.green,
      unselectedItemColor: Colors.grey,
      showSelectedLabels: false,
      showUnselectedLabels: false,
      items: [
        BottomNavigationBarItem(
          icon: Image.asset(
            'assets/images/PrincipalA.png',
            width: 30,
            height: 30,
            color: currentIndex == 0 ? Colors.green : Colors.grey,
          ),
          label: '',
        ),
        BottomNavigationBarItem(
          icon: Image.asset(
            'assets/images/CalendarioA.png',
            width: 30,
            height: 30,
            color: currentIndex == 1 ? Colors.green : Colors.grey,
          ),
          label: '',
        ),
        BottomNavigationBarItem(
          icon: Image.asset(
            'assets/images/AsesoriasA.png',
            width: 30,
            height: 30,
            color: currentIndex == 2 ? Colors.green : Colors.grey,
          ),
          label: '',
        ),
        BottomNavigationBarItem(
          icon: Image.asset(
            'assets/images/NotificacionA.png',
            width: 30,
            height: 30,
            color: currentIndex == 3 ? Colors.green : Colors.grey,
          ),
          label: '',
        ),
      ],
    );
  }

  // Métodos específicos para capacitación...
  static Widget buildTarjetaCurso({
    required String titulo,
    required String descripcion,
    required String imagen,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 4,
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: ListTile(
        leading: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: Colors.green[100],
          ),
          child: Image.asset(imagen, fit: BoxFit.cover),
        ),
        title: Text(titulo, style: TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(descripcion),
        trailing: Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }

  //Tip del día
  static Widget buildImageModule({
    required String imagePath,
    required double height,
  }) {
    return Container(
      width: double.infinity,
      height: height,
      margin: EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Colors.grey[300],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: Image.asset(
          imagePath,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.image_not_supported, size: 40, color: Colors.grey),
                  SizedBox(height: 10),
                  Text('Imagen no disponible'),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
