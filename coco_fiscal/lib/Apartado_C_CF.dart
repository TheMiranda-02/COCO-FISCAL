import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'Estilos/diseños_capacitacion.dart';
import 'dart:async';
// Importa las otras páginas necesarias
import 'Apartado_A_home.dart';
import './Capacitacion_fiscal/ApartadoA_Cursos.dart';
import 'screens/calendar_screen.dart';
import 'Apartado_D_notificacion.dart';
import 'Splash_Coco_Fiscal.dart';
import 'services/notification_manager.dart';
import 'services/notification_overlay_service.dart'; // NUEVO IMPORT
import 'Capacitacion_fiscal/listas_asesores.dart';

class ApartadoCCF extends StatefulWidget {
  @override
  _ApartadoCCFState createState() => _ApartadoCCFState();
}

class _ApartadoCCFState extends State<ApartadoCCF> {
  int _selectedTab = 2; // Capacitación es el índice 2
  Timer? _notificationTimer;
  Timer? _recordatorioTimer;

  @override
  void initState() {
    super.initState();
    _scheduleDailyNotification(); // Programar notificaciones
    _scheduleDailyRecordatorio(); // Programar recordatorios
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
      10, // 10 AM
      0, // 00 minutos
    );

    DateTime targetTime = scheduledTime;
    if (now.isAfter(scheduledTime)) {
      targetTime = scheduledTime.add(const Duration(days: 1));
    }

    final duration = targetTime.difference(now);

    _notificationTimer = Timer(duration, () {
      _triggerNotificacion();
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
      09, // 00 minutos
    );

    DateTime targetTime = scheduledTime;
    if (now.isAfter(scheduledTime)) {
      targetTime = scheduledTime.add(const Duration(days: 1));
    }

    final duration = targetTime.difference(now);

    _recordatorioTimer = Timer(duration, () {
      _triggerRecordatorio();
      _scheduleDailyRecordatorio();
    });

    print('Recordatorio programado para: $targetTime');
  }

  // Disparar NOTIFICACIÓN
  void _triggerNotificacion() {
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

    // ✅ MOSTRAR NOTIFICACIÓN EMERGENTE
    final overlayService = Provider.of<NotificationOverlayService>(
      context,
      listen: false,
    );
    overlayService.showNotification(nuevaNotificacion, type: 'notificacion');
  }

  // Disparar RECORDATORIO
  void _triggerRecordatorio() {
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

    // ✅ MOSTRAR NOTIFICACIÓN EMERGENTE
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
      appBar: CapacitacionDesigns.buildAppBar(context),
      body: Stack(
        children: [
          // CONTENIDO PRINCIPAL
          SingleChildScrollView(
            padding: EdgeInsets.all(20),
            child: Column(
              children: [
                SizedBox(height: 25),
                // Módulo de Tip del día
                CapacitacionDesigns.buildImageModule(
                  imagePath: 'assets/images/Ana_proge.png',
                  height: 190,
                ),
                SizedBox(height: 40),

                // SERVICIOS DISPONIBLES
                _buildServiciosDisponibles(),
                SizedBox(height: 40),

                // TARJETAS CON DESCRIPCIÓN - NUEVO
                _buildTarjetasDescripcion(),
              ],
            ),
          ),

          // ✅ NOTIFICACIÓN EMERGENTE EN STACK
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
      bottomNavigationBar: CapacitacionDesigns.buildBottomNavigationBar(
        currentIndex: _selectedTab,
        onTabTapped: _onTabTapped,
      ),
    );
  }

  // Widget de NOTIFICACIÓN EMERGENTE REUTILIZABLE
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
            // Icono con color según el tipo
            Container(
              width: 45,
              height: 45,
              decoration: BoxDecoration(
                color: isRecordatorio ? Colors.orange[50] : Colors.blue[50],
                borderRadius: BorderRadius.circular(22.5),
                border: Border.all(color: iconColor, width: 2),
              ),
              child: Icon(
                isRecordatorio ? Icons.alarm : Icons.notifications,
                color: iconColor,
                size: 24,
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

  // ... (el resto de tus métodos permanecen igual: _buildServiciosDisponibles, _buildTarjetaServicio, etc.)
  //PARA SERVICIOS DISPONIBLES
  Widget _buildServiciosDisponibles() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Servicios disponibles',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        SizedBox(height: 35),

        // Fila de servicios
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildTarjetaServicio(
              imagen: 'assets/images/Cursos.png',
              titulo: 'Cursos',
              onTap: () {
                Navigator.push(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) =>
                        ApartadoACursos(),
                    transitionsBuilder:
                        (context, animation, secondaryAnimation, child) {
                          const begin = Offset(1.0, 0.0);
                          const end = Offset.zero;
                          const curve = Curves.easeInOut;
                          var tween = Tween(
                            begin: begin,
                            end: end,
                          ).chain(CurveTween(curve: curve));
                          var offsetAnimation = animation.drive(tween);
                          return SlideTransition(
                            position: offsetAnimation,
                            child: child,
                          );
                        },
                    transitionDuration: Duration(milliseconds: 500),
                  ),
                );
              },
            ),
            _buildTarjetaServicio(
              imagen: 'assets/images/Asesorias.png',
              titulo: 'Asesorías',
              onTap: () {
                Navigator.push(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) =>
                        ListasAsesoresPage(),
                    transitionsBuilder:
                        (context, animation, secondaryAnimation, child) {
                          const begin = Offset(1.0, 0.0);
                          const end = Offset.zero;
                          const curve = Curves.easeInOut;
                          var tween = Tween(
                            begin: begin,
                            end: end,
                          ).chain(CurveTween(curve: curve));
                          var offsetAnimation = animation.drive(tween);
                          return SlideTransition(
                            position: offsetAnimation,
                            child: child,
                          );
                        },
                    transitionDuration: Duration(milliseconds: 500),
                  ),
                );
              },
            ),
            _buildTarjetaServicio(
              imagen: 'assets/images/ChatBot.png',
              titulo: 'ChatBot',
              onTap: () {
                Navigator.push(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) =>
                        SplashCocoFiscal(),
                    transitionsBuilder:
                        (context, animation, secondaryAnimation, child) {
                          const begin = Offset(1.0, 0.0);
                          const end = Offset.zero;
                          const curve = Curves.easeInOut;
                          var tween = Tween(
                            begin: begin,
                            end: end,
                          ).chain(CurveTween(curve: curve));
                          var offsetAnimation = animation.drive(tween);
                          return SlideTransition(
                            position: offsetAnimation,
                            child: child,
                          );
                        },
                    transitionDuration: Duration(milliseconds: 500),
                  ),
                );
              },
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTarjetaServicio({
    required String imagen,
    required String titulo,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 5),
          child: Column(
            children: [
              Container(
                width: 80,
                height: 80,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.asset(
                    imagen,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 255, 255, 255),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          Icons.image_not_supported,
                          color: const Color.fromARGB(255, 255, 253, 253),
                          size: 30,
                        ),
                      );
                    },
                  ),
                ),
              ),
              SizedBox(height: 25),
              Text(
                titulo,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }

  //NUEVO - TARJETAS CON DESCRIPCIÓN
  Widget _buildTarjetasDescripcion() {
    return Column(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: _buildTarjetaIzquierda(
            'Accede a videos claros y prácticos sobre temas fiscales: declaraciones, facturación, deducciones y más, explicados de forma sencilla.',
          ),
        ),
        SizedBox(height: 35),
        Align(
          alignment: Alignment.centerRight,
          child: _buildTarjetaDerecha(
            'Accede a videos claros y prácticos sobre temas fiscales: declaraciones, facturación, deducciones y más, explicados de forma sencilla.',
          ),
        ),
        SizedBox(height: 30),
        Align(
          alignment: Alignment.centerLeft,
          child: _buildTarjetaIzquierda(
            'Accede a videos claros y prácticos sobre temas fiscales: declaraciones, facturación, deducciones y más, explicados de forma sencilla.',
          ),
        ),
      ],
    );
  }

  // Para tarjetas 1 y 3 (izquierda)
  Widget _buildTarjetaIzquierda(String descripcion) {
    return Container(
      width: 310,
      height: 100,
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border(
          right: BorderSide(
            color: Color.fromARGB(200, 135, 139, 146),
            width: 4.0,
          ),
        ),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 2)),
        ],
      ),
      child: Align(
        alignment: Alignment.topCenter,
        child: Text(
          descripcion,
          style: TextStyle(fontSize: 12, color: Colors.black87, height: 1.5),
          textAlign: TextAlign.left,
          maxLines: 3,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }

  // Para tarjeta 2 (derecha)
  Widget _buildTarjetaDerecha(String descripcion) {
    return Container(
      width: 310,
      height: 100,
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border(
          right: BorderSide(
            color: Color.fromARGB(200, 135, 139, 146),
            width: 4.0,
          ),
        ),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 2)),
        ],
      ),
      child: Align(
        alignment: Alignment.topLeft,
        child: Text(
          descripcion,
          style: TextStyle(fontSize: 12, color: Colors.black87, height: 1.5),
          textAlign: TextAlign.left,
          maxLines: 3,
          overflow: TextOverflow.ellipsis,
        ),
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
    } else if (index == 3) {
      Navigator.push(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              ApartadoDNotificaciones(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const begin = Offset(1.0, 0.0);
            const end = Offset.zero;
            const curve = Curves.easeInOut;
            var tween = Tween(
              begin: begin,
              end: end,
            ).chain(CurveTween(curve: curve));
            var offsetAnimation = animation.drive(tween);

            return SlideTransition(position: offsetAnimation, child: child);
          },
          transitionDuration: Duration(milliseconds: 300),
        ),
      );
    }
  }
}
