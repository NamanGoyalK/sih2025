import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

class AssessmentCategoriesPage extends StatefulWidget {
  const AssessmentCategoriesPage({super.key});

  @override
  State<AssessmentCategoriesPage> createState() =>
      _AssessmentCategoriesPageState();
}

class _AssessmentCategoriesPageState extends State<AssessmentCategoriesPage>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.0, 0.8, curve: Curves.easeOut),
    ));

    _slideAnimation = Tween<double>(
      begin: 50.0,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.2, 1.0, curve: Curves.easeOutCubic),
    ));

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // List of all assessment categories
    final categories = [
      {
        'title': 'Vertical Jump',
        'icon': Icons.arrow_upward_rounded,
        'color': const Color(0xFFFF6B6B),
        'subtitle': 'Power Test',
        'duration': '2 min',
        'description': 'Measure your explosive power and vertical leap ability',
        'isPopular': true,
      },
      {
        'title': 'Sprint Test',
        'icon': Icons.directions_run_rounded,
        'color': const Color(0xFF4ECDC4),
        'subtitle': 'Speed Test',
        'duration': '5 min',
        'description': 'Test your acceleration and maximum running speed',
        'isPopular': false,
      },
      {
        'title': 'Shuttle Run',
        'icon': Icons.swap_horiz_rounded,
        'color': const Color(0xFF9B59B6),
        'subtitle': 'Agility Test',
        'duration': '3 min',
        'description': 'Assess your change of direction and lateral movement',
        'isPopular': false,
      },
      {
        'title': 'Core Strength',
        'icon': Icons.fitness_center_rounded,
        'color': const Color(0xFFF39C12),
        'subtitle': 'Strength Test',
        'duration': '4 min',
        'description': 'Evaluate your abdominal and core muscle strength',
        'isPopular': false,
      },
      {
        'title': 'Balance Test',
        'icon': Icons.accessibility_new_rounded,
        'color': const Color(0xFF3498DB),
        'subtitle': 'Stability Test',
        'duration': '3 min',
        'description': 'Assess your balance and proprioception abilities',
        'isPopular': false,
      },
      {
        'title': 'Endurance Run',
        'icon': Icons.directions_walk_rounded,
        'color': const Color(0xFF2ECC71),
        'subtitle': 'Cardio Test',
        'duration': '10 min',
        'description': 'Test your cardiovascular endurance and stamina',
        'isPopular': false,
      },
      {
        'title': 'Flexibility Test',
        'icon': Icons.straighten_rounded,
        'color': const Color(0xFF9B59B6),
        'subtitle': 'Mobility Test',
        'duration': '5 min',
        'description': 'Measure your joint flexibility and range of motion',
        'isPopular': false,
      },
      {
        'title': 'Push-up Test',
        'icon': Icons.fitness_center_rounded,
        'color': const Color(0xFFE67E22),
        'subtitle': 'Upper Body',
        'duration': '3 min',
        'description': 'Evaluate your upper body strength and endurance',
        'isPopular': false,
      },
      {
        'title': 'Pull-up Test',
        'icon': Icons.sports_gymnastics_rounded,
        'color': const Color(0xFF34495E),
        'subtitle': 'Upper Body',
        'duration': '4 min',
        'description': 'Test your pulling strength and back muscle power',
        'isPopular': false,
      },
      {
        'title': 'Sit-up Test',
        'icon': Icons.sports_rounded,
        'color': const Color(0xFF16A085),
        'subtitle': 'Core Endurance',
        'duration': '2 min',
        'description': 'Measure your abdominal endurance and strength',
        'isPopular': false,
      },
      {
        'title': 'Plank Test',
        'icon': Icons.view_stream_rounded,
        'color': const Color(0xFF8E44AD),
        'subtitle': 'Core Stability',
        'duration': '5 min',
        'description': 'Assess your core stability and isometric strength',
        'isPopular': false,
      },
    ];

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // Enhanced Animated Header matching notification page style
          SliverAppBar(
            expandedHeight: 180,
            floating: false,
            pinned: true,
            stretch: true,
            automaticallyImplyLeading: false,
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
                      bottom: isCollapsed ? 16 : 80,
                    ),
                    title: AnimatedOpacity(
                      opacity: isCollapsed ? 1.0 : 0.0,
                      duration: const Duration(milliseconds: 200),
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              HapticFeedback.mediumImpact();
                              if (GoRouter.of(context).canPop()) {
                                context.pop();
                              }
                            },
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    colorScheme.onPrimary
                                        .withAlpha((0.2 * 255).toInt()),
                                    colorScheme.onPrimary
                                        .withAlpha((0.1 * 255).toInt()),
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: colorScheme.onPrimary
                                      .withAlpha((0.2 * 255).toInt()),
                                  width: 1,
                                ),
                              ),
                              child: Icon(
                                Icons.arrow_back,
                                color: colorScheme.onPrimary,
                                size: 20,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Flexible(
                            child: Text(
                              'Assessment Categories',
                              style: theme.textTheme.titleLarge?.copyWith(
                                color: colorScheme.onPrimary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    background: Stack(
                      children: [
                        // Decorative circles
                        Positioned(
                          top: -50,
                          right: -50,
                          child: Container(
                            width: 200,
                            height: 200,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: colorScheme.onPrimary
                                  .withAlpha((0.1 * 255).toInt()),
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: -30,
                          left: -30,
                          child: Container(
                            width: 150,
                            height: 150,
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
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            HapticFeedback.mediumImpact();
                                            if (GoRouter.of(context).canPop()) {
                                              context.pop();
                                            }
                                          },
                                          child: Container(
                                            padding: const EdgeInsets.all(8),
                                            decoration: BoxDecoration(
                                              gradient: LinearGradient(
                                                colors: [
                                                  colorScheme.onPrimary
                                                      .withAlpha(
                                                          (0.2 * 255).toInt()),
                                                  colorScheme.onPrimary
                                                      .withAlpha(
                                                          (0.1 * 255).toInt()),
                                                ],
                                                begin: Alignment.topLeft,
                                                end: Alignment.bottomRight,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              border: Border.all(
                                                color: colorScheme.onPrimary
                                                    .withAlpha(
                                                        (0.2 * 255).toInt()),
                                                width: 1,
                                              ),
                                            ),
                                            child: Icon(
                                              Icons.arrow_back,
                                              color: colorScheme.onPrimary,
                                              size: 20,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 16),
                                        FadeTransition(
                                          opacity: _fadeAnimation,
                                          child: Text(
                                            'Assessment Categories',
                                            style: theme.textTheme.titleLarge
                                                ?.copyWith(
                                              fontWeight: FontWeight.w600,
                                              color: colorScheme.onPrimary,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                const Spacer(),
                                FadeTransition(
                                  opacity: _fadeAnimation,
                                  child: Text(
                                    'Choose Your Test',
                                    style:
                                        theme.textTheme.titleMedium?.copyWith(
                                      fontWeight: FontWeight.w600,
                                      color: colorScheme.onPrimary
                                          .withAlpha((0.9 * 255).toInt()),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                FadeTransition(
                                  opacity: _fadeAnimation,
                                  child: Text(
                                    'Select from our comprehensive range of athletic assessments',
                                    style: theme.textTheme.bodyLarge?.copyWith(
                                      color: colorScheme.onPrimary
                                          .withAlpha((0.7 * 255).toInt()),
                                      height: 1.4,
                                    ),
                                  ),
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

          // Content
          SliverToBoxAdapter(
            child: AnimatedBuilder(
              animation: _animationController,
              builder: (context, child) {
                return FadeTransition(
                  opacity: _fadeAnimation,
                  child: Transform.translate(
                    offset: Offset(0, _slideAnimation.value),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Categories List
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: categories.length,
                            itemBuilder: (context, index) {
                              final category = categories[index];
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 16),
                                child: _buildCategoryCard(
                                  context,
                                  category['title'] as String,
                                  category['icon'] as IconData,
                                  category['color'] as Color,
                                  category['subtitle'] as String,
                                  category['duration'] as String,
                                  category['description'] as String,
                                  category['isPopular'] as bool,
                                ),
                              );
                            },
                          ),

                          const SizedBox(height: 100), // Bottom spacing
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryCard(
    BuildContext context,
    String title,
    IconData icon,
    Color color,
    String subtitle,
    String duration,
    String description,
    bool isPopular,
  ) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        // Navigate to workout recording page with the workout type
        context.go('/workout-recording/${Uri.encodeComponent(title)}');
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                theme.cardColor,
                theme.cardColor.withAlpha((0.95 * 255).toInt()),
              ],
            ),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: color.withAlpha((0.3 * 255).toInt()),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: color.withAlpha((0.15 * 255).toInt()),
                blurRadius: 12,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Row(
            children: [
              // Icon Container
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      color.withAlpha((0.2 * 255).toInt()),
                      color.withAlpha((0.1 * 255).toInt()),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: color.withAlpha((0.3 * 255).toInt()),
                  ),
                ),
                child: Icon(
                  icon,
                  color: color,
                  size: 32,
                ),
              ),

              const SizedBox(width: 16),

              // Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          title,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w800,
                            color: colorScheme.onSurface,
                          ),
                        ),
                        if (isPopular)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Colors.orange,
                                  Colors.orange.shade700,
                                ],
                              ),
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.orange
                                      .withAlpha((0.3 * 255).toInt()),
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Text(
                              'Popular',
                              style: theme.textTheme.labelSmall?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                                fontSize: 11,
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: color.withAlpha((0.1 * 255).toInt()),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            subtitle,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: color,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Icon(
                          Icons.timer_outlined,
                          size: 14,
                          color: colorScheme.onSurfaceVariant,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          duration,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const Spacer(),
                        Icon(
                          Icons.arrow_forward_rounded,
                          size: 20,
                          color: color,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
