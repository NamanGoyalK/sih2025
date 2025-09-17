// filepath: lib/src/providers/results_provider.dart
import 'package:flutter/foundation.dart';
import 'package:sih_internal_app_1/src/models/results.dart';
import 'package:sih_internal_app_1/src/repositories/results_repository.dart';

class ResultsProvider extends ChangeNotifier {
  final ResultsRepository repository;
  ResultsProvider({ResultsRepository? repository})
      : repository = repository ?? ResultsRepository();

  ResultSummary? _summary;
  List<JumpEntry> _jumps = [];
  bool _loading = false;
  Object? _error;

  ResultSummary? get summary => _summary;
  List<JumpEntry> get jumps => _jumps;
  bool get loading => _loading;
  Object? get error => _error;

  Future<void> load() async {
    _loading = true;
    _error = null;
    notifyListeners();
    try {
      final s = await repository.fetchSummary();
      final j = await repository.fetchJumps();
      _summary = s;
      _jumps = j;
    } catch (e) {
      _error = e;
    } finally {
      _loading = false;
      notifyListeners();
    }
  }
}
