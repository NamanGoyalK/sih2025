// filepath: lib/src/repositories/assessment_repository.dart
import 'package:sih_internal_app_1/src/models/assessment_category.dart';
import 'package:sih_internal_app_1/src/services/local_json_loader.dart';

class AssessmentRepository {
  final String assetPath;
  AssessmentRepository(
      {this.assetPath = 'assets/data/assessment_categories.json'});

  Future<List<AssessmentCategory>> fetchCategories() async {
    final jsonData = await LocalJsonLoader.loadJson(assetPath) as List<dynamic>;
    return jsonData
        .map((e) => AssessmentCategory.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
