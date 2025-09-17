// filepath: lib/src/providers/assessment_provider.dart
import 'package:flutter/foundation.dart';
import 'package:sih_internal_app_1/src/models/assessment_category.dart';
import 'package:sih_internal_app_1/src/repositories/assessment_repository.dart';

class AssessmentProvider extends ChangeNotifier {
  final AssessmentRepository repository;
  AssessmentProvider({AssessmentRepository? repository})
      : repository = repository ?? AssessmentRepository();

  List<AssessmentCategory> _categories = [];
  bool _loading = false;
  Object? _error;

  List<AssessmentCategory> get categories => _categories;
  bool get loading => _loading;
  Object? get error => _error;

  Future<void> load() async {
    _loading = true;
    _error = null;
    notifyListeners();
    try {
      _categories = await repository.fetchCategories();
    } catch (e) {
      _error = e;
    } finally {
      _loading = false;
      notifyListeners();
    }
  }
}
