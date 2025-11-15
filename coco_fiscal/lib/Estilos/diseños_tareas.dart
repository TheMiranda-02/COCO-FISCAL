import 'package:flutter/material.dart';
import '../Perfil_Usuario.dart';

class TareasDesigns {
  static AppBar buildAppBar(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      toolbarHeight: 60,
      title: Row(
        children: [
          GestureDetector(
            onTap: () {
              // Redirige al Home
              Navigator.pushReplacementNamed(context, '/home');
              // Si solo quieres regresar a la pantalla anterior:
              // Navigator.pop(context);
            },
            child: Container(
              width: 15,
              height: 15,
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.asset(
                  'assets/images/flechaizquierda.png',
                  filterQuality: FilterQuality.high,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Icon(Icons.school, size: 30, color: Colors.green);
                  },
                ),
              ),
            ),
          ),
          SizedBox(width: 15),
          Text(
            'Obligaciones',
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
            width: 40, // ← Tamaño más pequeño que el icono (50x50)
            height: 40,
            child: IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PerfilUsuario()),
                );

                // Acción del menú de capacitación
              },
              icon: Image.asset(
                'assets/images/Perfil.png', // ← Tu imagen de perfil
                width: 24, // ← Tamaño de la imagen
                height: 24,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return Icon(Icons.more_vert, size: 24, color: Colors.black);
                },
              ),
              padding: EdgeInsets.zero, // ← Elimina padding extra
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
            'assets/images/CalendarioA.png',
            width: 30,
            height: 30,
            color: currentIndex == 0 ? Colors.green : Colors.grey,
          ),
          label: '',
        ),
        BottomNavigationBarItem(
          icon: Image.asset(
            'assets/images/ObligacionesA.png',
            width: 30,
            height: 30,
            color: currentIndex == 1 ? Colors.green : Colors.grey,
          ),
          label: '',
        ),
        BottomNavigationBarItem(
          icon: Image.asset(
            'assets/images/ResumenA.png',
            width: 30,
            height: 30,
            color: currentIndex == 2 ? Colors.green : Colors.grey,
          ),
          label: '',
        ),
      ],
    );
  }
}
