import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Servicios
import 'services/notification_manager.dart';
import 'services/notification_overlay_service.dart';

// Pantallas
import './Crear_Cuenta/Form_crear_cuenta.dart';
import 'package:coco_fiscal/screens/calendar_screen.dart';
// import 'package:coco_fiscal/screens/tareas_screen.dart';
import 'package:coco_fiscal/screens/formulario_tarea.dart';
import 'package:coco_fiscal/splash_screen.dart';
import 'package:coco_fiscal/Apartado_A_home.dart';
import 'package:coco_fiscal/login_screen.dart';
import 'package:coco_fiscal/screens/tareas_screen.dart';
import 'package:coco_fiscal/screens/dashboard_tareas.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => NotificationManager()),
        ChangeNotifierProvider(
          create: (context) => NotificationOverlayService(),
        ),
      ],
      child: MaterialApp(
        title: 'Agenda Fiscal',
        theme: ThemeData(primarySwatch: Colors.green),
        debugShowCheckedModeBanner: false,
        initialRoute: '/',
        routes: {
          '/': (context) => SplashWrapper(),
          // '/formulario_tarea': (context) => FormularioTarea(),
          '/calendar': (context) => CalendarScreen(),
          '/crear_cuenta': (context) => CrearCuentaScreen(),
          '/home': (context) => ApartadoAHome(),
          '/login': (context) => LoginScreen(),
          '/obligaciones': (context) => TareasScreen(),
          '/resumen': (context) => DashboardTareas(),
          '/formulario_tarea': (context) => FormularioTarea(),
          '/dashboard': (context) => DashboardTareas(),
        },
      ),
    );
  }
}

// SplashWrapper con transición a LoginScreen
class SplashWrapper extends StatefulWidget {
  const SplashWrapper({super.key});

  @override
  State<SplashWrapper> createState() => _SplashWrapperState();
}

class _SplashWrapperState extends State<SplashWrapper> {
  bool _showSplash = true;

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      onAnimationComplete: () {
        if (_showSplash) {
          setState(() {
            _showSplash = false;
          });

          Future.delayed(const Duration(milliseconds: 500), () {
            Navigator.of(context).pushReplacement(
              PageRouteBuilder(
                transitionDuration: const Duration(milliseconds: 800),
                pageBuilder: (_, __, ___) => LoginScreen(),
                transitionsBuilder: (_, animation, __, child) {
                  return FadeTransition(opacity: animation, child: child);
                },
              ),
            );
          });
        }
      },
    );
  }
}
