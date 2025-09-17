// filepath: lib/src/repositories/notification_repository.dart
import 'package:sih_internal_app_1/src/models/notification.dart';
import 'package:sih_internal_app_1/src/services/local_json_loader.dart';

class NotificationRepository {
  final String assetPath;
  NotificationRepository({this.assetPath = 'assets/data/notifications.json'});

  Future<List<NotificationItem>> fetchNotifications() async {
    final jsonData = await LocalJsonLoader.loadJson(assetPath) as List<dynamic>;
    return jsonData
        .map((e) => NotificationItem.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
