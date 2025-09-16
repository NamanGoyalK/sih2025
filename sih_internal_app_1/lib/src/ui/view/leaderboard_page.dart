import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class LeaderboardPage extends StatefulWidget {
  const LeaderboardPage({super.key});

  @override
  State<LeaderboardPage> createState() => _LeaderboardPageState();
}

class _LeaderboardPageState extends State<LeaderboardPage>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late AnimationController _staggerController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _slideAnimation;
  late Animation<double> _scaleAnimation;

  // Changed to Set<int> for SegmentedButton
  Set<int> selectedFilter = {0};
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _staggerController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
    ));

    _slideAnimation = Tween<double>(
      begin: 30.0,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.2, 0.8, curve: Curves.easeOutCubic),
    ));

    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _staggerController,
      curve: Curves.elasticOut,
    ));

    _animationController.forward();
    _staggerController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _staggerController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: CustomScrollView(
        controller: _scrollController,
        physics: const BouncingScrollPhysics(),
        slivers: [
          // Enhanced Animated Header
          SliverAppBar(
            expandedHeight: 180,
            floating: false,
            pinned: true,
            stretch: true,
            elevation: 0,
            backgroundColor: Colors.transparent,
            surfaceTintColor: Colors.transparent,
            flexibleSpace: LayoutBuilder(
              builder: (context, constraints) {
                final isCollapsed =
                    constraints.maxHeight <= kToolbarHeight + 50;
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        colorScheme.primary,
                        colorScheme.primary.withBlue(
                          ((((colorScheme.primary.b * 255.0).round() * 1.2)
                                  .round())
                              .clamp(0, 255)
                              .toInt()),
                        ),
                      ],
                    ),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(isCollapsed ? 0 : 32),
                      bottomRight: Radius.circular(isCollapsed ? 0 : 32),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color:
                            colorScheme.primary.withAlpha((0.3 * 255).toInt()),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: FlexibleSpaceBar(
                    titlePadding: EdgeInsets.only(
                      left: 24,
                      bottom: isCollapsed ? 16 : 60,
                    ),
                    title: AnimatedOpacity(
                      opacity: isCollapsed ? 1.0 : 0.0,
                      duration: const Duration(milliseconds: 200),
                      child: Text(
                        'Leaderboard',
                        style: theme.textTheme.titleLarge?.copyWith(
                          color: colorScheme.onPrimary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    background: Stack(
                      children: [
                        // Decorative elements
                        Positioned(
                          top: -30,
                          right: -30,
                          child: Container(
                            width: 120,
                            height: 120,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: colorScheme.onPrimary
                                  .withAlpha((0.1 * 255).toInt()),
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: -20,
                          left: -20,
                          child: Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: colorScheme.onPrimary
                                  .withAlpha((0.05 * 255).toInt()),
                            ),
                          ),
                        ),
                        SafeArea(
                          child: Padding(
                            padding: const EdgeInsets.all(24),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                AnimatedBuilder(
                                  animation: _fadeAnimation,
                                  builder: (context, child) {
                                    return FadeTransition(
                                      opacity: _fadeAnimation,
                                      child: Row(
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.all(12),
                                            decoration: BoxDecoration(
                                              color: colorScheme.onPrimary
                                                  .withAlpha(
                                                      (0.2 * 255).toInt()),
                                              borderRadius:
                                                  BorderRadius.circular(16),
                                            ),
                                            child: Icon(
                                              Icons.emoji_events_rounded,
                                              color: colorScheme.onPrimary,
                                              size: 28,
                                            ),
                                          ),
                                          const SizedBox(width: 16),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  'Leaderboard',
                                                  style: theme
                                                      .textTheme.headlineMedium
                                                      ?.copyWith(
                                                    color:
                                                        colorScheme.onPrimary,
                                                    fontWeight: FontWeight.w800,
                                                    fontSize: 28,
                                                  ),
                                                ),
                                                Text(
                                                  'Compete with athletes nationwide',
                                                  style: theme
                                                      .textTheme.bodyMedium
                                                      ?.copyWith(
                                                    color: colorScheme.onPrimary
                                                        .withAlpha((0.9 * 255)
                                                            .toInt()),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                                const Spacer(),
                                AnimatedBuilder(
                                  animation: _slideAnimation,
                                  builder: (context, child) {
                                    return Transform.translate(
                                      offset: Offset(0, _slideAnimation.value),
                                      child: FadeTransition(
                                        opacity: _fadeAnimation,
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 16,
                                            vertical: 8,
                                          ),
                                          decoration: BoxDecoration(
                                            color: colorScheme.onPrimary
                                                .withAlpha((0.2 * 255).toInt()),
                                            borderRadius:
                                                BorderRadius.circular(20),
                                          ),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Icon(
                                                Icons.people_rounded,
                                                color: colorScheme.onPrimary,
                                                size: 16,
                                              ),
                                              const SizedBox(width: 8),
                                              Text(
                                                '10L+ Athletes competing',
                                                style: theme.textTheme.bodySmall
                                                    ?.copyWith(
                                                  color: colorScheme.onPrimary,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          // Main Content
          SliverToBoxAdapter(
            child: Column(
              children: [
                const SizedBox(height: 24),

                // *** CHANGED: Replaced filter tabs with SegmentedButton ***
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  width: double.infinity,
                  child: SegmentedButton<int>(
                    segments: const [
                      ButtonSegment<int>(
                        value: 0,
                        label: Text('Overall'),
                        icon: Icon(Icons.public_rounded),
                      ),
                      ButtonSegment<int>(
                        value: 1,
                        label: Text('Week'),
                        icon: Icon(Icons.calendar_view_week_rounded),
                      ),
                      ButtonSegment<int>(
                        value: 2,
                        label: Text('Month'),
                        icon: Icon(Icons.calendar_month_rounded),
                      ),
                    ],
                    selected: selectedFilter,
                    onSelectionChanged: (Set<int> newSelection) {
                      // Ensure at least one button is always selected
                      if (newSelection.isNotEmpty) {
                        HapticFeedback.lightImpact();
                        setState(() {
                          selectedFilter = newSelection;
                        });
                      }
                    },
                    multiSelectionEnabled: false,
                    emptySelectionAllowed: false,
                    style: SegmentedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 12),
                      textStyle: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 32),

                // Enhanced Top 3 Podium
                AnimatedBuilder(
                  animation: _scaleAnimation,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: _scaleAnimation.value,
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 20),
                        decoration: BoxDecoration(
                          color: colorScheme.surfaceContainerHighest
                              .withAlpha(100),
                          border: Border.all(
                            color: colorScheme.outline,
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(24),
                          boxShadow: [
                            BoxShadow(
                              color: colorScheme.shadow
                                  .withAlpha((0.08 * 255).toInt()),
                              blurRadius: 16,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(24),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  const Icon(
                                    Icons.emoji_events_rounded,
                                    size: 28,
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Top Performers',
                                          style: theme.textTheme.titleLarge
                                              ?.copyWith(
                                            fontWeight: FontWeight.w800,
                                            color: colorScheme.onSurface,
                                          ),
                                        ),
                                        Text(
                                          'This week\'s champions',
                                          style: theme.textTheme.bodyMedium
                                              ?.copyWith(
                                            color: colorScheme.onSurfaceVariant,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 28),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  // 2nd Place
                                  // *** CHANGED: Updated call to new podium card ***
                                  _buildEnhancedPodiumCard(
                                    context,
                                    'Arjun K.',
                                    '2',
                                    '892 pts',
                                    const Color.fromARGB(255, 143, 140, 140),
                                  ),
                                  // 1st Place
                                  // *** CHANGED: Updated call to new podium card ***
                                  _buildEnhancedPodiumCard(
                                    context,
                                    'Priya S.',
                                    '1',
                                    '947 pts',
                                    const Color.fromARGB(255, 152, 129, 3),
                                    isFirst: true,
                                  ),
                                  // 3rd Place
                                  // *** CHANGED: Updated call to new podium card ***
                                  _buildEnhancedPodiumCard(
                                    context,
                                    'Rohit M.',
                                    '3',
                                    '856 pts',
                                    const Color(0xFFCD7F32),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),

                const SizedBox(height: 32),

                // Enhanced Your Rank Card
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        colorScheme.secondary.withAlpha((0.1 * 255).toInt()),
                        colorScheme.secondary.withAlpha((0.05 * 255).toInt()),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color:
                          colorScheme.secondary.withAlpha((0.3 * 255).toInt()),
                      width: 2,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Row(
                      children: [
                        Stack(
                          children: [
                            Container(
                              width: 60,
                              height: 60,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    colorScheme.secondary,
                                    colorScheme.secondary
                                        .withAlpha((0.8 * 255).toInt()),
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [
                                  BoxShadow(
                                    color: colorScheme.secondary
                                        .withAlpha((0.3 * 255).toInt()),
                                    blurRadius: 8,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Center(
                                child: Text(
                                  '#47',
                                  style: theme.textTheme.titleLarge?.copyWith(
                                    color: colorScheme.onSecondary,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              top: -4,
                              right: -4,
                              child: Container(
                                padding: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  color: Colors.green,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Icon(
                                  Icons.trending_up_rounded,
                                  color: Colors.white,
                                  size: 12,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(width: 20),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    'Your Rank',
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      color: colorScheme.onSurfaceVariant,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 2,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.green
                                          .withAlpha((0.2 * 255).toInt()),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      '+3',
                                      style:
                                          theme.textTheme.labelSmall?.copyWith(
                                        color: Colors.green,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Text(
                                'You (Naman Goyal)',
                                style: theme.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w800,
                                  color: colorScheme.onSurface,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              '634 pts',
                              style: theme.textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.w900,
                                color: colorScheme.secondary,
                              ),
                            ),
                            Text(
                              'Top 5%',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: colorScheme.onSurfaceVariant,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 32),

                // Enhanced Leaderboard List
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'All Rankings',
                                style: theme.textTheme.titleLarge?.copyWith(
                                  fontWeight: FontWeight.w800,
                                  color: colorScheme.onSurface,
                                  fontSize: 24,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Complete athlete rankings',
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: colorScheme.primary
                                  .withAlpha((0.1 * 255).toInt()),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.refresh_rounded,
                                  size: 16,
                                  color: colorScheme.primary,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  'Live',
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: colorScheme.primary,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      ...List.generate(
                        10,
                        (index) => _buildEnhancedLeaderboardItem(
                          context,
                          (index + 4).toString(),
                          _getRandomName(index),
                          _getRandomPoints(index),
                          _getRandomChange(index),
                          colorScheme,
                          theme,
                          index,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 100),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // *** REMOVED: _buildEnhancedFilterTab method is no longer needed ***

  // *** CHANGED: Rewrote podium card to be more minimal ***
  Widget _buildEnhancedPodiumCard(
    BuildContext context,
    String name,
    String rank,
    String points,
    Color color, {
    bool isFirst = false,
  }) {
    final theme = Theme.of(context);

    return Column(
      children: [
        Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.center,
          children: [
            // Profile picture placeholder
            CircleAvatar(
              radius: isFirst ? 40 : 35, // 1st place is bigger
              backgroundColor: color.withAlpha((0.2 * 255).toInt()),
              child: Text(
                name.split(' ').map((e) => e[0]).join(), // Initials
                style: theme.textTheme.titleLarge?.copyWith(
                    color: color,
                    fontWeight: FontWeight.w600,
                    fontSize: isFirst ? 24 : 20),
              ),
            ),
            // Rank badge
            Positioned(
              bottom: -5,
              right: isFirst ? -5 : -2,
              child: Container(
                padding: EdgeInsets.all(isFirst ? 8 : 6),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: color,
                  border: Border.all(
                      color: theme.colorScheme.surfaceContainerHighest,
                      width: 2),
                ),
                child: Text(
                  rank,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16), // Increased spacing to account for badge
        Text(
          name,
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w700,
            color: theme.colorScheme.onSurface,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 4),
        Text(
          points,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildEnhancedLeaderboardItem(
    BuildContext context,
    String rank,
    String name,
    String points,
    String change,
    ColorScheme colorScheme,
    ThemeData theme,
    int index,
  ) {
    final isPositiveChange = change.startsWith('+');
    final changeColor = isPositiveChange ? Colors.green : Colors.red;
    final changeIcon = isPositiveChange
        ? Icons.trending_up_rounded
        : Icons.trending_down_rounded;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            theme.cardColor,
            theme.cardColor.withAlpha((0.95 * 255).toInt()),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: colorScheme.outline.withAlpha((0.25 * 255).toInt()),
        ),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withAlpha((0.08 * 255).toInt()),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            // Rank container
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    colorScheme.primaryContainer,
                    colorScheme.primaryContainer.withAlpha((0.8 * 255).toInt()),
                  ],
                ),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: colorScheme.primary.withAlpha((0.3 * 255).toInt()),
                ),
              ),
              child: Center(
                child: Text(
                  rank,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w900,
                    color: colorScheme.onPrimaryContainer,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            // Avatar
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    colorScheme.secondary.withAlpha((0.3 * 255).toInt()),
                    colorScheme.secondary.withAlpha((0.1 * 255).toInt()),
                  ],
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Text(
                  name.split(' ').map((e) => e[0]).join(),
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: colorScheme.secondary,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            // Name and details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      Icon(
                        changeIcon,
                        size: 14,
                        color: changeColor,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        change,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: changeColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'vs last week',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Points
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  points,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w900,
                    color: colorScheme.primary,
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: colorScheme.primary.withAlpha((0.1 * 255).toInt()),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    'Active',
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: colorScheme.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
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

  String _getRandomChange(int index) {
    final changes = [
      '+2',
      '-1',
      '+5',
      '+3',
      '-2',
      '+1',
      '+4',
      '-3',
      '+6',
      '+2'
    ];
    return changes[index % changes.length];
  }
}
