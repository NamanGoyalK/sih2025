import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:camera/camera.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:video_player/video_player.dart';
import 'package:go_router/go_router.dart';

enum RecordingState {
  setup, // 10-second countdown setup
  recording, // Recording video
  preview, // Showing recorded video with submit/retake options
}

class WorkoutRecordingPage extends StatefulWidget {
  final String workoutType;

  const WorkoutRecordingPage({
    super.key,
    required this.workoutType,
  });

  @override
  State<WorkoutRecordingPage> createState() => _WorkoutRecordingPageState();
}

class _WorkoutRecordingPageState extends State<WorkoutRecordingPage>
    with TickerProviderStateMixin {
  // Controllers
  CameraController? _cameraController;
  VideoPlayerController? _videoPlayerController;
  late AnimationController _countdownAnimationController;
  late AnimationController _recordingAnimationController;
  late Animation<double> _countdownAnimation;
  late Animation<double> _pulseAnimation;

  // State variables
  RecordingState _currentState = RecordingState.setup;
  int _countdown = 10;
  Timer? _countdownTimer;
  String? _videoPath;
  bool _isRecording = false;
  bool _isInitialized = false;

  // Duration tracking
  final Stopwatch _recordingStopwatch = Stopwatch();
  Timer? _recordingTimer;
  String _recordingDuration = "00:00";

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _initializeCamera();
  }

  void _initializeAnimations() {
    _countdownAnimationController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );

    _recordingAnimationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    )..repeat(reverse: true);

    _countdownAnimation = Tween<double>(
      begin: 0.8,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _countdownAnimationController,
      curve: Curves.elasticOut,
    ));

    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.1,
    ).animate(CurvedAnimation(
      parent: _recordingAnimationController,
      curve: Curves.easeInOut,
    ));
  }

  Future<void> _initializeCamera() async {
    try {
      // Request camera and microphone permissions
      await [
        Permission.camera,
        Permission.microphone,
        Permission.storage,
      ].request();

      // Get available cameras
      final cameras = await availableCameras();
      if (cameras.isEmpty) {
        throw Exception('No cameras available');
      }

      // Initialize camera controller with front camera (for selfie-style recording)
      final frontCamera = cameras.firstWhere(
        (camera) => camera.lensDirection == CameraLensDirection.front,
        orElse: () => cameras.first,
      );

      _cameraController = CameraController(
        frontCamera,
        ResolutionPreset.high,
        enableAudio: true,
        imageFormatGroup: ImageFormatGroup.jpeg,
      );

      await _cameraController!.initialize();

      if (mounted) {
        setState(() {
          _isInitialized = true;
        });
        _startSetupCountdown();
      }
    } catch (e) {
      debugPrint('Error initializing camera: $e');
      if (mounted) {
        _showErrorDialog('Failed to initialize camera: $e');
      }
    }
  }

  void _startSetupCountdown() {
    _countdown = 10;
    setState(() {
      _currentState = RecordingState.setup;
    });

    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_countdown > 1) {
        setState(() {
          _countdown--;
        });
        _countdownAnimationController.forward().then((_) {
          _countdownAnimationController.reset();
        });
        HapticFeedback.lightImpact();
      } else {
        timer.cancel();
        _startRecording();
      }
    });
  }

  Future<void> _startRecording() async {
    if (!_isInitialized || _cameraController == null) return;

    try {
      setState(() {
        _currentState = RecordingState.recording;
        _isRecording = true;
      });

      // Get app documents directory
      final Directory appDir = await getApplicationDocumentsDirectory();
      final String videoPath =
          '${appDir.path}/workout_${DateTime.now().millisecondsSinceEpoch}.mp4';

      await _cameraController!.startVideoRecording();

      // Start recording timer
      _recordingStopwatch.start();
      _recordingTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (mounted) {
          setState(() {
            final seconds = _recordingStopwatch.elapsed.inSeconds;
            final minutes = seconds ~/ 60;
            final remainingSeconds = seconds % 60;
            _recordingDuration =
                '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
          });
        }
      });

      HapticFeedback.heavyImpact();
    } catch (e) {
      debugPrint('Error starting recording: $e');
      _showErrorDialog('Failed to start recording: $e');
    }
  }

  Future<void> _stopRecording() async {
    if (!_isRecording || _cameraController == null) return;

    try {
      final XFile videoFile = await _cameraController!.stopVideoRecording();
      _recordingStopwatch.stop();
      _recordingTimer?.cancel();

      setState(() {
        _isRecording = false;
        _videoPath = videoFile.path;
        _currentState = RecordingState.preview;
      });

      await _initializeVideoPlayer();
      HapticFeedback.mediumImpact();
    } catch (e) {
      debugPrint('Error stopping recording: $e');
      _showErrorDialog('Failed to stop recording: $e');
    }
  }

  Future<void> _initializeVideoPlayer() async {
    if (_videoPath == null) return;

    try {
      _videoPlayerController = VideoPlayerController.file(File(_videoPath!));
      await _videoPlayerController!.initialize();
      await _videoPlayerController!.setLooping(true);

      if (mounted) {
        setState(() {});
      }
    } catch (e) {
      debugPrint('Error initializing video player: $e');
    }
  }

  void _retakeVideo() {
    // Clean up video player
    _videoPlayerController?.dispose();
    _videoPlayerController = null;

    // Delete the recorded file
    if (_videoPath != null) {
      File(_videoPath!).deleteSync();
    }

    // Reset state
    setState(() {
      _videoPath = null;
      _recordingStopwatch.reset();
      _recordingDuration = "00:00";
    });

    // Start setup countdown again
    _startSetupCountdown();
  }

  void _submitVideo() {
    // Show loading dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );

    // Simulate AI assessment processing
    Timer(const Duration(seconds: 3), () {
      Navigator.of(context).pop(); // Close loading dialog
      context.go('/results'); // Navigate to results page
    });
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              context.go('/main');
            },
            child: const Text('Go Back'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _countdownTimer?.cancel();
    _recordingTimer?.cancel();
    _cameraController?.dispose();
    _videoPlayerController?.dispose();
    _countdownAnimationController.dispose();
    _recordingAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => context.go('/main'),
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    widget.workoutType,
                    style: theme.textTheme.titleLarge?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  if (_currentState == RecordingState.recording)
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          AnimatedBuilder(
                            animation: _pulseAnimation,
                            builder: (context, child) {
                              return Transform.scale(
                                scale: _pulseAnimation.value,
                                child: Container(
                                  width: 8,
                                  height: 8,
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              );
                            },
                          ),
                          const SizedBox(width: 8),
                          Text(
                            _recordingDuration,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),

            // Main Content Area
            Expanded(
              child: _buildMainContent(theme, colorScheme),
            ),

            // Bottom Controls
            _buildBottomControls(theme, colorScheme),
          ],
        ),
      ),
    );
  }

  Widget _buildMainContent(ThemeData theme, ColorScheme colorScheme) {
    switch (_currentState) {
      case RecordingState.setup:
        return _buildSetupUI(theme, colorScheme);
      case RecordingState.recording:
        return _buildRecordingUI();
      case RecordingState.preview:
        return _buildPreviewUI(theme, colorScheme);
    }
  }

  Widget _buildSetupUI(ThemeData theme, ColorScheme colorScheme) {
    return Column(
      children: [
        // Camera Preview
        Expanded(
          child: Container(
            margin: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.white24, width: 2),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: _isInitialized && _cameraController != null
                  ? CameraPreview(_cameraController!)
                  : const Center(
                      child: CircularProgressIndicator(color: Colors.white),
                    ),
            ),
          ),
        ),

        // Setup Instructions and Countdown
        Container(
          margin: const EdgeInsets.all(16),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white24),
          ),
          child: Column(
            children: [
              const Icon(
                Icons.fitness_center,
                color: Colors.white,
                size: 32,
              ),
              const SizedBox(height: 12),
              Text(
                'Get Ready for ${widget.workoutType}',
                style: theme.textTheme.titleLarge?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'Position yourself in the frame and prepare for the assessment',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: Colors.white70,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              AnimatedBuilder(
                animation: _countdownAnimation,
                builder: (context, child) {
                  return Transform.scale(
                    scale: _countdownAnimation.value,
                    child: Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: colorScheme.primary,
                        border: Border.all(color: Colors.white, width: 3),
                      ),
                      child: Center(
                        child: Text(
                          '$_countdown',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildRecordingUI() {
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.red, width: 3),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(13),
        child: _isInitialized && _cameraController != null
            ? CameraPreview(_cameraController!)
            : const Center(
                child: CircularProgressIndicator(color: Colors.white),
              ),
      ),
    );
  }

  Widget _buildPreviewUI(ThemeData theme, ColorScheme colorScheme) {
    if (_videoPlayerController == null ||
        !_videoPlayerController!.value.isInitialized) {
      return const Center(
        child: CircularProgressIndicator(color: Colors.white),
      );
    }

    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white24, width: 2),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(14),
        child: AspectRatio(
          aspectRatio: _videoPlayerController!.value.aspectRatio,
          child: Stack(
            children: [
              VideoPlayer(_videoPlayerController!),
              Center(
                child: IconButton(
                  onPressed: () {
                    setState(() {
                      if (_videoPlayerController!.value.isPlaying) {
                        _videoPlayerController!.pause();
                      } else {
                        _videoPlayerController!.play();
                      }
                    });
                  },
                  icon: Icon(
                    _videoPlayerController!.value.isPlaying
                        ? Icons.pause_circle_filled
                        : Icons.play_circle_filled,
                    color: Colors.white,
                    size: 60,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBottomControls(ThemeData theme, ColorScheme colorScheme) {
    if (_currentState == RecordingState.setup) {
      return const SizedBox.shrink(); // No controls during setup
    }

    if (_currentState == RecordingState.recording) {
      return Padding(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: GestureDetector(
            onTap: _stopRecording,
            child: AnimatedBuilder(
              animation: _pulseAnimation,
              builder: (context, child) {
                return Transform.scale(
                  scale: _pulseAnimation.value,
                  child: Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.red,
                      border: Border.all(color: Colors.white, width: 4),
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.stop,
                        color: Colors.white,
                        size: 32,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      );
    }

    // Preview controls
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton.icon(
              onPressed: _retakeVideo,
              icon: const Icon(Icons.refresh),
              label: const Text('Retake'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey[800],
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: ElevatedButton.icon(
              onPressed: _submitVideo,
              icon: const Icon(Icons.send),
              label: const Text('Submit for AI Assessment'),
              style: ElevatedButton.styleFrom(
                backgroundColor: colorScheme.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
