// filepath: lib/src/providers/video_analysis_provider.dart
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:sih_internal_app_1/src/models/video_analysis_result.dart';
import 'package:sih_internal_app_1/src/services/video_analysis_service.dart';

class VideoAnalysisProvider extends ChangeNotifier {
  final VideoAnalysisService _service = VideoAnalysisService();

  VideoAnalysisResult? _result;
  bool _isAnalyzing = false;
  String? _error;
  double _uploadProgress = 0.0;

  VideoAnalysisResult? get result => _result;
  bool get isAnalyzing => _isAnalyzing;
  String? get error => _error;
  double get uploadProgress => _uploadProgress;

  /// Analyze a workout video
  Future<void> analyzeVideo(File videoFile, String workoutType) async {
    _isAnalyzing = true;
    _error = null;
    _result = null;
    _uploadProgress = 0.0;
    notifyListeners();

    try {
      // Simulate upload progress (since Dio doesn't provide real progress for this use case)
      _simulateUploadProgress();

      _result = await _service.analyzeWorkoutVideo(videoFile, workoutType);
      _uploadProgress = 1.0;

      // Cache the result for later viewing
      await _cacheResult(_result!, workoutType);
    } catch (e) {
      _error = e.toString();
      debugPrint('Video analysis error: $e');
    } finally {
      _isAnalyzing = false;
      notifyListeners();
    }
  }

  /// Cache analysis result locally
  Future<void> _cacheResult(
      VideoAnalysisResult result, String workoutType) async {
    try {
      // TODO: Implement local storage caching if needed
      // For now, we just keep it in memory
      debugPrint('Analysis result cached for $workoutType');
    } catch (e) {
      debugPrint('Failed to cache result: $e');
    }
  }

  /// Clear the current analysis result and error state
  void clearResult() {
    _result = null;
    _error = null;
    _uploadProgress = 0.0;
    notifyListeners();
  }

  /// Simulate upload progress for better UX
  void _simulateUploadProgress() {
    const duration = Duration(milliseconds: 100);

    Future.delayed(duration, () {
      if (_isAnalyzing && _uploadProgress < 0.3) {
        _uploadProgress = 0.1;
        notifyListeners();
        _simulateUploadProgress();
      }
    });

    Future.delayed(const Duration(seconds: 2), () {
      if (_isAnalyzing && _uploadProgress < 0.6) {
        _uploadProgress = 0.4;
        notifyListeners();
      }
    });

    Future.delayed(const Duration(seconds: 4), () {
      if (_isAnalyzing && _uploadProgress < 0.8) {
        _uploadProgress = 0.7;
        notifyListeners();
      }
    });
  }
}
