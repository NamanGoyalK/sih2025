// filepath: lib/src/services/video_analysis_service.dart
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:sih_internal_app_1/src/models/video_analysis_result.dart';

class VideoAnalysisService {
  static const String _baseUrl = 'https://sih-frxf.onrender.com';
  late final Dio _dio;

  // Demo mode for testing without API calls
  static const bool _demoMode = true; // Set to true for testing

  VideoAnalysisService() {
    _dio = Dio(
      BaseOptions(
        baseUrl: _baseUrl,
        connectTimeout:
            const Duration(minutes: 5), // Extended timeout for video upload
        receiveTimeout: const Duration(minutes: 5),
        sendTimeout: const Duration(minutes: 5),
      ),
    );
  }

  /// Analyze a recorded jump video
  /// [videoFile] - The video file to analyze
  /// Returns [VideoAnalysisResult] with analysis data
  Future<VideoAnalysisResult> analyzeJumpsVideo(File videoFile) async {
    if (_demoMode) {
      // Demo mode - return sample data after a delay
      await Future.delayed(const Duration(seconds: 3));
      return VideoAnalysisResult.fromJson({
        "summary": {
          "total_reps": 3,
          "duration_sec": 16.8,
          "average_angle": 79.04,
          "min_angle": 36.87,
          "max_angle": 124.74
        },
        "reps": [
          {
            "rep_number": 1,
            "start_frame": 30,
            "end_frame": 111,
            "min_angle": 37.34,
            "max_angle": 122.52
          },
          {
            "rep_number": 2,
            "start_frame": 117,
            "end_frame": 270,
            "min_angle": 37.84,
            "max_angle": 123.45
          },
          {
            "rep_number": 3,
            "start_frame": 189,
            "end_frame": 426,
            "min_angle": 37.72,
            "max_angle": 124.74
          }
        ],
        "csv_download_url": "/jumps/download/csv?path=results.csv",
        "video_download_url": "/jumps/download/video?path=output.mp4"
      });
    }

    try {
      // Create form data with the video file
      final formData = FormData.fromMap({
        'video': await MultipartFile.fromFile(
          videoFile.path,
          filename: 'workout_video.mp4',
        ),
      });

      // Send POST request to the jumps analysis endpoint
      final response = await _dio.post(
        '/jumps/analyze',
        data: formData,
        options: Options(
          headers: {
            'Content-Type': 'multipart/form-data',
          },
        ),
      );

      // Log the response for debugging
      print('API Response: ${response.data}');

      // Validate response data
      if (response.data == null) {
        throw VideoAnalysisException('Empty response from server');
      }

      // Parse the response into our model
      try {
        return VideoAnalysisResult.fromJson(
            response.data as Map<String, dynamic>);
      } catch (parseError) {
        print('JSON Parsing Error: $parseError');
        print('Response Data Type: ${response.data.runtimeType}');
        throw VideoAnalysisException(
            'Failed to parse server response: $parseError');
      }
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.sendTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        throw VideoAnalysisException(
          'Request timeout. Please check your internet connection and try again.',
        );
      } else if (e.response?.statusCode == 400) {
        throw VideoAnalysisException(
          'Invalid video format. Please ensure the video is properly recorded.',
        );
      } else if (e.response?.statusCode == 500) {
        throw VideoAnalysisException(
          'Server error during analysis. Please try again later.',
        );
      } else {
        throw VideoAnalysisException(
          'Failed to analyze video: ${e.message ?? 'Unknown error'}',
        );
      }
    } catch (e) {
      throw VideoAnalysisException(
        'Unexpected error during video analysis: ${e.toString()}',
      );
    }
  }

  /// Analyze other workout types (placeholder for future implementation)
  Future<VideoAnalysisResult> analyzeWorkoutVideo(
    File videoFile,
    String workoutType,
  ) async {
    switch (workoutType.toLowerCase()) {
      case 'jumps':
      case 'vertical jump':
      case 'jump':
        return analyzeJumpsVideo(videoFile);
      case 'squats':
      case 'sit-ups':
      case 'push-ups':
        // For now, all other workout types use the jumps endpoint
        // In future, these could have their own specific endpoints
        return analyzeJumpsVideo(videoFile);
      default:
        throw VideoAnalysisException(
          'Workout type "$workoutType" is not yet supported for analysis.',
        );
    }
  }
}

/// Custom exception for video analysis errors
class VideoAnalysisException implements Exception {
  final String message;

  VideoAnalysisException(this.message);

  @override
  String toString() => 'VideoAnalysisException: $message';
}
