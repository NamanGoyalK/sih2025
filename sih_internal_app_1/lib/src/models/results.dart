// filepath: lib/src/models/results.dart
class ResultSummary {
  final int totalJumps;
  final double bestJumpHeight;
  final double bestJumpDistance;
  final double bestJumpFlightTime;
  final double averageHeight;
  final double averageDistance;
  final double averageKneeAngle;
  final double averageFlightTime;

  ResultSummary({
    required this.totalJumps,
    required this.bestJumpHeight,
    required this.bestJumpDistance,
    required this.bestJumpFlightTime,
    required this.averageHeight,
    required this.averageDistance,
    required this.averageKneeAngle,
    required this.averageFlightTime,
  });

  factory ResultSummary.fromJson(Map<String, dynamic> json) {
    return ResultSummary(
      totalJumps: (json['total_jumps'] as num).toInt(),
      bestJumpHeight: (json['best_jump_height'] as num).toDouble(),
      bestJumpDistance: (json['best_jump_distance'] as num).toDouble(),
      bestJumpFlightTime: (json['best_jump_flight_time'] as num).toDouble(),
      averageHeight: (json['average_height'] as num).toDouble(),
      averageDistance: (json['average_distance'] as num).toDouble(),
      averageKneeAngle: (json['average_knee_angle'] as num).toDouble(),
      averageFlightTime: (json['average_flight_time'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() => {
        'total_jumps': totalJumps,
        'best_jump_height': bestJumpHeight,
        'best_jump_distance': bestJumpDistance,
        'best_jump_flight_time': bestJumpFlightTime,
        'average_height': averageHeight,
        'average_distance': averageDistance,
        'average_knee_angle': averageKneeAngle,
        'average_flight_time': averageFlightTime,
      };
}

class JumpEntry {
  final double heightRelative;
  final double distanceRelative;
  final double kneeAngleAtCrouch;
  final double flightTime;

  JumpEntry({
    required this.heightRelative,
    required this.distanceRelative,
    required this.kneeAngleAtCrouch,
    required this.flightTime,
  });

  factory JumpEntry.fromJson(Map<String, dynamic> json) {
    return JumpEntry(
      heightRelative: (json['Jump Height (relative)'] as num).toDouble(),
      distanceRelative: (json['Jump Distance (relative)'] as num).toDouble(),
      kneeAngleAtCrouch: (json['Knee Angle at crouch'] as num).toDouble(),
      flightTime: (json['Flight Time (s)'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() => {
        'Jump Height (relative)': heightRelative,
        'Jump Distance (relative)': distanceRelative,
        'Knee Angle at crouch': kneeAngleAtCrouch,
        'Flight Time (s)': flightTime,
      };
}
