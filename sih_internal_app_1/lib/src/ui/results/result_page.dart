import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:video_player/video_player.dart';
import 'package:go_router/go_router.dart';

class ResultsPage extends StatefulWidget {
  const ResultsPage({super.key});

  @override
  State<ResultsPage> createState() => _ResultsPageState();
}

class _ResultsPageState extends State<ResultsPage> {
  int selectedTab = 0; // 0: Results, 1: Graph, 2: Video
  late VideoPlayerController _videoController;
  bool _videoInitialized = false;

  final summary = {
    "total_jumps": 2,
    "best_jump_height": 0.152,
    "best_jump_distance": 0.019,
    "best_jump_flight_time": 1.26,
    "average_height": 0.084,
    "average_distance": 0.015,
    "average_knee_angle": 138.3,
    "average_flight_time": 0.69
  };

  final jumps = [
    {
      "Jump Height (relative)": 0.152,
      "Jump Distance (relative)": 0.019,
      "Knee Angle at crouch": 140.0,
      "Flight Time (s)": 1.26
    },
    {
      "Jump Height (relative)": 0.016,
      "Jump Distance (relative)": 0.011,
      "Knee Angle at crouch": 136.6,
      "Flight Time (s)": 0.11
    },
  ];

  String selectedMetric = "Jump Height (relative)";

  @override
  void initState() {
    super.initState();
    _videoController = VideoPlayerController.asset('assets/dummyvid1sih.mp4')
      ..initialize().then((_) {
        setState(() {
          _videoInitialized = true;
        });
      });
  }

  @override
  void dispose() {
    _videoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        shadowColor: Colors.grey,
        title: const Text(
          'Jump Test Results',
          style: TextStyle(
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          onPressed: () => context.go("/main"),
          icon: Icon(Icons.arrow_back_ios_new, size: 16.sp),
        ),
      ),
      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            // ===== Top Tabs =====
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.all(16.w),
                child: Container(
                  height: 40.h,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(color: Colors.black),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildTabButton("Results", 0),
                      const VerticalDivider(color: Colors.black),
                      _buildTabButton("Graph", 1),
                      const VerticalDivider(color: Colors.black),
                      _buildTabButton("Video", 2),
                    ],
                  ),
                ),
              ),
            ),
        
            // ===== Tab Content =====
            if (selectedTab == 0) _buildResultsView(),
            if (selectedTab == 1) _buildGraphView(),
            if (selectedTab == 2) _buildVideoView(),
        
            // ===== Footer =====
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.all(16.w),
                child: ElevatedButton(
                  onPressed: () {},
                  child: const Text('Download Results'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabButton(String title, int index) {
    return GestureDetector(
      onTap: () => setState(() => selectedTab = index),
      child: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: selectedTab == index ? Colors.blue : Colors.black,
        ),
      ),
    );
  }

  // ===== RESULTS TAB =====
  Widget _buildResultsView() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        child: Wrap(
          spacing: 10.sp,
          runSpacing: 10.sp,
          children: summary.entries.map((e) {
            return Container(
              width: double.infinity,
              padding: EdgeInsets.all(16.sp),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: const [
                  BoxShadow(
                      color: Colors.black12, blurRadius: 6, offset: Offset(0, 3))
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(e.key,
                      style: TextStyle(
                          fontSize: 18.sp, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text(e.value.toString(),
                      style: TextStyle(color: Colors.grey[600])),
                ],
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  // ===== GRAPH TAB =====
  Widget _buildGraphView() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: EdgeInsets.all(16.sp),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Compare Jumps by:',
                style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold)),
            SizedBox(height: 8.h),
            DropdownButton<String>(
              value: selectedMetric,
              items: [
                "Jump Height (relative)",
                "Jump Distance (relative)",
                "Knee Angle at crouch",
                "Flight Time (s)"
              ].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
              onChanged: (val) {
                setState(() => selectedMetric = val!);
              },
            ),
            SizedBox(height: 16.h),
            Container(
              height: 250.h,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: const [
                  BoxShadow(
                      color: Colors.black12, blurRadius: 6, offset: Offset(0, 3))
                ],
              ),
              padding: EdgeInsets.all(12.sp),
              child: SfCartesianChart(
                primaryXAxis: const CategoryAxis(),
                title: ChartTitle(text: '$selectedMetric across jumps'),
                series: <LineSeries<Map<String, dynamic>, String>>[
                  LineSeries<Map<String, dynamic>, String>(
                    dataSource: jumps,
                    xValueMapper: (data, index) => 'Jump ${index + 1}',
                    yValueMapper: (data, _) => data[selectedMetric] as num,
                    markerSettings: const MarkerSettings(isVisible: true),
                    dataLabelSettings: const DataLabelSettings(isVisible: true),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ===== VIDEO TAB =====
  Widget _buildVideoView() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: EdgeInsets.all(16.sp),
        child: Container(
          height: 250.h,
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(16),
            boxShadow: const [
              BoxShadow(
                  color: Colors.black12, blurRadius: 6, offset: Offset(0, 3))
            ],
          ),
          child: _videoInitialized
              ? AspectRatio(
                  aspectRatio: _videoController.value.aspectRatio,
                  child: Stack(
                    alignment: Alignment.bottomCenter,
                    children: [
                      VideoPlayer(_videoController),
                      VideoProgressIndicator(_videoController,
                          allowScrubbing: true),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: IconButton(
                          icon: Icon(
                            _videoController.value.isPlaying
                                ? Icons.pause
                                : Icons.play_arrow,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            setState(() {
                              if (_videoController.value.isPlaying) {
                                _videoController.pause();
                              } else {
                                _videoController.play();
                              }
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                )
              : const Center(child: CircularProgressIndicator()),
        ),
      ),
    );
  }
}
