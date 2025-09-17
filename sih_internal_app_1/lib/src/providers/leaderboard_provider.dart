// filepath: lib/src/providers/leaderboard_provider.dart
import 'package:flutter/foundation.dart';
import 'package:sih_internal_app_1/src/models/leaderboard_entry.dart';
import 'package:sih_internal_app_1/src/repositories/leaderboard_repository.dart';

class LeaderboardProvider extends ChangeNotifier {
  final LeaderboardRepository repository;
  LeaderboardProvider({LeaderboardRepository? repository})
      : repository = repository ?? LeaderboardRepository();

  List<LeaderboardEntry> _entries = [];
  bool _loading = false;
  Object? _error;

  List<LeaderboardEntry> get entries => _entries;
  bool get loading => _loading;
  Object? get error => _error;

  Future<void> load() async {
    _loading = true;
    _error = null;
    notifyListeners();
    try {
      _entries = await repository.fetchLeaderboard();
    } catch (e) {
      _error = e;
    } finally {
      _loading = false;
      notifyListeners();
    }
  }
}
