// filepath: lib/src/providers/user_provider.dart
import 'package:flutter/foundation.dart';
import 'package:sih_internal_app_1/src/models/current_user.dart';
import 'package:sih_internal_app_1/src/repositories/user_repository.dart';

class UserProvider extends ChangeNotifier {
  final UserRepository repository;
  UserProvider({UserRepository? repository}) : repository = repository ?? UserRepository();

  CurrentUser? _user;
  bool _loading = false;
  Object? _error;

  CurrentUser? get user => _user;
  bool get loading => _loading;
  Object? get error => _error;

  Future<void> load() async {
    _loading = true;
    _error = null;
    notifyListeners();
    try {
      _user = await repository.fetchCurrentUser();
    } catch (e) {
      _error = e;
    } finally {
      _loading = false;
      notifyListeners();
    }
  }
}
