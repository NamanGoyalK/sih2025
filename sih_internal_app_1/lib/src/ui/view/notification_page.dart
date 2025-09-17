import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sih_internal_app_1/src/models/notification.dart' as model;
import 'package:sih_internal_app_1/src/providers/notification_provider.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
  }

  void _initializeAnimations() {
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    ));

    _fadeController.forward();

    _scrollController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final provider = context.watch<NotificationsProvider>();

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: CustomScrollView(
        controller: _scrollController,
        physics: const BouncingScrollPhysics(),
        slivers: [
          // Enhanced Animated Header matching other pages
          SliverAppBar(
            expandedHeight: 150,
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
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          GestureDetector(
                            onTap: () => Navigator.pop(context),
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
                          Text(
                            'Notifications',
                            style: theme.textTheme.titleLarge?.copyWith(
                              color: colorScheme.onPrimary,
                              fontWeight: FontWeight.w600,
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
                                          onTap: () => Navigator.pop(context),
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
                                            'Notifications',
                                            style: theme
                                                .textTheme.headlineMedium
                                                ?.copyWith(
                                              fontSize: 32,
                                              color: colorScheme.onPrimary,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    IconButton(
                                      onPressed: _markAllAsRead,
                                      icon: Container(
                                        padding: const EdgeInsets.all(12),
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            colors: [
                                              colorScheme.onPrimary.withAlpha(
                                                  (0.2 * 255).toInt()),
                                              colorScheme.onPrimary.withAlpha(
                                                  (0.1 * 255).toInt()),
                                            ],
                                            begin: Alignment.topLeft,
                                            end: Alignment.bottomRight,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(16),
                                          border: Border.all(
                                            color: colorScheme.onPrimary
                                                .withAlpha((0.2 * 255).toInt()),
                                            width: 1,
                                          ),
                                        ),
                                        child: Icon(
                                          Icons.done_all,
                                          color: colorScheme.onPrimary,
                                          size: 22,
                                        ),
                                      ),
                                      tooltip: 'Mark all as read',
                                    ),
                                  ],
                                ),
                                const Spacer(),
                                FadeTransition(
                                  opacity: _fadeAnimation,
                                  child: Text(
                                    'Stay updated with your progress',
                                    style: theme.textTheme.bodyLarge?.copyWith(
                                      color: colorScheme.onPrimary
                                          .withAlpha((0.8 * 255).toInt()),
                                      fontSize: 16,
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

          // Main Content
          SliverToBoxAdapter(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: Builder(builder: (context) {
                if (provider.loading) {
                  return const Padding(
                    padding: EdgeInsets.all(24.0),
                    child: Center(child: CircularProgressIndicator()),
                  );
                }
                if (provider.error != null) {
                  return Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Center(
                      child: Text(
                        'Failed to load notifications',
                        style: theme.textTheme.bodyMedium,
                      ),
                    ),
                  );
                }
                final items = provider.items;
                return _buildNotificationList(items, 'No notifications yet');
              }),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationList(
      List<model.NotificationItem> notifications, String emptyMessage) {
    if (notifications.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(16),
        child: _buildEmptyState(emptyMessage),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: List.generate(
          notifications.length,
          (index) => _buildNotificationCard(notifications[index], index),
        ),
      ),
    );
  }

  Widget _buildEmptyState(String message) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.notifications_none_outlined,
            size: 80,
            color: colorScheme.onSurfaceVariant,
          ),
          const SizedBox(height: 16),
          Text(
            message,
            style: theme.textTheme.titleMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'You\'re all caught up!',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationCard(
      model.NotificationItem notification, int index) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return AnimatedContainer(
      duration: Duration(milliseconds: 300 + (index * 100)),
      margin: const EdgeInsets.only(bottom: 12),
      child: Dismissible(
        key: Key(notification.id),
        background: Container(
          decoration: BoxDecoration(
            color: Colors.green,
            borderRadius: BorderRadius.circular(16),
          ),
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.only(left: 20),
          child: const Icon(
            Icons.done,
            color: Colors.white,
          ),
        ),
        secondaryBackground: Container(
          decoration: BoxDecoration(
            color: Colors.red,
            borderRadius: BorderRadius.circular(16),
          ),
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.only(right: 20),
          child: const Icon(
            Icons.delete,
            color: Colors.white,
          ),
        ),
        onDismissed: (direction) {
          if (direction == DismissDirection.startToEnd) {
            _markAsRead(notification);
          } else {
            _deleteNotification(notification);
          }
        },
        child: Container(
          decoration: BoxDecoration(
            color: notification.isRead
                ? colorScheme.surface
                : colorScheme.primary.withAlpha((0.05 * 255).toInt()),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: notification.isRead
                  ? colorScheme.outline.withAlpha((0.2 * 255).toInt())
                  : colorScheme.primary.withAlpha((0.3 * 255).toInt()),
              width: notification.isRead ? 1 : 2,
            ),
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.all(16),
            leading: _buildNotificationIcon(notification, colorScheme),
            title: Row(
              children: [
                Expanded(
                  child: Text(
                    notification.title,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: notification.isRead
                          ? FontWeight.w500
                          : FontWeight.bold,
                    ),
                  ),
                ),
                if (!notification.isRead)
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: colorScheme.primary,
                      shape: BoxShape.circle,
                    ),
                  ),
              ],
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8),
                Text(
                  notification.message,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Text(
                      _getTimeAgo(notification.timestamp),
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const Spacer(),
                    if (notification.score != null)
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: _getScoreColor(notification.score!)
                              .withAlpha((0.2 * 255).toInt()),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          '${notification.score}%',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: _getScoreColor(notification.score!),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                  ],
                ),
                if (notification.actionButton != null) ...[
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: () => _handleNotificationAction(notification),
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: colorScheme.primary),
                      ),
                      child: Text(notification.actionButton!),
                    ),
                  ),
                ],
              ],
            ),
            onTap: () => _handleNotificationTap(notification),
          ),
        ),
      ),
    ); // closes AnimatedContainer
  }

  Widget _buildNotificationIcon(
      model.NotificationItem notification, ColorScheme colorScheme) {
    IconData icon;
    Color color;

    switch (notification.type) {
      case model.NotificationType.assessment:
        icon = Icons.quiz_outlined;
        color = Colors.blue;
        break;
      case model.NotificationType.achievement:
        icon = Icons.emoji_events_outlined;
        color = Colors.amber;
        break;
      case model.NotificationType.result:
        icon = Icons.grade_outlined;
        color = Colors.green;
        break;
      case model.NotificationType.reminder:
        icon = Icons.schedule_outlined;
        color = Colors.orange;
        break;
      case model.NotificationType.system:
        icon = Icons.settings_outlined;
        color = Colors.grey;
        break;
      case model.NotificationType.general:
        icon = Icons.info_outlined;
        color = colorScheme.primary;
        break;
    }

    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: color.withAlpha((0.1 * 255).toInt()),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(
        icon,
        color: color,
        size: 24,
      ),
    );
  }

  Color _getScoreColor(int score) {
    if (score >= 90) return Colors.green;
    if (score >= 80) return Colors.orange;
    if (score >= 70) return Colors.yellow[700]!;
    return Colors.red;
  }

  String _getTimeAgo(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return '${timestamp.day}/${timestamp.month}/${timestamp.year}';
    }
  }

  void _handleNotificationTap(model.NotificationItem notification) {
    if (!notification.isRead) {
      _markAsRead(notification);
    }

    switch (notification.type) {
      case model.NotificationType.assessment:
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Opening assessment...')),
        );
        break;
      case model.NotificationType.result:
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Opening results...')),
        );
        break;
      default:
        break;
    }
  }

  void _handleNotificationAction(model.NotificationItem notification) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${notification.actionButton} clicked!')),
    );
  }

  void _markAsRead(model.NotificationItem notification) {
    context.read<NotificationsProvider>().markItemRead(notification.id);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Marked as read'),
        duration: Duration(seconds: 1),
      ),
    );
  }

  void _deleteNotification(model.NotificationItem notification) {
    context.read<NotificationsProvider>().deleteById(notification.id);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Notification deleted'),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            // For simplicity, not implementing undo persistence here
          },
        ),
      ),
    );
  }

  void _markAllAsRead() {
    context.read<NotificationsProvider>().markAllRead();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('All notifications marked as read')),
    );
  }
}
