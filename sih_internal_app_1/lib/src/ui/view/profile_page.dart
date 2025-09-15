import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  // Athlete data
  final String userName = "Naman Goyal";
  final String userEmail = "naman.goyal@athlete.com";
  final int userAge = 22;
  final String userRole = "Professional Athlete";
  final String userSport = "Football";
  final String userTeam = "State Sports Academy";
  final String joinDate = "September 2024";
  final String height = "6'2\"";
  final String weight = "75 kg";
  final String position = "Midfielder";
  final String bloodGroup = "B+";
  final int trainingSessions = 45;
  final int currentStreak = 7;
  final double performanceRating = 8.5;
  final int goalsScored = 12;
  final int matchesPlayed = 28;

  @override
  void initState() {
    super.initState();
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
      curve: Curves.easeInOut,
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOutBack,
    ));

    // Start animations
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

    return Scaffold(
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SlideTransition(
          position: _slideAnimation,
          child: SingleChildScrollView(
            child: Column(
              children: [
                // Profile Header Container
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: colorScheme.primary,
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(24),
                      bottomRight: Radius.circular(24),
                    ),
                  ),
                  child: SafeArea(
                    bottom: false,
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: Column(
                        children: [
                          // Top row with back button and action icons
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.arrow_back),
                                onPressed: () => Navigator.pop(context),
                                color: colorScheme.onPrimary,
                                tooltip: 'Back',
                              ),
                              Row(
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.edit_outlined),
                                    onPressed: _showEditProfileDialog,
                                    color: colorScheme.onPrimary,
                                    tooltip: 'Edit Profile',
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.share_outlined),
                                    onPressed: _shareProfile,
                                    color: colorScheme.onPrimary,
                                    tooltip: 'Share Profile',
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          // Profile Avatar
                          Hero(
                            tag: 'profile_avatar',
                            child: Container(
                              width: 120,
                              height: 120,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: colorScheme.onPrimary,
                                  width: 4,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black
                                        .withAlpha((0.2 * 255).toInt()),
                                    blurRadius: 20,
                                    spreadRadius: 2,
                                  ),
                                ],
                              ),
                              child: CircleAvatar(
                                radius: 56,
                                backgroundColor: colorScheme.onPrimary,
                                child: Text(
                                  userName
                                      .split(' ')
                                      .map((e) => e[0])
                                      .join()
                                      .toUpperCase(),
                                  style:
                                      theme.textTheme.headlineMedium?.copyWith(
                                    color: colorScheme.primary,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          // User Name
                          Text(
                            userName,
                            style: theme.textTheme.headlineSmall?.copyWith(
                              color: colorScheme.onPrimary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          // User Role
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 4),
                            decoration: BoxDecoration(
                              color: colorScheme.onPrimary
                                  .withAlpha((0.2 * 255).toInt()),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              userRole,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: colorScheme.onPrimary,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ),
                ),

                // Profile Content
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Stats Cards
                      _buildStatsSection(theme, colorScheme),
                      const SizedBox(height: 24),

                      // Personal Information
                      _buildPersonalInfoSection(theme, colorScheme),
                      const SizedBox(height: 24),

                      // Settings Section
                      _buildSettingsSection(theme, colorScheme),
                      const SizedBox(height: 24),

                      // Support Section
                      _buildSupportSection(theme, colorScheme),
                      const SizedBox(height: 100),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatsSection(ThemeData theme, ColorScheme colorScheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Athletic Performance',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        // First row of stats
        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                theme,
                colorScheme,
                Icons.sports_soccer_outlined,
                goalsScored.toString(),
                'Goals\nScored',
                Colors.green,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildStatCard(
                theme,
                colorScheme,
                Icons.sports_outlined,
                matchesPlayed.toString(),
                'Matches\nPlayed',
                colorScheme.primary,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildStatCard(
                theme,
                colorScheme,
                Icons.star_outline,
                performanceRating.toString(),
                'Performance\nRating',
                Colors.amber,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        // Second row of stats
        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                theme,
                colorScheme,
                Icons.fitness_center_outlined,
                trainingSessions.toString(),
                'Training\nSessions',
                Colors.blue,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildStatCard(
                theme,
                colorScheme,
                Icons.local_fire_department_outlined,
                currentStreak.toString(),
                'Training\nStreak',
                Colors.orange,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildStatCard(
                theme,
                colorScheme,
                Icons.auto_graph,
                '34%',
                'This Season Improvement',
                Colors.purple,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatCard(
    ThemeData theme,
    ColorScheme colorScheme,
    IconData icon,
    String value,
    String label,
    Color accentColor,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: colorScheme.outline.withAlpha((0.2 * 255).toInt()),
        ),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withAlpha((0.1 * 255).toInt()),
            blurRadius: 8,
            spreadRadius: 0,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: accentColor.withAlpha((0.1 * 255).toInt()),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: accentColor,
              size: 24,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: theme.textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
              height: 1.2,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildPersonalInfoSection(ThemeData theme, ColorScheme colorScheme) {
    return _buildSection(
      theme,
      colorScheme,
      'Personal Information',
      [
        _buildInfoTile(
          colorScheme,
          Icons.person_outline,
          'Name',
          userName,
        ),
        _buildInfoTile(
          colorScheme,
          Icons.email_outlined,
          'Email',
          userEmail,
          onTap: () => _copyToClipboard(userEmail),
        ),
        _buildInfoTile(
          colorScheme,
          Icons.cake_outlined,
          'Age',
          '$userAge years',
        ),
      ],
    );
  }

  Widget _buildSettingsSection(ThemeData theme, ColorScheme colorScheme) {
    return _buildSection(
      theme,
      colorScheme,
      'Settings',
      [
        _buildActionTile(
          colorScheme,
          Icons.notifications_outlined,
          'Notifications',
          'Manage your notification preferences',
          onTap: () => _navigateToNotifications(),
        ),
        _buildActionTile(
          colorScheme,
          Icons.security_outlined,
          'Privacy & Security',
          'Manage your privacy settings',
          onTap: () => _showPrivacySettings(),
        ),
        _buildActionTile(
          colorScheme,
          Icons.language_outlined,
          'Language',
          'English',
          onTap: () => _showLanguageSelector(),
        ),
        _buildActionTile(
          colorScheme,
          Icons.dark_mode_outlined,
          'Theme',
          'System default',
          onTap: () => _showThemeSelector(),
        ),
      ],
    );
  }

  Widget _buildSupportSection(ThemeData theme, ColorScheme colorScheme) {
    return _buildSection(
      theme,
      colorScheme,
      'Support',
      [
        _buildActionTile(
          colorScheme,
          Icons.help_outline,
          'Help Center',
          'Get help and support',
          onTap: () => _openHelpCenter(),
        ),
        _buildActionTile(
          colorScheme,
          Icons.feedback_outlined,
          'Send Feedback',
          'Help us improve the app',
          onTap: () => _sendFeedback(),
        ),
        _buildActionTile(
          colorScheme,
          Icons.info_outline,
          'About',
          'App version and information',
          onTap: () => _showAboutDialog(),
        ),
        _buildActionTile(
          colorScheme,
          Icons.logout_outlined,
          'Sign Out',
          'Sign out of your account',
          onTap: () => _signOut(),
          isDestructive: true,
        ),
      ],
    );
  }

  Widget _buildSection(
    ThemeData theme,
    ColorScheme colorScheme,
    String title,
    List<Widget> children,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        Container(
          decoration: BoxDecoration(
            color: colorScheme.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: colorScheme.outline.withAlpha((0.2 * 255).toInt()),
            ),
            boxShadow: [
              BoxShadow(
                color: colorScheme.shadow.withAlpha((0.1 * 255).toInt()),
                blurRadius: 8,
                spreadRadius: 0,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: children,
          ),
        ),
      ],
    );
  }

  Widget _buildInfoTile(
    ColorScheme colorScheme,
    IconData icon,
    String title,
    String subtitle, {
    VoidCallback? onTap,
  }) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: colorScheme.primary.withAlpha((0.1 * 255).toInt()),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          icon,
          color: colorScheme.primary,
          size: 20,
        ),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.w500,
          color: colorScheme.onSurface,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          color: colorScheme.onSurfaceVariant,
        ),
      ),
      trailing: onTap != null
          ? Icon(
              Icons.copy_outlined,
              color: colorScheme.onSurfaceVariant,
              size: 20,
            )
          : null,
      onTap: onTap,
    );
  }

  Widget _buildActionTile(
    ColorScheme colorScheme,
    IconData icon,
    String title,
    String subtitle, {
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    final iconColor = isDestructive ? Colors.red : colorScheme.primary;
    final titleColor = isDestructive ? Colors.red : colorScheme.onSurface;

    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: iconColor.withAlpha((0.1 * 255).toInt()),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          icon,
          color: iconColor,
          size: 20,
        ),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.w500,
          color: titleColor,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          color: colorScheme.onSurfaceVariant,
        ),
      ),
      trailing: Icon(
        Icons.chevron_right,
        color: colorScheme.onSurfaceVariant,
      ),
      onTap: onTap,
    );
  }

  // Action methods
  void _showEditProfileDialog() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
          content: Text('Edit athlete profile feature coming soon!')),
    );
  }

  void _shareProfile() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
          content: Text('Share athlete profile feature coming soon!')),
    );
  }

  void _copyToClipboard(String text) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Copied $text to clipboard')),
    );
  }

  void _navigateToNotifications() {
    Navigator.pushNamed(context, '/notifications');
  }

  void _showPrivacySettings() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Privacy settings coming soon!')),
    );
  }

  void _showLanguageSelector() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Language selector coming soon!')),
    );
  }

  void _showThemeSelector() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Theme selector coming soon!')),
    );
  }

  void _openHelpCenter() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Help center coming soon!')),
    );
  }

  void _sendFeedback() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Feedback feature coming soon!')),
    );
  }

  void _showAboutDialog() {
    showAboutDialog(
      context: context,
      applicationName: 'SIH Athlete Management',
      applicationVersion: '1.0.0',
      applicationLegalese: '© 2024 SIH Team',
      children: [
        const Text(
            'Athletic Performance Management App built with Flutter for Smart India Hackathon 2025'),
      ],
    );
  }

  void _signOut() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sign Out'),
        content: const Text('Are you sure you want to sign out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Signed out successfully')),
              );
            },
            child: const Text('Sign Out'),
          ),
        ],
      ),
    );
  }
}
