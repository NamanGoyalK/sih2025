import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class ResultsPage extends StatefulWidget {
  @override
  State<ResultsPage> createState() => _ResultsPageState();
}

class _ResultsPageState extends State<ResultsPage> {
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
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        shadowColor: Colors.grey,
        title: Text(
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
      body: CustomScrollView(
        physics: BouncingScrollPhysics(),
        slivers: [
          // Header container
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.only(top: 16.h, left: 16.w, right: 16.w),
              child: Container(
                height: 30.h,
                width: 80.w,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    GestureDetector(
                      
                      child: Text("Results"),
                      onTap: () {},
                    ),
                    VerticalDivider(
                      color: Colors.black,
                    ),
                    GestureDetector(
                      
                      child: Text("Graph"),
                      onTap: () {},
                    ),
                  ],
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(color: Colors.black),
                ),
              ),
            ),
          ),
          // Summary cards
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.only(top: 16.h, left: 16.w, right: 16.w),
              child: Wrap(
                spacing: 10.sp,
                runSpacing: 10.sp,
                children: summary.entries.map((e) {
                  return Container(
                    height: 140.h,
                    width: double.maxFinite,
                    padding: EdgeInsets.all(16.sp),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black12,
                            blurRadius: 6,
                            offset: Offset(0, 3))
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(e.key,
                            style: TextStyle(
                                fontSize: 18.sp, fontWeight: FontWeight.bold)),
                        SizedBox(height: 4),
                        Text(e.value.toString(),
                            style: TextStyle(color: Colors.grey[600])),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
          // 📈 Chart section
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(16.sp),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Compare Jumps by:',
                      style: TextStyle(
                          fontSize: 16.sp, fontWeight: FontWeight.bold)),
                  SizedBox(height: 8.h),
                  DropdownButton<String>(
                    value: selectedMetric,
                    items: [
                      "Jump Height (relative)",
                      "Jump Distance (relative)",
                      "Knee Angle at crouch",
                      "Flight Time (s)"
                    ]
                        .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                        .toList(),
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
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black12,
                            blurRadius: 6,
                            offset: Offset(0, 3))
                      ],
                    ),
                    padding: EdgeInsets.all(12.sp),
                    child: SfCartesianChart(
                      primaryXAxis: CategoryAxis(),
                      title: ChartTitle(text: '$selectedMetric across jumps'),
                      series: <LineSeries<Map<String, dynamic>, String>>[
                        LineSeries<Map<String, dynamic>, String>(
                          dataSource: jumps,
                          xValueMapper: (data, index) => 'Jump ${index + 1}',
                          yValueMapper: (data, _) =>
                              data[selectedMetric] as num,
                          markerSettings: MarkerSettings(isVisible: true),
                          dataLabelSettings: DataLabelSettings(isVisible: true),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Optional footer
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.only(
                  top: 0, bottom: 16.h, left: 16.w, right: 16.w),
              child: ElevatedButton(
                onPressed: () {},
                child: Text('Download Results'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
