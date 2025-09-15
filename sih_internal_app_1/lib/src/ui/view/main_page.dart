import 'package:flutter/material.dart';
import 'homepage.dart';
import 'leaderboard_page.dart';
import 'history_page.dart';
import 'profile_page.dart';
import 'notification_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _SportsMainPageState();
}

class _SportsMainPageState extends State<MainPage> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const HomePage(),
    const LeaderboardPage(),
    const HistoryPage(),
    const NotificationPage(),
    const ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: colorScheme.surface,
          boxShadow: [
            BoxShadow(
              color: colorScheme.shadow,
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) => setState(() => _currentIndex = index),
          backgroundColor: colorScheme.surface,
          selectedItemColor: colorScheme.primary,
          unselectedItemColor: colorScheme.onSurfaceVariant,
          type: BottomNavigationBarType.fixed,
          elevation: 0,
          selectedLabelStyle: theme.textTheme.labelSmall?.copyWith(
            fontWeight: FontWeight.w600,
          ),
          unselectedLabelStyle: theme.textTheme.labelSmall,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.leaderboard_outlined),
              activeIcon: Icon(Icons.leaderboard),
              label: 'Leaderboard',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.history_outlined),
              activeIcon: Icon(Icons.history),
              label: 'History',
            ),
          ],
        ),
      ),
    );
  }
}
