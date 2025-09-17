// filepath: lib/src/repositories/results_repository.dart
import 'package:sih_internal_app_1/src/models/results.dart';
import 'package:sih_internal_app_1/src/services/local_json_loader.dart';

class ResultsRepository {
  final String summaryAssetPath;
  final String jumpsAssetPath;

  ResultsRepository({
    this.summaryAssetPath = 'assets/data/results_vertical_jump_summary.json',
    this.jumpsAssetPath = 'assets/data/results_vertical_jump_jumps.json',
  });

  Future<ResultSummary> fetchSummary() async {
    final jsonData = await LocalJsonLoader.loadJson(summaryAssetPath)
        as Map<String, dynamic>;
    return ResultSummary.fromJson(jsonData);
  }

  Future<List<JumpEntry>> fetchJumps() async {
    final jsonData =
        await LocalJsonLoader.loadJson(jumpsAssetPath) as List<dynamic>;
    return jsonData
        .map((e) => JumpEntry.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
