import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'app.dart';
import 'src/ui/home/view_model/home_view_model.dart';
import 'src/providers/assessment_provider.dart';
import 'src/providers/notification_provider.dart';
import 'src/providers/leaderboard_provider.dart';
import 'src/providers/results_provider.dart';
import 'src/providers/user_provider.dart';
import 'src/providers/video_analysis_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => HomeViewModel()),
        ChangeNotifierProvider(create: (_) => AssessmentProvider()..load()),
        ChangeNotifierProvider(create: (_) => NotificationsProvider()..load()),
        ChangeNotifierProvider(create: (_) => LeaderboardProvider()..load()),
        ChangeNotifierProvider(create: (_) => ResultsProvider()..load()),
        ChangeNotifierProvider(create: (_) => UserProvider()..load()),
        ChangeNotifierProvider(create: (_) => VideoAnalysisProvider()),
      ],
      child: const MainApp(),
    ),
  );
}
