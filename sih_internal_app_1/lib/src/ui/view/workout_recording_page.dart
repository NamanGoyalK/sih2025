import 'dart:async';
import 'dart:io';
import 'dart:math' as math;
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
  // Camera switching
  List<CameraDescription> _availableCameras = [];
  bool _useFrontCamera = true;

  // Preview UI controls visibility
  bool _showVideoControls = true;
  Timer? _videoControlsHideTimer;

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

    // Use the countdown animation controller to drive a tumbling hourglass rotation
    _countdownAnimation = Tween<double>(
      begin: 0.0,
      end: math.pi, // 180° flip each tick
    ).animate(CurvedAnimation(
      parent: _countdownAnimationController,
      curve: Curves.easeInOutCubic,
    ));

    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.1,
    ).animate(CurvedAnimation(
      parent: _recordingAnimationController,
      curve: Curves.easeInOut,
    ));
  }

  void _scheduleHideVideoControls() {
    _videoControlsHideTimer?.cancel();
    _videoControlsHideTimer = Timer(const Duration(seconds: 2), () {
      if (!mounted) return;
      if (_videoPlayerController?.value.isPlaying == true) {
        setState(() => _showVideoControls = false);
      }
    });
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
      _availableCameras = cameras;

      // Pick desired camera (front by default)
      CameraDescription selectedCamera;
      if (_useFrontCamera) {
        selectedCamera = cameras.firstWhere(
          (c) => c.lensDirection == CameraLensDirection.front,
          orElse: () => cameras.first,
        );
      } else {
        selectedCamera = cameras.firstWhere(
          (c) => c.lensDirection == CameraLensDirection.back,
          orElse: () => cameras.first,
        );
      }

      _cameraController = CameraController(
        selectedCamera,
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

  Future<void> _switchCamera() async {
    if (_currentState == RecordingState.recording) {
      // Not allowing switch mid-recording to avoid interrupting capture
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Stop recording to switch camera')),
      );
      return;
    }

    try {
      if (_availableCameras.isEmpty) {
        _availableCameras = await availableCameras();
      }

      final targetLens = _useFrontCamera
          ? CameraLensDirection.back
          : CameraLensDirection.front;
      final nextCamera = _availableCameras.firstWhere(
        (c) => c.lensDirection == targetLens,
        orElse: () => _availableCameras.first,
      );

      setState(() => _isInitialized = false);
      await _cameraController?.dispose();

      _cameraController = CameraController(
        nextCamera,
        ResolutionPreset.high,
        enableAudio: true,
        imageFormatGroup: ImageFormatGroup.jpeg,
      );
      await _cameraController!.initialize();

      if (!mounted) return;
      setState(() {
        _useFrontCamera = nextCamera.lensDirection == CameraLensDirection.front;
        _isInitialized = true;
      });

      HapticFeedback.selectionClick();
    } catch (e) {
      debugPrint('Error switching camera: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to switch camera: $e')),
        );
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

      await getApplicationDocumentsDirectory();

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

      // Show controls initially in preview
      _showVideoControls = true;
      _videoControlsHideTimer?.cancel();

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
    _videoControlsHideTimer?.cancel();
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
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        shadowColor: Colors.grey,
        title: Text(
          'Record ${widget.workoutType}',
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
        leading: IconButton(
          onPressed: () => context.go('/main'),
          icon: const Icon(Icons.arrow_back_ios_new, size: 18),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Main Content Area
            Expanded(
              child: _buildMainContent(theme, colorScheme),
            ),

            // Bottom Controls
            _buildBottomControls(theme, colorScheme),

            const SizedBox(height: 16),
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
        // Camera Preview Card
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: colorScheme.outlineVariant, width: 1),
                boxShadow: const [
                  BoxShadow(
                      color: Colors.black12,
                      blurRadius: 10,
                      offset: Offset(0, 6)),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: _isInitialized && _cameraController != null
                    ? Stack(
                        children: [
                          CameraPreview(_cameraController!),
                          Positioned(
                            top: 12,
                            right: 12,
                            child: IconButton.filledTonal(
                              onPressed: _switchCamera,
                              icon: const Icon(Icons.cameraswitch_rounded),
                              tooltip: 'Switch camera',
                            ),
                          ),
                        ],
                      )
                    : const Center(child: CircularProgressIndicator()),
              ),
            ),
          ),
        ),

        // Setup Instructions and Countdown Card
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: colorScheme.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: colorScheme.outlineVariant),
              boxShadow: const [
                BoxShadow(
                    color: Colors.black12, blurRadius: 8, offset: Offset(0, 4)),
              ],
            ),
            child: Column(
              children: [
                Icon(Icons.fitness_center,
                    color: colorScheme.primary, size: 28),
                const SizedBox(height: 12),
                Text(
                  'Get Ready for ${widget.workoutType}',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 6),
                Text(
                  'Position yourself in the frame and prepare for the assessment',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                AnimatedBuilder(
                  animation: _countdownAnimationController,
                  builder: (context, child) {
                    final iconData = _countdownAnimationController.value < 0.5
                        ? Icons.hourglass_top
                        : Icons.hourglass_bottom;
                    return Column(
                      children: [
                        Transform.rotate(
                          angle: _countdownAnimation.value,
                          child: Container(
                            width: 84,
                            height: 84,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: colorScheme.primary,
                              border: Border.all(
                                color: colorScheme.onPrimary,
                                width: 3,
                              ),
                              boxShadow: const [
                                BoxShadow(
                                  color: Colors.black26,
                                  blurRadius: 8,
                                  offset: Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Center(
                              child: Icon(
                                iconData,
                                color: Colors.white,
                                size: 44,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          '$_countdown',
                          style: const TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    );
                  },
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _onReadyPressed,
                  child: const Text("I'm Ready - Start Now"),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _onReadyPressed() {
    _countdownTimer?.cancel();
    _startRecording();
  }

  Widget _buildRecordingUI() {
    final colorScheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: colorScheme.primary, width: 2),
          boxShadow: const [
            BoxShadow(
                color: Colors.black12, blurRadius: 10, offset: Offset(0, 6)),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(18),
          child: _isInitialized && _cameraController != null
              ? Stack(
                  children: [
                    // Use Positioned.fill to ensure the camera preview fills the entire container
                    Positioned.fill(
                      child: FittedBox(
                        fit: BoxFit
                            .cover, // This will crop the video to fill the container
                        child: SizedBox(
                          width: _cameraController!.value.previewSize!.height,
                          height: _cameraController!.value.previewSize!.width,
                          child: CameraPreview(_cameraController!),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 12,
                      right: 12,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.black54,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Colors.white24),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
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
                                      color: Colors.red,
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
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                )
              : const Center(child: CircularProgressIndicator()),
        ),
      ),
    );
  }

  Widget _buildPreviewUI(ThemeData theme, ColorScheme colorScheme) {
    if (_videoPlayerController == null ||
        !_videoPlayerController!.value.isInitialized) {
      return const Center(child: CircularProgressIndicator());
    }

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: colorScheme.outlineVariant, width: 1),
          boxShadow: const [
            BoxShadow(
                color: Colors.black12, blurRadius: 10, offset: Offset(0, 6)),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: AspectRatio(
            aspectRatio: _videoPlayerController!.value.aspectRatio,
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                setState(() => _showVideoControls = !_showVideoControls);
                if (_videoPlayerController!.value.isPlaying &&
                    _showVideoControls) {
                  _scheduleHideVideoControls();
                }
              },
              child: Stack(
                children: [
                  VideoPlayer(_videoPlayerController!),
                  // Subtle top/bottom gradient for readability of controls
                  Positioned.fill(
                    child: IgnorePointer(
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.black.withOpacity(0.10),
                              Colors.transparent,
                              Colors.black.withOpacity(0.15),
                            ],
                            stops: const [0.0, 0.5, 1.0],
                          ),
                        ),
                      ),
                    ),
                  ),
                  // Center play/pause that auto-hides while playing
                  Center(
                    child: AnimatedOpacity(
                      duration: const Duration(milliseconds: 200),
                      opacity: (_showVideoControls ||
                              !_videoPlayerController!.value.isPlaying)
                          ? 1
                          : 0,
                      child: Container(
                        decoration: const BoxDecoration(
                          color: Colors.black45,
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                          onPressed: () {
                            setState(() {
                              if (_videoPlayerController!.value.isPlaying) {
                                _videoPlayerController!.pause();
                                _showVideoControls = true;
                                _videoControlsHideTimer?.cancel();
                              } else {
                                _videoPlayerController!.play();
                                _showVideoControls = true;
                                _scheduleHideVideoControls();
                              }
                            });
                          },
                          icon: Icon(
                            _videoPlayerController!.value.isPlaying
                                ? Icons.pause
                                : Icons.play_arrow,
                            color: Colors.white,
                            size: 56,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBottomControls(ThemeData theme, ColorScheme colorScheme) {
    if (_currentState == RecordingState.setup) {
      return const SizedBox.shrink();
    }

    if (_currentState == RecordingState.recording) {
      return Padding(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: ElevatedButton.icon(
            onPressed: _stopRecording,
            icon: const Icon(Icons.stop_rounded),
            label: const Text('Stop'),
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
            child: OutlinedButton.icon(
              onPressed: _retakeVideo,
              icon: const Icon(Icons.refresh),
              label: const Text('Retake'),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: ElevatedButton.icon(
              onPressed: _submitVideo,
              icon: const Icon(Icons.send),
              label: const Text('Submit'),
            ),
          ),
        ],
      ),
    );
  }
}
