import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sih_internal_app_1/src/ui/view/main_page.dart';

final router = GoRouter(
    initialLocation: '/',
    // redirect will be defined for umm login stuff
    routes: [
      GoRoute(
        path: '/',
        pageBuilder: (context, state) => const MaterialPage(child: MainPage()),
      )
    ]);
