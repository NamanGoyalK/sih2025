// filepath: lib/src/ui/view/video_analysis_results_page.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:sih_internal_app_1/src/models/video_analysis_result.dart';
import 'package:sih_internal_app_1/src/providers/video_analysis_provider.dart';

class VideoAnalysisResultsPage extends StatefulWidget {
  const VideoAnalysisResultsPage({super.key});

  @override
  State<VideoAnalysisResultsPage> createState() =>
      _VideoAnalysisResultsPageState();
}

class _VideoAnalysisResultsPageState extends State<VideoAnalysisResultsPage>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  int selectedTab = 0; // 0: Summary, 1: Reps, 2: Chart

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
  }

  void _initializeAnimations() {
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _slideController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeOut,
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOutCubic,
    ));

    _fadeController.forward();
    _slideController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final provider = context.watch<VideoAnalysisProvider>();
    final result = provider.result;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        title: Text(
          'Analysis Results',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          onPressed: () => context.go('/main'),
          icon: const Icon(Icons.arrow_back_ios_new, size: 18),
        ),
        elevation: 0,
        backgroundColor: colorScheme.surface,
      ),
      body: provider.isAnalyzing
          ? _buildLoadingState(theme, colorScheme, provider)
          : provider.error != null
              ? _buildErrorState(theme, colorScheme, provider.error!)
              : result == null
                  ? _buildEmptyState(theme, colorScheme)
                  : FadeTransition(
                      opacity: _fadeAnimation,
                      child: SlideTransition(
                        position: _slideAnimation,
                        child: Column(
                          children: [
                            _buildTabSelector(theme, colorScheme),
                            Expanded(
                              child:
                                  _buildTabContent(theme, colorScheme, result),
                            ),
                          ],
                        ),
                      ),
                    ),
    );
  }

  Widget _buildEmptyState(ThemeData theme, ColorScheme colorScheme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.analytics_outlined,
            size: 64,
            color: colorScheme.onSurfaceVariant,
          ),
          const SizedBox(height: 16),
          Text(
            'No Analysis Available',
            style: theme.textTheme.headlineSmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Record a workout to see your analysis results',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () => context.go('/main'),
            child: const Text('Go to Home'),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingState(
    ThemeData theme,
    ColorScheme colorScheme,
    VideoAnalysisProvider provider,
  ) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(),
          const SizedBox(height: 24),
          Text(
            'Analyzing Video...',
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'This may take a few moments',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: 200,
            child: LinearProgressIndicator(
              value: provider.uploadProgress,
              backgroundColor: colorScheme.surfaceContainerHighest,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '${(provider.uploadProgress * 100).toInt()}%',
            style: theme.textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(
      ThemeData theme, ColorScheme colorScheme, String error) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.red,
            ),
            const SizedBox(height: 16),
            Text(
              'Analysis Failed',
              style: theme.textTheme.headlineSmall?.copyWith(
                color: Colors.red,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              error,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                OutlinedButton(
                  onPressed: () => context.go('/main'),
                  child: const Text('Go to Home'),
                ),
                const SizedBox(width: 16),
                ElevatedButton(
                  onPressed: () {
                    final provider = context.read<VideoAnalysisProvider>();
                    provider.clearResult();
                    context.go('/main');
                  },
                  child: const Text('Try Again'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabSelector(ThemeData theme, ColorScheme colorScheme) {
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colorScheme.outline.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          _buildTabButton('Summary', 0, theme, colorScheme),
          _buildTabButton('Reps', 1, theme, colorScheme),
          _buildTabButton('Chart', 2, theme, colorScheme),
        ],
      ),
    );
  }

  Widget _buildTabButton(
    String label,
    int index,
    ThemeData theme,
    ColorScheme colorScheme,
  ) {
    final isSelected = selectedTab == index;

    return Expanded(
      child: GestureDetector(
        onTap: () {
          HapticFeedback.lightImpact();
          setState(() => selectedTab = index);
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? colorScheme.primary : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            label,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: isSelected
                  ? colorScheme.onPrimary
                  : colorScheme.onSurfaceVariant,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }

  Widget _buildTabContent(
    ThemeData theme,
    ColorScheme colorScheme,
    VideoAnalysisResult result,
  ) {
    switch (selectedTab) {
      case 0:
        return _buildSummaryTab(theme, colorScheme, result);
      case 1:
        return _buildRepsTab(theme, colorScheme, result);
      case 2:
        return _buildChartTab(theme, colorScheme, result);
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildSummaryTab(
    ThemeData theme,
    ColorScheme colorScheme,
    VideoAnalysisResult result,
  ) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSummaryCard(theme, colorScheme, result.summary),
          const SizedBox(height: 20),
          _buildPerformanceMetrics(theme, colorScheme, result.summary),
          const SizedBox(height: 20),
          _buildDownloadSection(theme, colorScheme, result),
        ],
      ),
    );
  }

  Widget _buildSummaryCard(
    ThemeData theme,
    ColorScheme colorScheme,
    VideoAnalysisSummary summary,
  ) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            colorScheme.primaryContainer,
            colorScheme.primaryContainer.withOpacity(0.8),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colorScheme.outline.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.analytics_rounded,
                color: colorScheme.primary,
                size: 28,
              ),
              const SizedBox(width: 12),
              Text(
                'Analysis Summary',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: colorScheme.onPrimaryContainer,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: _buildSummaryItem(
                  theme,
                  colorScheme,
                  'Total Reps',
                  summary.totalReps.toString(),
                  Icons.fitness_center,
                ),
              ),
              Container(
                width: 1,
                height: 40,
                color: colorScheme.outline.withOpacity(0.3),
              ),
              Expanded(
                child: _buildSummaryItem(
                  theme,
                  colorScheme,
                  'Duration',
                  '${summary.durationSec.toStringAsFixed(1)}s',
                  Icons.timer,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryItem(
    ThemeData theme,
    ColorScheme colorScheme,
    String label,
    String value,
    IconData icon,
  ) {
    return Column(
      children: [
        Icon(
          icon,
          color: colorScheme.primary,
          size: 24,
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w900,
            color: colorScheme.primary,
          ),
        ),
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            color: colorScheme.onPrimaryContainer,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildPerformanceMetrics(
    ThemeData theme,
    ColorScheme colorScheme,
    VideoAnalysisSummary summary,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Performance Metrics',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 12),
        _buildMetricCard(
          theme,
          colorScheme,
          'Average Angle',
          '${summary.averageAngle.toStringAsFixed(1)}°',
          Colors.blue,
        ),
        const SizedBox(height: 8),
        _buildMetricCard(
          theme,
          colorScheme,
          'Min Angle',
          '${summary.minAngle.toStringAsFixed(1)}°',
          Colors.orange,
        ),
        const SizedBox(height: 8),
        _buildMetricCard(
          theme,
          colorScheme,
          'Max Angle',
          '${summary.maxAngle.toStringAsFixed(1)}°',
          Colors.green,
        ),
      ],
    );
  }

  Widget _buildMetricCard(
    ThemeData theme,
    ColorScheme colorScheme,
    String label,
    String value,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colorScheme.outline.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 40,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
                Text(
                  value,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: color,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRepsTab(
    ThemeData theme,
    ColorScheme colorScheme,
    VideoAnalysisResult result,
  ) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: result.reps.length,
      itemBuilder: (context, index) {
        final rep = result.reps[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: colorScheme.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: colorScheme.outline.withOpacity(0.2)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    backgroundColor: colorScheme.primary,
                    radius: 16,
                    child: Text(
                      rep.repNumber.toString(),
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Rep ${rep.repNumber}',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Spacer(),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      'Frames ${rep.startFrame}-${rep.endFrame}',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.onPrimaryContainer,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _buildRepMetric(
                      theme,
                      colorScheme,
                      'Min Angle',
                      '${rep.minAngle.toStringAsFixed(1)}°',
                      Colors.orange,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildRepMetric(
                      theme,
                      colorScheme,
                      'Max Angle',
                      '${rep.maxAngle.toStringAsFixed(1)}°',
                      Colors.green,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildRepMetric(
    ThemeData theme,
    ColorScheme colorScheme,
    String label,
    String value,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Text(
            label,
            style: theme.textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChartTab(
    ThemeData theme,
    ColorScheme colorScheme,
    VideoAnalysisResult result,
  ) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Rep Analysis Chart',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            height: 300,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: colorScheme.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: colorScheme.outline.withOpacity(0.2)),
            ),
            child: SfCartesianChart(
              primaryXAxis: const CategoryAxis(),
              primaryYAxis: const NumericAxis(
                title: AxisTitle(text: 'Angle (degrees)'),
              ),
              title: const ChartTitle(text: 'Angle Range per Rep'),
              legend: const Legend(isVisible: true),
              tooltipBehavior: TooltipBehavior(enable: true),
              series: <CartesianSeries>[
                ColumnSeries<RepAnalysis, String>(
                  dataSource: result.reps,
                  xValueMapper: (RepAnalysis rep, _) => 'Rep ${rep.repNumber}',
                  yValueMapper: (RepAnalysis rep, _) => rep.minAngle,
                  name: 'Min Angle',
                  color: Colors.orange,
                ),
                ColumnSeries<RepAnalysis, String>(
                  dataSource: result.reps,
                  xValueMapper: (RepAnalysis rep, _) => 'Rep ${rep.repNumber}',
                  yValueMapper: (RepAnalysis rep, _) => rep.maxAngle,
                  name: 'Max Angle',
                  color: Colors.green,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDownloadSection(
    ThemeData theme,
    ColorScheme colorScheme,
    VideoAnalysisResult result,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Downloads',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () {
                  // TODO: Implement CSV download
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('CSV download coming soon!')),
                  );
                },
                icon: const Icon(Icons.table_chart),
                label: const Text('Download CSV'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () {
                  // TODO: Implement video download
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Video download coming soon!')),
                  );
                },
                icon: const Icon(Icons.video_file),
                label: const Text('Download Video'),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
