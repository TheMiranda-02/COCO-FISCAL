// lib/services/notification_manager.dart
import 'package:flutter/material.dart';

class NotificationManager with ChangeNotifier {
  static final NotificationManager _instance = NotificationManager._internal();
  factory NotificationManager() => _instance;
  NotificationManager._internal();

  // Listas GLOBALES que persisten en toda la app
  final List<Map<String, dynamic>> _notificacionesGlobales = [];
  final List<Map<String, dynamic>> _recordatoriosGlobales = [];

  // Getters para acceder a las listas
  List<Map<String, dynamic>> get notificaciones => _notificacionesGlobales;
  List<Map<String, dynamic>> get recordatorios => _recordatoriosGlobales;

  // Agregar notificación
  void agregarNotificacion(Map<String, dynamic> notificacion) {
    _notificacionesGlobales.insert(0, notificacion);
    notifyListeners();
  }

  // Agregar recordatorio
  void agregarRecordatorio(Map<String, dynamic> recordatorio) {
    _recordatoriosGlobales.insert(0, recordatorio);
    notifyListeners();
  }

  // Limpiar listas (opcional)
  void limpiarNotificaciones() {
    _notificacionesGlobales.clear();
    notifyListeners();
  }

  void limpiarRecordatorios() {
    _recordatoriosGlobales.clear();
    notifyListeners();
  }
}
