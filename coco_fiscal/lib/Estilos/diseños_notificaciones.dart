import 'package:flutter/material.dart';
import '../Perfil_Usuario.dart';

class NotificacionesDesigns {
  static AppBar buildAppBar(BuildContext context) {
    // Añade context como parámetro
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
                  return Icon(
                    Icons.notifications,
                    size: 30,
                    color: Colors.orange,
                  );
                },
              ),
            ),
          ),
          SizedBox(width: 15),
          Text(
            'Notificaciones',
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
      actions: [
        Padding(
          padding: EdgeInsets.only(right: 16.0),
          child: Container(
            width: 40,
            height: 40,
            child: IconButton(
              onPressed: () {
                // Navegar a PerfilUsuario cuando se presiona la imagen de perfil
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PerfilUsuario()),
                );
              },
              icon: Image.asset(
                'assets/images/Perfil.png',
                width: 24,
                height: 24,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return Icon(Icons.person, size: 24, color: Colors.black);
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

  // WIDGET PARA ITEM DE NOTIFICACIÓN
  static Widget buildNotificacionItem({
    required String titulo,
    required String mensaje,
    required String fecha,
    required bool leida,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 2,
      margin: EdgeInsets.symmetric(vertical: 8),
      color: leida ? Colors.white : Colors.blue.shade50,
      child: ListTile(
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: leida ? Colors.grey : Colors.blue,
          ),
          child: Icon(
            leida ? Icons.notifications_none : Icons.notifications_active,
            color: Colors.white,
            size: 20,
          ),
        ),
        title: Text(
          titulo,
          style: TextStyle(
            fontWeight: leida ? FontWeight.normal : FontWeight.bold,
            color: leida ? Colors.grey : Colors.black,
          ),
        ),
        subtitle: Text(mensaje),
        trailing: Text(
          fecha,
          style: TextStyle(fontSize: 12, color: Colors.grey),
        ),
        onTap: onTap,
      ),
    );
  }

  // MÓDULO DE IMAGEN
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
