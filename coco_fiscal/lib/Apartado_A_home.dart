import 'package:flutter/material.dart';
import 'dart:async';
import 'package:provider/provider.dart';
import 'Estilos/diseños_home.dart';
import '../services/api_service.dart';
import '../models/resumen_tareas.dart';

// Navegación a otras pantallas
import '../screens/calendar_screen.dart';
import 'Apartado_C_CF.dart';
import 'Noticias_Recomendada_cate1.dart';
import 'Apartado_D_notificacion.dart';
import 'services/notification_manager.dart';
import 'services/notification_overlay_service.dart';
import '../screens/dashboard_tareas.dart';

//CFDI RECIENTES
import '../CFDI_recientes/fichas_generales.dart';
import '../CFDI_recientes/primer_cfdi.dart';
import '../CFDI_recientes/segundo_cfdi.dart';
import '../CFDI_recientes/tercer_cfdi.dart';
import '../CFDI_recientes/cuarto_cfdi.dart';

// Modelo para las noticias
class NoticiaModel {
  final String titulo;
  final String imagen;

  NoticiaModel({required this.titulo, required this.imagen});
}

class ApartadoAHome extends StatefulWidget {
  @override
  _ApartadoAHomeState createState() => _ApartadoAHomeState();
}

class _ApartadoAHomeState extends State<ApartadoAHome> {
  //MANEJAR RESUMEN
  ResumenTareas? resumen;
  bool _isLoadingResumen = true;
  String? _errorResumen;
  DateTime inicio = DateTime.now();
  DateTime fin = DateTime.now();

  int _currentIndex = 0;
  int _selectedTab = 0;
  final List<String> _images = [
    'assets/images/Miranda.png',
    'assets/images/Prueba1.png',
    'assets/images/Prueba2.png',
  ];
  late Timer _timer;

  // ✅ TIMERS PARA NOTIFICACIONES
  Timer? _notificationTimer;
  Timer? _recordatorioTimer;

  // Controller para PageView
  final PageController _pageController = PageController();

  // Datos de ejemplo para las noticias
  final List<NoticiaModel> noticiasCategoria1 = [
    NoticiaModel(
      titulo: 'Reforma Fiscal 2024',
      imagen: 'assets/images/Miranda.png',
    ),
    NoticiaModel(
      titulo: 'Nuevas Deducciones',
      imagen: 'assets/images/Prueba1.png',
    ),
    NoticiaModel(
      titulo: 'Impuestos Digitales',
      imagen: 'assets/images/Prueba2.png',
    ),
    NoticiaModel(
      titulo: 'Declaración Anual',
      imagen: 'assets/images/Miranda.png',
    ),
  ];

  final List<NoticiaModel> noticiasCategoria2 = [
    NoticiaModel(titulo: 'SAT Digital', imagen: 'assets/images/Prueba1.png'),
    NoticiaModel(titulo: 'CFDI 4.0', imagen: 'assets/images/Prueba2.png'),
    NoticiaModel(
      titulo: 'Facturación Electrónica',
      imagen: 'assets/images/Miranda.png',
    ),
    NoticiaModel(
      titulo: 'Buzón Tributario',
      imagen: 'assets/images/Prueba1.png',
    ),
  ];

  final List<NoticiaModel> noticiasCategoria3 = [
    NoticiaModel(titulo: 'SAT Digital', imagen: 'assets/images/Prueba1.png'),
    NoticiaModel(titulo: 'CFDI 4.0', imagen: 'assets/images/Prueba2.png'),
    NoticiaModel(
      titulo: 'Facturación Electrónica',
      imagen: 'assets/images/Miranda.png',
    ),
    NoticiaModel(
      titulo: 'Buzón Tributario',
      imagen: 'assets/images/Prueba1.png',
    ),
  ];
  // MÉTODO PARA CARGAR EL RESUMEN
  Future<void> cargarResumen() async {
    try {
      setState(() {
        _isLoadingResumen = true;
        _errorResumen = null;
      });
      final r = await ApiService.fetchResumen(inicio, fin);
      if (!mounted) return;
      setState(() {
        resumen = r;
        _isLoadingResumen = false;
      });
    } catch (e) {
      setState(() {
        _isLoadingResumen = false;
        _errorResumen = e.toString();
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(Duration(seconds: 3), (Timer timer) {
      _nextImage();
    });

    // ✅ PROGRAMAR NOTIFICACIONES
    _scheduleDailyNotification();
    _scheduleDailyRecordatorio();
    // Cargar el resumen al iniciar
    cargarResumen();
  }

  @override
  void dispose() {
    _timer.cancel();
    _pageController.dispose();
    // ✅ CANCELAR TIMERS DE NOTIFICACIONES
    _notificationTimer?.cancel();
    _recordatorioTimer?.cancel();
    super.dispose();
  }

  void _nextImage() {
    setState(() {
      _currentIndex = (_currentIndex + 1) % _images.length;
    });
  }

  void _goToImage(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  // ✅ MÉTODOS PARA NOTIFICACIONES
  void _scheduleDailyNotification() {
    final now = DateTime.now();
    final scheduledTime = DateTime(
      now.year,
      now.month,
      now.day,
      13, // 10 AM
      28, // 00 minutos
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

  void _scheduleDailyRecordatorio() {
    final now = DateTime.now();
    final scheduledTime = DateTime(
      now.year,
      now.month,
      now.day,
      22, // 8 PM
      53, // 00 minutos
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

  //Hacer que la navegue entre pantallas sea con animaciones
  void _onTabTapped(int index) {
    setState(() {
      _selectedTab = index;
    });

    if (index == 1) {
      // Navegar a FormCrearCFDIScreen con animación
      Navigator.push(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              CalendarScreen(),
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
          transitionDuration: Duration(milliseconds: 500),
        ),
      );
    } else if (index == 2) {
      // Navegar a ApartadoCCF con animación
      Navigator.push(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              ApartadoCCF(),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: HomeDesigns.buildAppBar(context), // ← AGREGAR context aquí
      body: Stack(
        children: [
          // CONTENIDO PRINCIPAL - PageView
          PageView(
            controller: _pageController,
            scrollDirection: Axis.vertical,
            children: [
              // PANTALLA 1 - BANNER + ANÁLISIS + OBLIGACIONES + BOTONES
              Container(
                padding: EdgeInsets.all(20),
                child: Stack(
                  // ← CAMBIAR Column por Stack
                  children: [
                    // CONTENIDO PRINCIPAL (todo lo que ya tenías)
                    Column(
                      children: [
                        // Carrusel automático de imágenes
                        Container(
                          width: double.infinity,
                          height: 200,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: Colors.grey[300],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: Image.asset(
                              _images[_currentIndex],
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.error,
                                        size: 40,
                                        color: Colors.grey,
                                      ),
                                      SizedBox(height: 10),
                                      Text('Imagen no encontrada'),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                        SizedBox(height: 15),

                        // Indicadores de puntos para el carrusel
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: _images.asMap().entries.map((entry) {
                            return GestureDetector(
                              onTap: () => _goToImage(entry.key),
                              child: Container(
                                width: 12.0,
                                height: 12.0,
                                margin: EdgeInsets.symmetric(horizontal: 6.0),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: _currentIndex == entry.key
                                      ? Colors.blue
                                      : Colors.grey.withOpacity(0.4),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                        SizedBox(height: 20),

                        // Módulo de Análisis de Progreso
                        HomeDesigns.buildImageModule(
                          imagePath: 'assets/images/Ana_proge.png',
                          height: 160,
                        ),
                        SizedBox(height: 10),

                        // Módulo de Obligaciones
                        if (_isLoadingResumen) ...[
                          Center(child: CircularProgressIndicator()),
                        ] else if (_errorResumen != null) ...[
                          Center(child: Text("Error: $_errorResumen")),
                        ] else if (resumen != null) ...[
                          // Módulo de Obligaciones con botón "Ver más"
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(
                              vertical: 16,
                              horizontal: 16,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFDDEFE4),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      "Obligaciones",
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black87,
                                      ),
                                    ),
                                    Container(
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFF7FBF8),
                                        borderRadius: BorderRadius.circular(20),
                                        border: Border.all(
                                          color: Colors.grey.shade300,
                                        ),
                                      ),
                                      child: TextButton(
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            PageRouteBuilder(
                                              pageBuilder:
                                                  (
                                                    context,
                                                    animation,
                                                    secondaryAnimation,
                                                  ) => DashboardTareas(),
                                              transitionsBuilder:
                                                  (
                                                    context,
                                                    animation,
                                                    secondaryAnimation,
                                                    child,
                                                  ) {
                                                    const begin = Offset(
                                                      1.0,
                                                      0.0,
                                                    );
                                                    const end = Offset.zero;
                                                    const curve =
                                                        Curves.easeInOut;
                                                    var tween =
                                                        Tween(
                                                          begin: begin,
                                                          end: end,
                                                        ).chain(
                                                          CurveTween(
                                                            curve: curve,
                                                          ),
                                                        );
                                                    var offsetAnimation =
                                                        animation.drive(tween);
                                                    return SlideTransition(
                                                      position: offsetAnimation,
                                                      child: child,
                                                    );
                                                  },
                                              transitionDuration: Duration(
                                                milliseconds: 400,
                                              ),
                                            ),
                                          );
                                        },
                                        style: TextButton.styleFrom(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 12,
                                            vertical: 6,
                                          ),
                                          minimumSize: Size(0, 0),
                                          tapTargetSize:
                                              MaterialTapTargetSize.shrinkWrap,
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: const [
                                            Text(
                                              "Ver más",
                                              style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w500,
                                                color: Colors.black87,
                                              ),
                                            ),
                                            SizedBox(width: 4),
                                            Icon(
                                              Icons.arrow_drop_down,
                                              color: Colors.black87,
                                              size: 20,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                Row(
                                  children: [
                                    Expanded(
                                      child: _buildFicha(
                                        "Pendientes",
                                        resumen!.pendientes,
                                      ),
                                    ),
                                    Container(
                                      width: 5,
                                      height: 65,
                                      color: const Color(0xFF7EC09A),
                                    ),
                                    Expanded(
                                      child: _buildFicha(
                                        "Completadas",
                                        resumen!.completadas,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ] else ...[
                          Center(child: Text("No se pudo cargar el resumen")),
                        ],
                        SizedBox(height: 10),
                      ],
                    ),

                    // ✅ BOTONES SOBRE EL CONTENIDO - POSICIONA DONDE QUIERAS

                    // BOTÓN 1 - SOBRE EL CARRUSEL
                    Positioned(
                      top: 265, // ← AJUSTA POSICIÓN VERTICAL
                      left: 230, // ← AJUSTA POSICIÓN HORIZONTAL
                      child: _buildBotonSobreImagen(
                        texto: 'Btn 1',
                        onTap: () {
                          print('Botón 1 en Pantalla 1 presionado');
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DashboardTareas(),
                            ),
                          );
                        },
                        ancho: 100, // ← AJUSTA ANCHO
                        alto: 25, // ← AJUSTA ALTO
                      ),
                    ),

                    // BOTÓN 4 - ESQUINA INFERIOR DERECHA
                    // Positioned(
                    //   bottom: 20,
                    //   right: 20,
                    //   child: _buildBotonSobreImagen(
                    //     texto: 'Esquina',
                    //     onTap: () {
                    //       print('Botón Esquina en Pantalla 1 presionado');
                    //       // Navigator.push(context, MaterialPageRoute(builder: (context) => TuPantalla4()));
                    //     },
                    //   ),
                    // ),
                  ],
                ),
              ),

              // PANTALLA 2 - GRÁFICA + CFDI CON BOTONES SOBRE IMÁGENES
              Container(
                padding: EdgeInsets.all(20),
                child: Column(
                  children: [
                    // ✅ GRÁFICA CON BOTONES ENCIMA
                    Container(
                      width: double.infinity,
                      height: 280,
                      child: Stack(
                        children: [
                          // IMAGEN DE FONDO - GRÁFICA
                          Container(
                            width: double.infinity,
                            height: 280,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: Colors.grey[300],
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(15),
                              child: Image.asset(
                                'assets/images/Miranda.png',
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Center(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.image_not_supported,
                                          size: 40,
                                          color: Colors.grey,
                                        ),
                                        SizedBox(height: 10),
                                        Text('Imagen no disponible'),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20),

                    // ✅ CFDI RECIENTES CON BOTONES ENCIMA
                    Container(
                      width: double.infinity,
                      height: 290,
                      child: Stack(
                        children: [
                          // IMAGEN DE FONDO - CFDI
                          Container(
                            width: double.infinity,
                            height: 290,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: const Color.fromARGB(0, 255, 255, 255),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(15),
                              child: Image.asset(
                                'assets/images/G-CFDI.png',
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Center(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.image_not_supported,
                                          size: 40,
                                          color: Colors.grey,
                                        ),
                                        SizedBox(height: 10),
                                        Text('Imagen no disponible'),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),

                          // ✅ BOTÓN 5 - POSICIÓN MANUAL (SEGUNDA IMAGEN)
                          Positioned(
                            top: 219,
                            left: 15,
                            child: _buildBotonSobreImagen(
                              texto: 'Botón 5',
                              onTap: () {
                                print('Botón 5 presionado');
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => PrimerCFDIScreen(),
                                  ),
                                );
                              },
                            ),
                          ),

                          // ✅ BOTÓN 6 - POSICIÓN MANUAL
                          Positioned(
                            top: 218, // ← AJUSTA ESTA POSICIÓN
                            right: 190, // ← AJUSTA ESTA POSICIÓN
                            child: _buildBotonSobreImagen(
                              texto: 'Botón 6',
                              onTap: () {
                                print('Botón 5 presionado');
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => SegundoCFDIScreen(),
                                  ),
                                );
                              },
                            ),
                          ),

                          // ✅ BOTÓN 7 - POSICIÓN MANUAL
                          Positioned(
                            bottom: 52, // ← AJUSTA ESTA POSICIÓN
                            left: 195, // ← AJUSTA ESTA POSICIÓN
                            child: _buildBotonSobreImagen(
                              texto: 'Botón 7',
                              onTap: () {
                                print('Botón 5 presionado');
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => TercerCFDIScreen(),
                                  ),
                                );
                              },
                            ),
                          ),

                          // ✅ BOTÓN 8 - POSICIÓN MANUAL
                          Positioned(
                            bottom: 52, // ← AJUSTA ESTA POSICIÓN
                            right: 12, // ← AJUSTA ESTA POSICIÓN
                            child: _buildBotonSobreImagen(
                              texto: 'Botón 8',
                              onTap: () {
                                print('Botón 5 presionado');
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => CuartoCFDIScreen(),
                                  ),
                                );
                              },
                            ),
                          ),

                          // ✅ BOTÓN 9 - POSICIÓN MANUAL
                          Positioned(
                            bottom: 227, // ← AJUSTA ESTA POSICIÓN
                            right: 23, // ← AJUSTA ESTA POSICIÓN
                            child: _buildBotonSobreImagen(
                              texto: 'Botón 9',
                              onTap: () {
                                print('Botón 5 presionado');
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => GeneralCFDIScreen(),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // PANTALLA 3 - NOTICIAS + ACCESOS RÁPIDOS
              Container(
                padding: EdgeInsets.all(20),
                child: Column(
                  children: [
                    // NOTICIAS
                    HomeDesigns.buildImageModule4(
                      imagePath: 'assets/images/Logo.png',
                      height: 180,
                    ),
                    SizedBox(height: 40),

                    // ACCESOS RÁPIDOS
                    HomeDesigns.buildAccesosRapidos(context),
                  ],
                ),
              ),

              // PANTALLA 4 - NOTICIAS RECOMENDADAS
              Container(
                padding: EdgeInsets.all(20),
                child: _buildNoticiasRecomendadas(),
              ),

              // PANTALLA 5 - GLOSARIO
              Container(
                padding: EdgeInsets.all(20),
                child: HomeDesigns.buildGlosarioTerminos(context),
              ),

              // PANTALLA 6 - PREGUNTAS FRECUENTES
              Container(
                padding: EdgeInsets.all(20),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Preguntas Frecuentes',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: const Color.fromARGB(255, 0, 0, 0),
                        ),
                      ),
                      SizedBox(height: 20),
                      PreguntasAcordeon(),
                    ],
                  ),
                ),
              ),
            ],
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

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedTab,
        onTap: _onTabTapped,
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
              color: _selectedTab == 0 ? Colors.green : Colors.grey,
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              'assets/images/CalendarioA.png',
              width: 30,
              height: 30,
              color: _selectedTab == 1 ? Colors.green : Colors.grey,
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              'assets/images/AsesoriasA.png',
              width: 30,
              height: 30,
              color: _selectedTab == 2 ? Colors.green : Colors.grey,
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              'assets/images/NotificacionA.png',
              width: 30,
              height: 30,
              color: _selectedTab == 3 ? Colors.green : Colors.grey,
            ),
            label: '',
          ),
        ],
      ),

      // ✅ BOTÓN TEMPORAL PARA PROBAR NOTIFICACIONES (OPCIONAL)
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     _triggerNotificacion(); // Forzar notificación
      //   },
      //   child: Icon(Icons.notification_add),
      //   backgroundColor: Colors.green,
      // ),
      // floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  Widget _buildFicha(String tipo, int valor) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8),
        padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 16),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 8),
            Text(
              "$valor",
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),

            const SizedBox(height: 8),
            Text(
              tipo,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }

  // ✅ WIDGET DE NOTIFICACIÓN EMERGENTE
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

  // MÉTODOS PARA NOTICIAS RECOMENDADAS
  Widget _buildNoticiasRecomendadas() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Noticias Recomendadas',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          SizedBox(height: 10),
          _buildCategoriaNoticias(
            titulo: 'Emprende y crece',
            noticias: noticiasCategoria1,
            onVerTodo: () {
              // Navegar a la página de categoría 1 de noticias
              Navigator.push(
                context,
                PageRouteBuilder(
                  pageBuilder: (context, animation, secondaryAnimation) =>
                      NoticiasRecomendadaCate1(),
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
          _buildCategoriaNoticias(
            titulo: 'Seguridad social',
            noticias: noticiasCategoria2,
            onVerTodo: () {
              // TODO: Crear página para categoría 2 y navegar aquí
              // Navigator.push(context, MaterialPageRoute(builder: (context) => NoticiasRecomendadaCate2()));
              print('Navegar a categoría 2 de noticias');
            },
          ),
          _buildCategoriaNoticias(
            titulo: 'Evita multas',
            noticias: noticiasCategoria3,
            onVerTodo: () {
              // TODO: Crear página para categoría 2 y navegar aquí
              // Navigator.push(context, MaterialPageRoute(builder: (context) => NoticiasRecomendadaCate2()));
              print('Navegar a categoría 3 de noticias');
            },
          ),
        ],
      ),
    );
  }

  Widget _buildCategoriaNoticias({
    required String titulo,
    required List<NoticiaModel> noticias,
    required VoidCallback onVerTodo, // ← AGREGAR ESTE PARÁMETRO
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              titulo,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.grey[800],
              ),
            ),
            Container(
              width: 35,
              height: 35,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color.fromARGB(255, 94, 153, 83),
              ),
              child: IconButton(
                onPressed: onVerTodo, // ← USAR EL PARÁMETRO AQUÍ
                icon: Icon(Icons.arrow_forward, color: Colors.white, size: 18),
                padding: EdgeInsets.zero,
              ),
            ),
          ],
        ),
        SizedBox(height: 8),
        Container(
          height: 140,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: noticias.length,
            itemBuilder: (context, index) {
              return _buildTarjetaNoticia(noticias[index]);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildTarjetaNoticia(NoticiaModel noticia) {
    return GestureDetector(
      onTap: () {
        print('Navegar a noticia: ${noticia.titulo}');
      },
      child: Container(
        width: 158,
        margin: EdgeInsets.only(right: 15, top: 5, bottom: 5, left: 5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              blurRadius: 6,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: ClipRRect(
          // ← ENVOLVER TODO EN ClipRRect
          borderRadius: BorderRadius.circular(12),
          child: Container(
            height: 140, // ← ALTURA FIJA PARA TODA LA TARJETA
            width: double.infinity,
            decoration: BoxDecoration(color: Colors.grey[300]),
            child: Image.asset(
              noticia.imagen,
              fit: BoxFit.cover, // ← HACER QUE LA IMAGEN OCUPE TODO EL ESPACIO
              errorBuilder: (context, error, stackTrace) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.article, size: 30, color: Colors.grey),
                      SizedBox(height: 10),
                      Text(
                        'Imagen no disponible',
                        style: TextStyle(fontSize: 10, color: Colors.grey),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  // ✅ BOTÓN GRIS SOBRE IMAGEN - TOTALMENTE PERSONALIZABLE
  Widget _buildBotonSobreImagen({
    required String texto,
    required VoidCallback onTap,
    double? ancho,
    double? alto,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: ancho ?? 56, // Ancho por defecto 100, puedes cambiarlo
        height: alto ?? 18, // Alto por defecto 40, puedes cambiarlo
        decoration: BoxDecoration(
          color: const Color.fromARGB(
            0,
            0,
            0,
            0,
          ).withOpacity(0.0), // Gris con transparencia
          border: Border.all(color: const Color.fromARGB(0, 0, 0, 0), width: 1),
        ),
        child: Center(
          child: Text(
            texto,
            style: TextStyle(
              color: const Color.fromARGB(0, 7, 7, 7),
              fontWeight: FontWeight.w600,
              fontSize: 12,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
