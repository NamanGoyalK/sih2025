// filepath: lib/src/models/leaderboard_entry.dart
class LeaderboardEntry {
  final int rank;
  final String name;
  final int points;
  final int change; // positive/negative delta

  LeaderboardEntry({
    required this.rank,
    required this.name,
    required this.points,
    required this.change,
  });

  factory LeaderboardEntry.fromJson(Map<String, dynamic> json) {
    return LeaderboardEntry(
      rank: (json['rank'] as num).toInt(),
      name: json['name'] as String,
      points: (json['points'] as num).toInt(),
      change: (json['change'] as num).toInt(),
    );
  }

  Map<String, dynamic> toJson() => {
        'rank': rank,
        'name': name,
        'points': points,
        'change': change,
      };
}
