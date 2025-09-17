// filepath: lib/src/models/notification.dart
enum NotificationType {
  assessment,
  achievement,
  result,
  reminder,
  system,
  general
}

class NotificationItem {
  final String id;
  final String title;
  final String message;
  final NotificationType type;
  final DateTime timestamp;
  final bool isRead;
  final String? actionButton;
  final int? score;

  NotificationItem({
    required this.id,
    required this.title,
    required this.message,
    required this.type,
    required this.timestamp,
    this.isRead = false,
    this.actionButton,
    this.score,
  });

  factory NotificationItem.fromJson(Map<String, dynamic> json) {
    return NotificationItem(
      id: json['id'] as String,
      title: json['title'] as String,
      message: json['message'] as String,
      type: _typeFromString(json['type'] as String),
      timestamp: DateTime.parse(json['timestamp'] as String),
      isRead: (json['isRead'] ?? false) as bool,
      actionButton: json['actionButton'] as String?,
      score: json['score'] as int?,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'message': message,
        'type': type.name,
        'timestamp': timestamp.toIso8601String(),
        'isRead': isRead,
        'actionButton': actionButton,
        'score': score,
      };

  static NotificationType _typeFromString(String value) {
    return NotificationType.values.firstWhere(
      (e) => e.name == value,
      orElse: () => NotificationType.general,
    );
  }
}
