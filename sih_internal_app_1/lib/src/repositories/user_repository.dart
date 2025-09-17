// filepath: lib/src/repositories/user_repository.dart
import 'package:sih_internal_app_1/src/models/current_user.dart';
import 'package:sih_internal_app_1/src/services/local_json_loader.dart';

class UserRepository {
  final String assetPath;
  UserRepository({this.assetPath = 'assets/data/current_user.json'});

  Future<CurrentUser> fetchCurrentUser() async {
    final jsonData =
        await LocalJsonLoader.loadJson(assetPath) as Map<String, dynamic>;
    return CurrentUser.fromJson(jsonData);
  }
}
