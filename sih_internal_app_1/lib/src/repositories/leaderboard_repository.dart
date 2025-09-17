// filepath: lib/src/repositories/leaderboard_repository.dart
import 'package:sih_internal_app_1/src/models/leaderboard_entry.dart';
import 'package:sih_internal_app_1/src/services/local_json_loader.dart';

class LeaderboardRepository {
  final String assetPath;
  LeaderboardRepository({this.assetPath = 'assets/data/leaderboard.json'});

  Future<List<LeaderboardEntry>> fetchLeaderboard() async {
    final jsonData = await LocalJsonLoader.loadJson(assetPath) as List<dynamic>;
    return jsonData
        .map((e) => LeaderboardEntry.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
