import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sih_internal_app_1/src/ui/onboarding/login/login_page.dart';
import 'package:sih_internal_app_1/src/ui/onboarding/register/register_page.dart';
import 'package:sih_internal_app_1/src/ui/results/result_page.dart';
import 'package:sih_internal_app_1/src/ui/view/main_page.dart';
import 'package:sih_internal_app_1/src/ui/view/workout_recording_page.dart';
import 'package:sih_internal_app_1/src/ui/view/assessment_categories_page.dart';

final router = GoRouter(
    initialLocation: '/',
    // redirect will be defined for umm login stuff
    routes: [
      GoRoute(
        path: '/',
        pageBuilder: (context, state) => const MaterialPage(child: LoginPage()),
      ),
      GoRoute(
        path: '/login',
        pageBuilder: (context, state) => const MaterialPage(child: LoginPage()),
      ),
      GoRoute(
        path: '/register',
        pageBuilder: (context, state) =>
            const MaterialPage(child: RegisterPage()),
      ),
      GoRoute(
        path: '/main',
        pageBuilder: (context, state) => const MaterialPage(child: MainPage()),
      ),
      GoRoute(
        path: '/results',
        pageBuilder: (context, state) =>
            const MaterialPage(child: ResultsPage()),
      ),
      GoRoute(
        path: '/workout-recording/:workoutType',
        pageBuilder: (context, state) {
          final workoutType = state.pathParameters['workoutType'] ?? 'Unknown';
          return MaterialPage(
            child: WorkoutRecordingPage(workoutType: workoutType),
          );
        },
      ),
      GoRoute(
        path: '/assessment-categories',
        pageBuilder: (context, state) =>
            const MaterialPage(child: AssessmentCategoriesPage()),
      ),
    ]);
