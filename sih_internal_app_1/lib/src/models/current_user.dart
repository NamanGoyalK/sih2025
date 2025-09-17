// filepath: lib/src/models/current_user.dart
class CurrentUser {
  final String name;

  CurrentUser({required this.name});

  factory CurrentUser.fromJson(Map<String, dynamic> json) {
    return CurrentUser(
      name: json['name'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
        'name': name,
      };
}
