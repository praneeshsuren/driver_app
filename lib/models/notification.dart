enum NotificationType { urgent, reassignment, deliveryUpdate, route, system }

enum NotificationPriority { low, medium, high, urgent }

class AppNotification {
  final String id;
  final String title;
  final String message;
  final NotificationType type;
  final NotificationPriority priority;
  final DateTime timestamp;
  final bool isRead;
  final String? deliveryId;
  final String? actionUrl;
  final Map<String, dynamic>? data;

  AppNotification({
    required this.id,
    required this.title,
    required this.message,
    required this.type,
    required this.priority,
    required this.timestamp,
    this.isRead = false,
    this.deliveryId,
    this.actionUrl,
    this.data,
  });

  AppNotification copyWith({
    String? id,
    String? title,
    String? message,
    NotificationType? type,
    NotificationPriority? priority,
    DateTime? timestamp,
    bool? isRead,
    String? deliveryId,
    String? actionUrl,
    Map<String, dynamic>? data,
  }) {
    return AppNotification(
      id: id ?? this.id,
      title: title ?? this.title,
      message: message ?? this.message,
      type: type ?? this.type,
      priority: priority ?? this.priority,
      timestamp: timestamp ?? this.timestamp,
      isRead: isRead ?? this.isRead,
      deliveryId: deliveryId ?? this.deliveryId,
      actionUrl: actionUrl ?? this.actionUrl,
      data: data ?? this.data,
    );
  }
}

// Sample notification data
class NotificationData {
  static List<AppNotification> getSampleNotifications() {
    return [
      // Urgent notifications
      AppNotification(
        id: 'N001',
        title: 'URGENT: Route Change Required',
        message:
            'Heavy traffic on Main St. Reroute recommended for deliveries D005-D008.',
        type: NotificationType.urgent,
        priority: NotificationPriority.urgent,
        timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
        deliveryId: 'D005',
      ),
      AppNotification(
        id: 'N002',
        title: 'URGENT: Customer Not Available',
        message:
            'Customer at 789 Oak St is not available. Delivery D003 needs immediate attention.',
        type: NotificationType.urgent,
        priority: NotificationPriority.urgent,
        timestamp: DateTime.now().subtract(const Duration(minutes: 15)),
        deliveryId: 'D003',
      ),

      // Reassignments
      AppNotification(
        id: 'N003',
        title: 'Delivery Reassigned',
        message:
            'Delivery D009 has been reassigned to you from Driver #237. Priority delivery.',
        type: NotificationType.reassignment,
        priority: NotificationPriority.high,
        timestamp: DateTime.now().subtract(const Duration(minutes: 30)),
        deliveryId: 'D009',
        data: {'previousDriver': '237', 'reason': 'Vehicle breakdown'},
      ),
      AppNotification(
        id: 'N004',
        title: 'Route Reassignment',
        message:
            'Downtown route reassigned. 3 new deliveries added to your manifest.',
        type: NotificationType.reassignment,
        priority: NotificationPriority.high,
        timestamp: DateTime.now().subtract(const Duration(hours: 1)),
        data: {
          'newDeliveries': ['D010', 'D011', 'D012'],
        },
      ),

      // Delivery Updates
      AppNotification(
        id: 'N005',
        title: 'Delivery Address Updated',
        message:
            'D001 delivery address changed to 456 Pine St, Apt 2B. Customer confirmed.',
        type: NotificationType.deliveryUpdate,
        priority: NotificationPriority.medium,
        timestamp: DateTime.now().subtract(const Duration(hours: 2)),
        deliveryId: 'D001',
        isRead: true,
      ),
      AppNotification(
        id: 'N006',
        title: 'Special Instructions Added',
        message: 'D002: Ring doorbell twice. Package contains fragile items.',
        type: NotificationType.deliveryUpdate,
        priority: NotificationPriority.medium,
        timestamp: DateTime.now().subtract(const Duration(hours: 3)),
        deliveryId: 'D002',
      ),

      // Route notifications
      AppNotification(
        id: 'N007',
        title: 'Route Optimization Available',
        message: 'New route saves 15 minutes. Tap to apply suggested changes.',
        type: NotificationType.route,
        priority: NotificationPriority.medium,
        timestamp: DateTime.now().subtract(const Duration(hours: 4)),
        actionUrl: '/route-optimization',
      ),

      // System notifications
      AppNotification(
        id: 'N008',
        title: 'App Update Available',
        message: 'Version 2.1.0 available with improved navigation features.',
        type: NotificationType.system,
        priority: NotificationPriority.low,
        timestamp: DateTime.now().subtract(const Duration(days: 1)),
        isRead: true,
      ),
      AppNotification(
        id: 'N009',
        title: 'Maintenance Window',
        message: 'System maintenance scheduled for tonight 11 PM - 2 AM EST.',
        type: NotificationType.system,
        priority: NotificationPriority.medium,
        timestamp: DateTime.now().subtract(const Duration(days: 1, hours: 2)),
      ),
    ];
  }

  static List<AppNotification> getNotificationsByType(NotificationType type) {
    return getSampleNotifications()
        .where((notification) => notification.type == type)
        .toList();
  }

  static List<AppNotification> getUnreadNotifications() {
    return getSampleNotifications()
        .where((notification) => !notification.isRead)
        .toList();
  }

  static List<AppNotification> getUrgentNotifications() {
    return getSampleNotifications()
        .where(
          (notification) =>
              notification.priority == NotificationPriority.urgent ||
              notification.type == NotificationType.urgent,
        )
        .toList();
  }
}
