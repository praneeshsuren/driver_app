import 'package:flutter/material.dart';
import '../models/notification.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final List<AppNotification> _notifications = NotificationData.getSampleNotifications();

  List<AppNotification> getAllNotifications() {
    return List.from(_notifications);
  }

  List<AppNotification> getUnreadNotifications() {
    return _notifications.where((n) => !n.isRead).toList();
  }

  void markAsRead(String notificationId) {
    final index = _notifications.indexWhere((n) => n.id == notificationId);
    if (index != -1) {
      _notifications[index] = _notifications[index].copyWith(isRead: true);
    }
  }

  void addNotification(AppNotification notification) {
    _notifications.insert(0, notification);
  }

  Future<void> initializePushNotifications() async {
    debugPrint('Push notifications initialized');
  }
}
