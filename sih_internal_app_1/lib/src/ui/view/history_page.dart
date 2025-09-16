import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage>
    with TickerProviderStateMixin {
  late AnimationController _fadeAnimationController;
  late Animation<double> _fadeAnimation;
  late AnimationController _slideAnimationController;
  late Animation<double> _slideAnimation;
  late AnimationController _scaleAnimationController;
  late Animation<double> _scaleAnimation;

  Set<int> selectedFilter = {0};

  @override
  void initState() {
    super.initState();

    _fadeAnimationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _fadeAnimationController,
        curve: Curves.easeOut,
      ),
    );

    _slideAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _slideAnimation = Tween<double>(begin: 50.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _slideAnimationController,
        curve: Curves.easeOutCubic,
      ),
    );

    _scaleAnimationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: _scaleAnimationController,
        curve: Curves.elasticOut,
      ),
    );

    // Start animations
    _fadeAnimationController.forward();
    _slideAnimationController.forward();
    _scaleAnimationController.forward();
  }

  @override
  void dispose() {
    _fadeAnimationController.dispose();
    _slideAnimationController.dispose();
    _scaleAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // Enhanced Animated Header (keeping original)
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
                        'Assessment History',
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
                                              Icons.history_rounded,
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
                                                  'Assessment History',
                                                  style: theme
                                                      .textTheme.headlineSmall
                                                      ?.copyWith(
                                                    color:
                                                        colorScheme.onPrimary,
                                                    fontWeight: FontWeight.w800,
                                                    fontSize: 28,
                                                  ),
                                                ),
                                                Text(
                                                  'Track your athletic progress',
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
                                                Icons.assignment_rounded,
                                                color: colorScheme.onPrimary,
                                                size: 16,
                                              ),
                                              const SizedBox(width: 8),
                                              Text(
                                                '23 Total Assessments',
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
                const SizedBox(height: 16),

                // Compact Filter Tabs
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  width: double.infinity,
                  child: SegmentedButton<int>(
                    segments: const [
                      ButtonSegment<int>(
                        value: 0,
                        label: Text('7 Days'),
                        icon: Icon(Icons.today_rounded, size: 16),
                      ),
                      ButtonSegment<int>(
                        value: 1,
                        label: Text('30 Days'),
                        icon: Icon(Icons.date_range_rounded, size: 16),
                      ),
                      ButtonSegment<int>(
                        value: 2,
                        label: Text('All Time'),
                        icon: Icon(Icons.history_rounded, size: 16),
                      ),
                    ],
                    selected: selectedFilter,
                    onSelectionChanged: (Set<int> newSelection) {
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
                          vertical: 8, horizontal: 10),
                      textStyle: theme.textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // Compact Progress Stats
                AnimatedBuilder(
                  animation: _scaleAnimation,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: _scaleAnimation.value,
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 16),
                        decoration: BoxDecoration(
                          color: colorScheme.surfaceContainerHighest
                              .withAlpha(100),
                          border: Border.all(
                            color: colorScheme.outline,
                            width: 0.8,
                          ),
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: colorScheme.shadow
                                  .withAlpha((0.06 * 255).toInt()),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(18),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: colorScheme.primary
                                          .withAlpha((0.1 * 255).toInt()),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Icon(
                                      Icons.analytics_rounded,
                                      size: 20,
                                      color: colorScheme.primary,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Progress Overview',
                                          style: theme.textTheme.titleMedium
                                              ?.copyWith(
                                            fontWeight: FontWeight.w700,
                                            color: colorScheme.onSurface,
                                          ),
                                        ),
                                        Text(
                                          'Performance summary',
                                          style: theme.textTheme.bodySmall
                                              ?.copyWith(
                                            color: colorScheme.onSurfaceVariant,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              Row(
                                children: [
                                  Expanded(
                                    child: _buildCompactStatCard(
                                      context,
                                      'Tests',
                                      '23',
                                      Icons.assignment_rounded,
                                      Colors.blue,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: _buildCompactStatCard(
                                      context,
                                      'Best',
                                      '94',
                                      Icons.star_rounded,
                                      const Color.fromARGB(255, 129, 107, 40),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: _buildCompactStatCard(
                                      context,
                                      'Average',
                                      '78',
                                      Icons.trending_up_rounded,
                                      const Color.fromARGB(255, 57, 130, 60),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: _buildCompactStatCard(
                                      context,
                                      'Weekly',
                                      '4',
                                      Icons.calendar_today_rounded,
                                      const Color.fromARGB(255, 138, 47, 154),
                                    ),
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

                const SizedBox(height: 20),

                // Compact Recent Assessments
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
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
                                'Recent Assessments',
                                style: theme.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w700,
                                  color: colorScheme.onSurface,
                                ),
                              ),
                              Text(
                                'Latest test results',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: colorScheme.primary
                                  .withAlpha((0.1 * 255).toInt()),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.refresh_rounded,
                                  size: 12,
                                  color: colorScheme.primary,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  'Updated',
                                  style: theme.textTheme.labelSmall?.copyWith(
                                    color: colorScheme.primary,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      _buildCompactHistoryItem(
                        context,
                        'Vertical Jump Test',
                        '94',
                        'Today, 2:30 PM',
                        Icons.arrow_upward_rounded,
                        Colors.blue,
                        'Excellent',
                        true,
                      ),
                      _buildCompactHistoryItem(
                        context,
                        'Sprint Test',
                        '87',
                        'Yesterday, 4:15 PM',
                        Icons.directions_run_rounded,
                        Colors.green,
                        'Good',
                        false,
                      ),
                      _buildCompactHistoryItem(
                        context,
                        'Endurance Run',
                        '76',
                        '2 days ago',
                        Icons.timer_rounded,
                        Colors.pink,
                        'Average',
                        false,
                      ),
                      _buildCompactHistoryItem(
                        context,
                        'Sit-ups Test',
                        '89',
                        '3 days ago',
                        Icons.fitness_center_rounded,
                        Colors.orange,
                        'Good',
                        false,
                      ),
                      _buildCompactHistoryItem(
                        context,
                        'Shuttle Run',
                        '82',
                        '5 days ago',
                        Icons.swap_horiz_rounded,
                        Colors.deepPurple,
                        'Good',
                        false,
                      ),
                      _buildCompactHistoryItem(
                        context,
                        'BMI Analysis',
                        '91',
                        '1 week ago',
                        Icons.monitor_weight_rounded,
                        Colors.cyan,
                        'Excellent',
                        false,
                      ),
                      _buildCompactHistoryItem(
                        context,
                        'Vertical Jump Test',
                        '79',
                        '1 week ago',
                        Icons.arrow_upward_rounded,
                        Colors.blue,
                        'Good',
                        false,
                      ),
                      _buildCompactHistoryItem(
                        context,
                        'Sprint Test',
                        '73',
                        '2 weeks ago',
                        Icons.directions_run_rounded,
                        Colors.green,
                        'Average',
                        false,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 80),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCompactStatCard(
    BuildContext context,
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            color.withAlpha((0.08 * 255).toInt()),
            color.withAlpha((0.04 * 255).toInt()),
          ],
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withAlpha((0.2 * 255).toInt()),
          width: 0.8,
        ),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: color.withAlpha((0.15 * 255).toInt()),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: color,
              size: 16,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w800,
              color: colorScheme.onSurface,
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: theme.textTheme.labelSmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildCompactHistoryItem(
    BuildContext context,
    String testName,
    String score,
    String date,
    IconData icon,
    Color iconColor,
    String performance,
    bool isLatest,
  ) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(14),
        border: isLatest
            ? Border.all(color: colorScheme.primary, width: 0.8)
            : Border.all(
                color: colorScheme.outline.withAlpha((0.2 * 255).toInt())),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withAlpha((0.08 * 255).toInt()),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  iconColor.withAlpha((0.15 * 255).toInt()),
                  iconColor.withAlpha((0.08 * 255).toInt()),
                ],
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              icon,
              color: iconColor,
              size: 18,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        testName,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: colorScheme.onSurface,
                        ),
                      ),
                    ),
                    if (isLatest)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              colorScheme.primary,
                              colorScheme.primary
                                  .withAlpha((0.8 * 255).toInt()),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          'Latest',
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: colorScheme.onPrimary,
                            fontWeight: FontWeight.w600,
                            fontSize: 10,
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(
                      Icons.access_time_rounded,
                      size: 12,
                      color: colorScheme.onSurfaceVariant,
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        date,
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 4,
                        vertical: 1,
                      ),
                      decoration: BoxDecoration(
                        color: _getPerformanceColor(performance)
                            .withAlpha((0.12 * 255).toInt()),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        performance,
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: _getPerformanceColor(performance),
                          fontWeight: FontWeight.w600,
                          fontSize: 10,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                score,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                  color: colorScheme.primary,
                ),
              ),
              Icon(
                Icons.arrow_forward_ios_rounded,
                color:
                    colorScheme.onSurfaceVariant.withAlpha((0.6 * 255).toInt()),
                size: 12,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Color _getPerformanceColor(String performance) {
    switch (performance.toLowerCase()) {
      case 'excellent':
        return Colors.green;
      case 'good':
        return Colors.blue;
      case 'average':
        return Colors.orange;
      case 'poor':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}
