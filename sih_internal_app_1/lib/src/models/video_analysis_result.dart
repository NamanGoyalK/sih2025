// filepath: lib/src/models/video_analysis_result.dart
class VideoAnalysisResult {
  final VideoAnalysisSummary summary;
  final List<RepAnalysis> reps;
  final String csvDownloadUrl;
  final String videoDownloadUrl;

  VideoAnalysisResult({
    required this.summary,
    required this.reps,
    required this.csvDownloadUrl,
    required this.videoDownloadUrl,
  });

  factory VideoAnalysisResult.fromJson(Map<String, dynamic> json) {
    return VideoAnalysisResult(
      summary: VideoAnalysisSummary.fromJson(json['summary'] ?? {}),
      reps: (json['reps'] as List<dynamic>?)
              ?.map((rep) => RepAnalysis.fromJson(rep as Map<String, dynamic>))
              .toList() ??
          [],
      csvDownloadUrl: json['csv_download_url'] as String? ?? '',
      videoDownloadUrl: json['video_download_url'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'summary': summary.toJson(),
      'reps': reps.map((rep) => rep.toJson()).toList(),
      'csv_download_url': csvDownloadUrl,
      'video_download_url': videoDownloadUrl,
    };
  }
}

class VideoAnalysisSummary {
  final int totalReps;
  final double durationSec;
  final double averageAngle;
  final double minAngle;
  final double maxAngle;

  VideoAnalysisSummary({
    required this.totalReps,
    required this.durationSec,
    required this.averageAngle,
    required this.minAngle,
    required this.maxAngle,
  });

  factory VideoAnalysisSummary.fromJson(Map<String, dynamic> json) {
    return VideoAnalysisSummary(
      totalReps: (json['total_reps'] as num?)?.toInt() ?? 0,
      durationSec: (json['duration_sec'] as num?)?.toDouble() ?? 0.0,
      averageAngle: (json['average_angle'] as num?)?.toDouble() ?? 0.0,
      minAngle: (json['min_angle'] as num?)?.toDouble() ?? 0.0,
      maxAngle: (json['max_angle'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'total_reps': totalReps,
      'duration_sec': durationSec,
      'average_angle': averageAngle,
      'min_angle': minAngle,
      'max_angle': maxAngle,
    };
  }
}

class RepAnalysis {
  final int repNumber;
  final int startFrame;
  final int endFrame;
  final double minAngle;
  final double maxAngle;

  RepAnalysis({
    required this.repNumber,
    required this.startFrame,
    required this.endFrame,
    required this.minAngle,
    required this.maxAngle,
  });

  factory RepAnalysis.fromJson(Map<String, dynamic> json) {
    return RepAnalysis(
      repNumber: (json['rep_number'] as num?)?.toInt() ?? 0,
      startFrame: (json['start_frame'] as num?)?.toInt() ?? 0,
      endFrame: (json['end_frame'] as num?)?.toInt() ?? 0,
      minAngle: (json['min_angle'] as num?)?.toDouble() ?? 0.0,
      maxAngle: (json['max_angle'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'rep_number': repNumber,
      'start_frame': startFrame,
      'end_frame': endFrame,
      'min_angle': minAngle,
      'max_angle': maxAngle,
    };
  }
}
