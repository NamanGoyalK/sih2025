import 'package:flutter/material.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  List<NotificationItem> allNotifications = [];

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _initializeData();
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
  }

  void _initializeData() {
    // Sample notification data
    allNotifications = [
      NotificationItem(
        id: '1',
        title: 'New Assessment Available',
        message:
            'Mathematics Quiz #3 is now available. Complete it before the deadline.',
        type: NotificationType.assessment,
        timestamp: DateTime.now().subtract(const Duration(minutes: 30)),
        isRead: false,
        actionButton: 'Take Quiz',
      ),
      NotificationItem(
        id: '2',
        title: 'Leaderboard Update',
        message:
            'You\'ve moved up to rank #5 in the weekly leaderboard! Keep it up!',
        type: NotificationType.achievement,
        timestamp: DateTime.now().subtract(const Duration(hours: 2)),
        isRead: false,
      ),
      NotificationItem(
        id: '3',
        title: 'Assessment Result',
        message: 'Your Physics Quiz #2 has been graded. You scored 92%!',
        type: NotificationType.result,
        timestamp: DateTime.now().subtract(const Duration(hours: 4)),
        isRead: true,
        score: 92,
      ),
      NotificationItem(
        id: '4',
        title: 'Deadline Reminder',
        message:
            'Chemistry assignment is due in 2 days. Don\'t forget to submit!',
        type: NotificationType.reminder,
        timestamp: DateTime.now().subtract(const Duration(hours: 6)),
        isRead: true,
      ),
      NotificationItem(
        id: '5',
        title: 'System Maintenance',
        message:
            'The app will be under maintenance tomorrow from 2:00 AM to 4:00 AM.',
        type: NotificationType.system,
        timestamp: DateTime.now().subtract(const Duration(days: 1)),
        isRead: true,
      ),
      NotificationItem(
        id: '6',
        title: 'Welcome to SIH App!',
        message:
            'Thank you for joining us. Complete your profile to get started.',
        type: NotificationType.general,
        timestamp: DateTime.now().subtract(const Duration(days: 2)),
        isRead: true,
      ),
    ];
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: Column(
          children: [
            // Header Section with rounded container
            Container(
              padding: const EdgeInsets.fromLTRB(20, 40, 20, 20),
              decoration: BoxDecoration(
                color: colorScheme.primary,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(24),
                  bottomRight: Radius.circular(24),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Row(
                          children: [
                            InkWell(
                              onTap: () => Navigator.pop(context),
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: colorScheme.onPrimary
                                      .withAlpha((0.2 * 255).toInt()),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Icon(
                                  Icons.arrow_back,
                                  color: colorScheme.onPrimary,
                                  size: 20,
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Text(
                              'Notifications',
                              style: theme.textTheme.headlineSmall?.copyWith(
                                color: colorScheme.onPrimary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      InkWell(
                        onTap: _markAllAsRead,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: colorScheme.onPrimary
                                .withAlpha((0.2 * 255).toInt()),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.done_all,
                                color: colorScheme.onPrimary,
                                size: 18,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                'Mark All Read',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: colorScheme.onPrimary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Content
            Expanded(
              child: _buildNotificationList(
                  allNotifications, 'No notifications yet'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationList(
      List<NotificationItem> notifications, String emptyMessage) {
    if (notifications.isEmpty) {
      return _buildEmptyState(emptyMessage);
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: notifications.length,
      itemBuilder: (context, index) {
        return _buildNotificationCard(notifications[index], index);
      },
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

  Widget _buildNotificationCard(NotificationItem notification, int index) {
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
      NotificationItem notification, ColorScheme colorScheme) {
    IconData icon;
    Color color;

    switch (notification.type) {
      case NotificationType.assessment:
        icon = Icons.quiz_outlined;
        color = Colors.blue;
        break;
      case NotificationType.achievement:
        icon = Icons.emoji_events_outlined;
        color = Colors.amber;
        break;
      case NotificationType.result:
        icon = Icons.grade_outlined;
        color = Colors.green;
        break;
      case NotificationType.reminder:
        icon = Icons.schedule_outlined;
        color = Colors.orange;
        break;
      case NotificationType.system:
        icon = Icons.settings_outlined;
        color = Colors.grey;
        break;
      case NotificationType.general:
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

  void _handleNotificationTap(NotificationItem notification) {
    if (!notification.isRead) {
      _markAsRead(notification);
    }

    // Handle navigation based on notification type
    switch (notification.type) {
      case NotificationType.assessment:
        // Navigate to assessment
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Opening assessment...')),
        );
        break;
      case NotificationType.result:
        // Navigate to results
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Opening results...')),
        );
        break;
      default:
        // Default action
        break;
    }
  }

  void _handleNotificationAction(NotificationItem notification) {
    // Handle specific notification actions
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${notification.actionButton} clicked!')),
    );
  }

  void _markAsRead(NotificationItem notification) {
    setState(() {
      notification.isRead = true;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Marked as read'),
        duration: Duration(seconds: 1),
      ),
    );
  }

  void _deleteNotification(NotificationItem notification) {
    setState(() {
      allNotifications.removeWhere((n) => n.id == notification.id);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Notification deleted'),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            // Implement undo functionality
          },
        ),
      ),
    );
  }

  void _markAllAsRead() {
    setState(() {
      for (var notification in allNotifications) {
        notification.isRead = true;
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('All notifications marked as read')),
    );
  }
}

// Models and Enums
enum NotificationType {
  assessment,
  achievement,
  result,
  reminder,
  system,
  general,
}

class NotificationItem {
  final String id;
  final String title;
  final String message;
  final NotificationType type;
  final DateTime timestamp;
  bool isRead;
  final String? actionButton;
  final int? score;

  NotificationItem({
    required this.id,
    required this.title,
    required this.message,
    required this.type,
    required this.timestamp,
    this.isRead = false,
    this.actionButton,
    this.score,
  });
}
