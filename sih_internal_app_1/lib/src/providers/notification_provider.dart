// filepath: lib/src/providers/notification_provider.dart
import 'package:flutter/foundation.dart';
import 'package:sih_internal_app_1/src/models/notification.dart';
import 'package:sih_internal_app_1/src/repositories/notification_repository.dart';

class NotificationsProvider extends ChangeNotifier {
  final NotificationRepository repository;
  NotificationsProvider({NotificationRepository? repository})
      : repository = repository ?? NotificationRepository();

  List<NotificationItem> _items = [];
  bool _loading = false;
  Object? _error;

  List<NotificationItem> get items => _items;
  bool get loading => _loading;
  Object? get error => _error;

  Future<void> load() async {
    _loading = true;
    _error = null;
    notifyListeners();
    try {
      _items = await repository.fetchNotifications();
    } catch (e) {
      _error = e;
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  void markAllRead() {
    _items = _items
        .map((n) => NotificationItem(
              id: n.id,
              title: n.title,
              message: n.message,
              type: n.type,
              timestamp: n.timestamp,
              isRead: true,
              actionButton: n.actionButton,
              score: n.score,
            ))
        .toList();
    notifyListeners();
  }

  void markItemRead(String id) {
    _items = _items
        .map((n) => n.id == id
            ? NotificationItem(
                id: n.id,
                title: n.title,
                message: n.message,
                type: n.type,
                timestamp: n.timestamp,
                isRead: true,
                actionButton: n.actionButton,
                score: n.score,
              )
            : n)
        .toList();
    notifyListeners();
  }

  void deleteById(String id) {
    _items = _items.where((n) => n.id != id).toList();
    notifyListeners();
  }
}
