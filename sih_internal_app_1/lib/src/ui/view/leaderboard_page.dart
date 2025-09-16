import 'package:flutter/material.dart';

class LeaderboardPage extends StatelessWidget {
  const LeaderboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Section
          Container(
            padding: const EdgeInsets.fromLTRB(20, 40, 20, 20),
            decoration: BoxDecoration(
              color: colorScheme.primary,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.leaderboard,
                      color: colorScheme.onPrimary,
                      size: 28,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'Leaderboard',
                      style: theme.textTheme.headlineSmall?.copyWith(
                        color: colorScheme.onPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  'See where you rank among all athletes',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onPrimary.withAlpha((0.8 * 255).toInt()),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Filter Tabs
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Expanded(
                  child: _buildFilterTab(
                    context,
                    'Overall',
                    true,
                    colorScheme,
                    theme,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildFilterTab(
                    context,
                    'This Week',
                    false,
                    colorScheme,
                    theme,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildFilterTab(
                    context,
                    'This Month',
                    false,
                    colorScheme,
                    theme,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Top 3 Podium
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                Text(
                  'Top Performers',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onPrimaryContainer,
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // 2nd Place
                    _buildPodiumCard(
                      context,
                      'Arjun K.',
                      '2',
                      '892 pts',
                      Colors.grey,
                      Icons.emoji_events,
                    ),
                    // 1st Place
                    _buildPodiumCard(
                      context,
                      'Priya S.',
                      '1',
                      '947 pts',
                      Colors.amber,
                      Icons.emoji_events,
                    ),
                    // 3rd Place
                    _buildPodiumCard(
                      context,
                      'Rohit M.',
                      '3',
                      '856 pts',
                      Colors.brown,
                      Icons.emoji_events,
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Your Rank Card
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: colorScheme.secondary,
                width: 2,
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: colorScheme.secondary,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '47',
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: colorScheme.onSecondary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Your Rank',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSecondaryContainer,
                        ),
                      ),
                      Text(
                        'You (Athlete)',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: colorScheme.onSecondaryContainer,
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  '634 pts',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colorScheme.secondary,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Leaderboard List
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'All Rankings',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 16),
                ...List.generate(
                  10,
                  (index) => _buildLeaderboardItem(
                    context,
                    (index + 4).toString(),
                    _getRandomName(index),
                    _getRandomPoints(index),
                    colorScheme,
                    theme,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 100),
        ],
      ),
    );
  }

  Widget _buildFilterTab(
    BuildContext context,
    String title,
    bool isSelected,
    ColorScheme colorScheme,
    ThemeData theme,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: isSelected ? colorScheme.primary : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isSelected ? colorScheme.primary : colorScheme.outline,
        ),
      ),
      child: Text(
        title,
        style: theme.textTheme.bodyMedium?.copyWith(
          color: isSelected ? colorScheme.onPrimary : colorScheme.onSurface,
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildPodiumCard(
    BuildContext context,
    String name,
    String rank,
    String points,
    Color color,
    IconData icon,
  ) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: color.withAlpha((0.2 * 255).toInt()),
            borderRadius: BorderRadius.circular(50),
          ),
          child: Icon(
            icon,
            color: color,
            size: 32,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            rank,
            style: theme.textTheme.titleSmall?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          name,
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: colorScheme.onPrimaryContainer,
          ),
        ),
        Text(
          points,
          style: theme.textTheme.bodySmall?.copyWith(
            color:
                colorScheme.onPrimaryContainer.withAlpha((0.8 * 255).toInt()),
          ),
        ),
      ],
    );
  }

  Widget _buildLeaderboardItem(
    BuildContext context,
    String rank,
    String name,
    String points,
    ColorScheme colorScheme,
    ThemeData theme,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.cardTheme.color ?? colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withAlpha((0.1 * 255).toInt()),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Text(
                rank,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onPrimaryContainer,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              name,
              style: theme.textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.w600,
                color: colorScheme.onSurface,
              ),
            ),
          ),
          Text(
            points,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: colorScheme.primary,
            ),
          ),
        ],
      ),
    );
  }

  String _getRandomName(int index) {
    final names = [
      'Aarav P.',
      'Diya K.',
      'Vihaan S.',
      'Ananya R.',
      'Reyansh M.',
      'Kavya T.',
      'Arjun G.',
      'Ira L.',
      'Vivaan J.',
      'Saanvi N.',
    ];
    return names[index % names.length];
  }

  String _getRandomPoints(int index) {
    final basePoints = 830 - (index * 15);
    return '$basePoints pts';
  }
}
