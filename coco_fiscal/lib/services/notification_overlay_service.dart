// services/notification_overlay_service.dart
import 'package:flutter/material.dart';

class NotificationOverlayService with ChangeNotifier {
  static final NotificationOverlayService _instance =
      NotificationOverlayService._internal();
  factory NotificationOverlayService() => _instance;
  NotificationOverlayService._internal();

  bool _showOverlay = false;
  Map<String, dynamic>? _currentNotification;
  String? _currentNotificationType;

  bool get showOverlay => _showOverlay;
  Map<String, dynamic>? get currentNotification => _currentNotification;
  String? get currentNotificationType => _currentNotificationType;

  // Mostrar notificación
  void showNotification(
    Map<String, dynamic> notification, {
    String type = 'notificacion',
  }) {
    _currentNotification = notification;
    _currentNotificationType = type;
    _showOverlay = true;
    notifyListeners();

    // Ocultar automáticamente después de 5 segundos
    Future.delayed(Duration(seconds: 5), () {
      hideNotification();
    });
  }

  // Ocultar notificación manualmente
  void hideNotification() {
    _showOverlay = false;
    _currentNotification = null;
    _currentNotificationType = null;
    notifyListeners();
  }
}
