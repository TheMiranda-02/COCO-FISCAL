import 'package:flutter/material.dart';
import 'Estilos/diseños_notificaciones.dart';
import 'dart:async';
import 'package:provider/provider.dart';

// Importa todas las pantallas necesarias
import 'Apartado_A_home.dart';
import '../screens/calendar_screen.dart';
import 'Apartado_C_CF.dart';
import 'services/notification_manager.dart';
import 'services/notification_overlay_service.dart';

class ApartadoDNotificaciones extends StatefulWidget {
  @override
  _ApartadoDNotificacionesState createState() =>
      _ApartadoDNotificacionesState();
}

class _ApartadoDNotificacionesState extends State<ApartadoDNotificaciones> {
  int _selectedTab = 3;
  int _currentSection = 0;
  Timer? _notificationTimer;
  Timer? _recordatorioTimer;

  @override
  void initState() {
    super.initState();
    _scheduleDailyNotification(); // Para NOTIFICACIONES
    _scheduleDailyRecordatorio(); // Para RECORDATORIOS
  }

  @override
  void dispose() {
    _notificationTimer?.cancel();
    _recordatorioTimer?.cancel();
    super.dispose();
  }

  // Programar NOTIFICACIÓN diaria a las 10:00 AM
  void _scheduleDailyNotification() {
    final now = DateTime.now();
    final scheduledTime = DateTime(
      now.year,
      now.month,
      now.day,
      21, // 10 AM
      41, // 00 minutos
    );

    DateTime targetTime = scheduledTime;
    if (now.isAfter(scheduledTime)) {
      targetTime = scheduledTime.add(const Duration(days: 1));
    }

    final duration = targetTime.difference(now);

    _notificationTimer = Timer(duration, () {
      _showNotificacionPopup();
      _scheduleDailyNotification();
    });

    print('Notificación programada para: $targetTime');
  }

  // Programar RECORDATORIO diario a las 8:00 PM
  void _scheduleDailyRecordatorio() {
    final now = DateTime.now();
    final scheduledTime = DateTime(
      now.year,
      now.month,
      now.day,
      22, // 8 PM
      51, // 00 minutos
    );

    DateTime targetTime = scheduledTime;
    if (now.isAfter(scheduledTime)) {
      targetTime = scheduledTime.add(const Duration(days: 1));
    }

    final duration = targetTime.difference(now);

    _recordatorioTimer = Timer(duration, () {
      _showRecordatorioPopup();
      _scheduleDailyRecordatorio();
    });

    print('Recordatorio programado para: $targetTime');
  }

  // Mostrar NOTIFICACIÓN emergente
  void _showNotificacionPopup() {
    final nuevaNotificacion = {
      'nombre': 'Consejo del Día',
      'tiempo': 'Ahora',
      'descripcion': 'Revisa tus facturas pendientes de la semana.',
      'accion': 'Ver detalles',
      'categoria': 'Consejo',
      'mensaje': 'No olvides revisar tus facturas pendientes',
      'id': 'notif_${DateTime.now().millisecondsSinceEpoch}',
    };

    // ✅ AGREGAR AL MANAGER GLOBAL
    final notificationManager = Provider.of<NotificationManager>(
      context,
      listen: false,
    );
    notificationManager.agregarNotificacion(nuevaNotificacion);

    // ✅ MOSTRAR NOTIFICACIÓN EMERGENTE USANDO EL SERVICIO
    final overlayService = Provider.of<NotificationOverlayService>(
      context,
      listen: false,
    );
    overlayService.showNotification(nuevaNotificacion, type: 'notificacion');
  }

  // Mostrar RECORDATORIO emergente
  void _showRecordatorioPopup() {
    final nuevoRecordatorio = {
      'nombre': 'Recordatorio Diario',
      'tiempo': 'Ahora',
      'descripcion': 'Es hora de revisar tus declaraciones fiscales del día.',
      'accion': 'Marcar como hecho',
      'id': 'record_${DateTime.now().millisecondsSinceEpoch}',
    };

    // ✅ AGREGAR AL MANAGER GLOBAL
    final notificationManager = Provider.of<NotificationManager>(
      context,
      listen: false,
    );
    notificationManager.agregarRecordatorio(nuevoRecordatorio);

    // ✅ MOSTRAR NOTIFICACIÓN EMERGENTE USANDO EL SERVICIO
    final overlayService = Provider.of<NotificationOverlayService>(
      context,
      listen: false,
    );
    overlayService.showNotification(nuevoRecordatorio, type: 'recordatorio');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: NotificacionesDesigns.buildAppBar(context), // ← CORREGIDO AQUÍ
      body: Stack(
        children: [
          // CONTENIDO PRINCIPAL
          Column(
            children: [
              // Menú de pestañas con fondo verde
              _buildMenuTabs(),

              // Contenido según la sección seleccionada
              Expanded(child: _buildContent()),
            ],
          ),

          // ✅ NOTIFICACIÓN EMERGENTE EN STACK (USANDO EL SERVICIO)
          Consumer<NotificationOverlayService>(
            builder: (context, overlayService, child) {
              if (overlayService.showOverlay &&
                  overlayService.currentNotification != null) {
                return Positioned(
                  top: 10, // POSICIÓN MUY ARRIBA - DEBAJO DEL STATUS BAR
                  left: 15,
                  right: 15,
                  child: _buildNotificationOverlay(
                    overlayService.currentNotification!,
                    overlayService.currentNotificationType!,
                    overlayService,
                  ),
                );
              }
              return SizedBox.shrink();
            },
          ),
        ],
      ),
      bottomNavigationBar: NotificacionesDesigns.buildBottomNavigationBar(
        currentIndex: _selectedTab,
        onTabTapped: _onTabTapped,
      ),
    );
  }

  // Widget de NOTIFICACIÓN EMERGENTE MEJORADO (ACTUALIZADO)
  Widget _buildNotificationOverlay(
    Map<String, dynamic> notification,
    String type,
    NotificationOverlayService overlayService,
  ) {
    final bool isRecordatorio = type == 'recordatorio';
    final Color backgroundColor = isRecordatorio
        ? Colors.orange[100]!
        : Colors.blue[50]!;
    final Color borderColor = isRecordatorio
        ? Colors.orange[300]!
        : Colors.blue[300]!;
    final Color iconColor = isRecordatorio
        ? Colors.orange[700]!
        : Colors.blue[700]!;
    final Color textColor = isRecordatorio
        ? Colors.orange[800]!
        : Colors.blue[800]!;

    return Material(
      elevation: 12,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.4),
              blurRadius: 15,
              offset: Offset(0, 6),
            ),
          ],
          border: Border.all(color: borderColor, width: 2.5),
        ),
        child: Row(
          children: [
            // IMAGEN CIRCULAR EN LUGAR DEL ICONO
            Container(
              width: 45,
              height: 45,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isRecordatorio ? Colors.orange[50] : Colors.blue[50],
                border: Border.all(color: iconColor, width: 2),
              ),
              child: ClipOval(
                child: Image.asset(
                  'assets/images/icono_campana.png', // Tu imagen circular
                  width: 45,
                  height: 45,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    // Fallback si la imagen no carga
                    return Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isRecordatorio
                            ? Colors.orange[50]
                            : Colors.blue[50],
                      ),
                      child: Icon(
                        isRecordatorio ? Icons.alarm : Icons.notifications,
                        color: iconColor,
                        size: 24,
                      ),
                    );
                  },
                ),
              ),
            ),
            SizedBox(width: 15),

            // Contenido
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        isRecordatorio ? 'RECORDATORIO' : 'NOTIFICACIÓN',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                          color: textColor,
                          letterSpacing: 1.0,
                        ),
                      ),
                      Spacer(),
                      Text(
                        'Ahora',
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.grey[700],
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 6),
                  Text(
                    notification['nombre'],
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: textColor,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    notification['descripcion'],
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey[800],
                      height: 1.3,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),

            // Botón de cerrar
            SizedBox(width: 10),
            GestureDetector(
              onTap: () {
                overlayService.hideNotification();
              },
              child: Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Icon(Icons.close, size: 18, color: Colors.grey[600]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Menú de pestañas con fondo verde
  Widget _buildMenuTabs() {
    return Container(
      color: Colors.green[400],
      child: Row(
        children: [
          _buildTabItem('NOTIFICACIONES', 0),
          _buildTabItem('RECORDATORIOS', 1),
        ],
      ),
    );
  }

  Widget _buildTabItem(String title, int index) {
    final isSelected = _currentSection == index;

    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _currentSection = index;
          });
        },
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
          decoration: BoxDecoration(
            border: isSelected
                ? Border(bottom: BorderSide(color: Colors.white, width: 2.0))
                : null,
          ),
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }

  // Contenido según la sección seleccionada
  Widget _buildContent() {
    return Consumer<NotificationManager>(
      builder: (context, notificationManager, child) {
        // ✅ VERIFICAR SI AMBAS LISTAS ESTÁN VACÍAS
        final bool noHayNotificaciones =
            notificationManager.notificaciones.isEmpty;
        final bool noHayRecordatorios =
            notificationManager.recordatorios.isEmpty;
        final bool ambasVacias = noHayNotificaciones && noHayRecordatorios;

        // ✅ SI AMBAS ESTÁN VACÍAS, MOSTRAR ESTADO VACÍO
        if (ambasVacias) {
          return _buildEmptyState();
        }

        // ✅ SI HAY CONTENIDO, MOSTRAR SEGÚN LA SECCIÓN
        if (_currentSection == 0) {
          // NOTIFICACIONES - Usa datos GLOBALES
          return noHayNotificaciones
              ? _buildEmptyState()
              : _buildListaNotificaciones(notificationManager.notificaciones);
        } else {
          // RECORDATORIOS - Usa datos GLOBALES
          return noHayRecordatorios
              ? _buildEmptyState()
              : _buildListaRecordatorios(notificationManager.recordatorios);
        }
      },
    );
  }

  // Estado vacío (cuando no hay elementos) - MODIFICADO CON IMAGEN
  // Estado vacío (cuando no hay elementos) - MODIFICADO CON IMAGEN
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // IMAGEN EN LUGAR DEL ICONO - SIN FORMATO CIRCULAR
          Container(
            width: 160,
            height: 160,
            child: Image.asset(
              'assets/images/Vacio.png', // Tu imagen para el estado vacío
              width: 160,
              height: 160,
              fit: BoxFit.contain, // Cambié a contain para mejor ajuste
              errorBuilder: (context, error, stackTrace) {
                // Fallback si la imagen no carga
                return Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(20), // Bordes suaves
                  ),
                  child: Icon(
                    Icons.notifications_none,
                    size: 80,
                    color: Colors.grey[400],
                  ),
                );
              },
            ),
          ),
          SizedBox(height: 30),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 40),
            child: Column(
              children: [
                Text(
                  'Vuelve más tarde para recibir',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                ),
                SizedBox(height: 5),
                Text(
                  'recordatorios, consejos y notificaciones.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // LISTA DE NOTIFICACIONES (usa datos globales)
  Widget _buildListaNotificaciones(List<Map<String, dynamic>> notificaciones) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'NOTIFICACIONES',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          SizedBox(height: 20),
          Column(
            children: notificaciones.map((notif) {
              return _buildItemNotificacion(notif);
            }).toList(),
          ),
        ],
      ),
    );
  }

  // LISTA DE RECORDATORIOS (usa datos globales)
  Widget _buildListaRecordatorios(List<Map<String, dynamic>> recordatorios) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'RECORDATORIOS',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          SizedBox(height: 20),
          Column(
            children: recordatorios.map((recordatorio) {
              return _buildItemRecordatorio(recordatorio);
            }).toList(),
          ),
        ],
      ),
    );
  }

  // Widget para item de notificación
  Widget _buildItemNotificacion(Map<String, dynamic> notif) {
    return Container(
      margin: EdgeInsets.only(bottom: 15),
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 5,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Categoría - ${notif['categoria'] ?? 'General'}',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.green[700],
                ),
              ),
              Text(
                notif['tiempo'],
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              ),
            ],
          ),
          SizedBox(height: 8),
          Text(notif['mensaje'] ?? notif['descripcion']),
          SizedBox(height: 8),
          GestureDetector(
            onTap: () {
              print('Acción: ${notif['accion']}');
            },
            child: Text(
              notif['accion'],
              style: TextStyle(
                color: Colors.green[700],
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Widget para item de recordatorio
  Widget _buildItemRecordatorio(Map<String, dynamic> recordatorio) {
    return Container(
      margin: EdgeInsets.only(bottom: 15),
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 5,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            recordatorio['nombre'],
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(recordatorio['tiempo']),
              SizedBox(width: 10),
              Expanded(child: Text(recordatorio['descripcion'])),
            ],
          ),
          SizedBox(height: 8),
          GestureDetector(
            onTap: () {
              print('Acción: ${recordatorio['accion']}');
            },
            child: Text(
              recordatorio['accion'],
              style: TextStyle(
                color: Colors.orange[700],
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _onTabTapped(int index) {
    setState(() {
      _selectedTab = index;
    });

    if (index == 0) {
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              ApartadoAHome(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const begin = Offset(-1.0, 0.0);
            const end = Offset.zero;
            const curve = Curves.easeInOut;
            var tween = Tween(
              begin: begin,
              end: end,
            ).chain(CurveTween(curve: curve));
            var offsetAnimation = animation.drive(tween);
            return SlideTransition(position: offsetAnimation, child: child);
          },
          transitionDuration: Duration(milliseconds: 500),
        ),
      );
    } else if (index == 1) {
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              CalendarScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const begin = Offset(-1.0, 0.0);
            const end = Offset.zero;
            const curve = Curves.easeInOut;
            var tween = Tween(
              begin: begin,
              end: end,
            ).chain(CurveTween(curve: curve));
            var offsetAnimation = animation.drive(tween);
            return SlideTransition(position: offsetAnimation, child: child);
          },
          transitionDuration: Duration(milliseconds: 500),
        ),
      );
    } else if (index == 2) {
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              ApartadoCCF(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const begin = Offset(-1.0, 0.0);
            const end = Offset.zero;
            const curve = Curves.easeInOut;
            var tween = Tween(
              begin: begin,
              end: end,
            ).chain(CurveTween(curve: curve));
            var offsetAnimation = animation.drive(tween);
            return SlideTransition(position: offsetAnimation, child: child);
          },
          transitionDuration: Duration(milliseconds: 500),
        ),
      );
    }
  }
}
