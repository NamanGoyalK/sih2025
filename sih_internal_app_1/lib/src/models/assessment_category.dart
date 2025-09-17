// filepath: lib/src/models/assessment_category.dart
class AssessmentCategory {
  final String title;
  final String iconKey; // e.g. 'arrow_upward', 'directions_run'
  final String colorHex; // e.g. '#FF6B6B'
  final String subtitle;
  final String duration;
  final String description;
  final bool isPopular;

  AssessmentCategory({
    required this.title,
    required this.iconKey,
    required this.colorHex,
    required this.subtitle,
    required this.duration,
    required this.description,
    required this.isPopular,
  });

  factory AssessmentCategory.fromJson(Map<String, dynamic> json) {
    return AssessmentCategory(
      title: json['title'] as String,
      iconKey: json['icon'] as String,
      colorHex: json['color'] as String,
      subtitle: json['subtitle'] as String,
      duration: json['duration'] as String,
      description: json['description'] as String,
      isPopular: (json['isPopular'] ?? false) as bool,
    );
  }

  Map<String, dynamic> toJson() => {
        'title': title,
        'icon': iconKey,
        'color': colorHex,
        'subtitle': subtitle,
        'duration': duration,
        'description': description,
        'isPopular': isPopular,
      };
}
