import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import '../widgets/settings_bottom_sheets.dart';

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

  // User data - Updated for general user
  final String userName = "Naman Goyal";
  final String userEmail = "naman.goyal@gmail.com";
  final int userAge = 19;
  final String userRole = "Sports Aspirant";
  final String userLocation = "Patiala, Punjab";
  final String preferredSport = "Football";
  final String joinDate = "October 2025";
  final String height = "5'8\"";
  final String weight = "88 kg";
  final String fitnessLevel = "Intermediate";
  final String bloodGroup = "O+";

  // Settings state (persist locally for now; integrate with storage later)
  bool _inAppNotifications = true;
  bool _emailNotifications = true;
  bool _twoFactorAuth = false;
  bool _allowAnalytics = true;
  bool _shareActivityPublicly = false;
  ThemeMode _selectedThemeMode = ThemeMode.system;
  String _languageCode = 'en'; // default English

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
      backgroundColor: colorScheme.surface,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
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
                    titlePadding: const EdgeInsets.only(
                      left: 24,
                      bottom: 16,
                    ),
                    centerTitle: false,
                    title: AnimatedOpacity(
                      opacity: isCollapsed ? 1.0 : 0.0,
                      duration: const Duration(milliseconds: 200),
                      child: Text(
                        'My Profile',
                        style: theme.textTheme.titleLarge?.copyWith(
                          color: colorScheme.onPrimary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    background: Stack(
                      children: [
                        // Decorative circles (match other pages)
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
                          bottom: false,
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                            child: Row(
                              children: [
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Hero(
                                      tag: 'profile_avatar',
                                      child: Stack(
                                        children: [
                                          Container(
                                            width: 70,
                                            height: 70,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              border: Border.all(
                                                color: colorScheme.onPrimary,
                                                width: 4,
                                              ),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.black.withAlpha(
                                                      (0.2 * 255).toInt()),
                                                  blurRadius: 20,
                                                  spreadRadius: 2,
                                                ),
                                              ],
                                            ),
                                            child: CircleAvatar(
                                              radius: 56,
                                              backgroundColor:
                                                  colorScheme.onPrimary,
                                              child: Text(
                                                userName
                                                    .split(' ')
                                                    .map((e) => e[0])
                                                    .join()
                                                    .toUpperCase(),
                                                style: theme
                                                    .textTheme.headlineMedium
                                                    ?.copyWith(
                                                  color: colorScheme.primary,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ),
                                          // Achievement badge
                                          Positioned(
                                            bottom: 0,
                                            right: 0,
                                            child: Container(
                                              width: 24,
                                              height: 24,
                                              decoration: BoxDecoration(
                                                color: Colors.amber,
                                                shape: BoxShape.circle,
                                                border: Border.all(
                                                  color: colorScheme.onPrimary,
                                                  width: 2,
                                                ),
                                              ),
                                              child: const Icon(
                                                Icons.trending_up,
                                                color: Colors.white,
                                                size: 20,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(width: 16),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // User Name
                                    Text(
                                      userName,
                                      style: theme.textTheme.headlineLarge
                                          ?.copyWith(
                                        color: colorScheme.onPrimary,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
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
                                        style: theme.textTheme.bodyMedium
                                            ?.copyWith(
                                          color: colorScheme.onPrimary,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ],
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
            actions: [
              Container(
                width: 40,
                height: 40,
                margin: const EdgeInsets.only(right: 8),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      colorScheme.onPrimary.withAlpha((0.2 * 255).toInt()),
                      colorScheme.onPrimary.withAlpha((0.1 * 255).toInt()),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: colorScheme.onPrimary.withAlpha((0.2 * 255).toInt()),
                    width: 1,
                  ),
                ),
                child: IconButton(
                  padding: EdgeInsets.zero,
                  iconSize: 20,
                  icon: const Icon(Icons.edit_outlined, color: Colors.white),
                  onPressed: _showEditProfileDialog,
                  tooltip: 'Edit Profile',
                ),
              ),
              Container(
                width: 40,
                height: 40,
                margin: const EdgeInsets.only(right: 16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      colorScheme.onPrimary.withAlpha((0.2 * 255).toInt()),
                      colorScheme.onPrimary.withAlpha((0.1 * 255).toInt()),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: colorScheme.onPrimary.withAlpha((0.2 * 255).toInt()),
                    width: 1,
                  ),
                ),
                child: IconButton(
                  padding: EdgeInsets.zero,
                  iconSize: 20,
                  icon: const Icon(Icons.share_outlined, color: Colors.white),
                  onPressed: _shareProfile,
                  tooltip: 'Share Progress',
                ),
              ),
            ],
          ),
          SliverToBoxAdapter(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: SlideTransition(
                position: _slideAnimation,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Progress Overview Card
                      _buildProgressOverviewCard(theme, colorScheme),
                      const SizedBox(height: 24),

                      // Personal Information
                      _buildPersonalInfoSection(theme, colorScheme),
                      const SizedBox(height: 24),

                      // App Settings
                      _buildSettingsSection(theme, colorScheme),
                      const SizedBox(height: 24),

                      // Support Section
                      _buildSupportSection(theme, colorScheme),
                      const SizedBox(height: 100),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressOverviewCard(ThemeData theme, ColorScheme colorScheme) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        // Match card style with other pages
        color: colorScheme.surfaceContainerHighest.withAlpha(100),
        border: Border.all(
          color: colorScheme.outline,
          width: 1,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withAlpha((0.08 * 255).toInt()),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: colorScheme.primary.withAlpha((0.1 * 255).toInt()),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.emoji_events_rounded,
                  color: colorScheme.primary,
                  size: 22,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Your Progress',
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w800,
                        color: colorScheme.onSurface,
                      ),
                    ),
                    Text(
                      'Personal performance summary',
                      style: theme.textTheme.bodyMedium?.copyWith(
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Overall Score',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '72.5%',
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w900,
                        color: colorScheme.primary,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.green.withAlpha((0.15 * 255).toInt()),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.trending_up_rounded,
                      size: 16,
                      color: Colors.green,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Rank #15',
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: Colors.green,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ],
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
          'Full Name',
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
        _buildInfoTile(
          colorScheme,
          Icons.location_on_outlined,
          'Location',
          userLocation,
        ),
        _buildInfoTile(
          colorScheme,
          Icons.height_outlined,
          'Height',
          height,
        ),
        _buildInfoTile(
          colorScheme,
          Icons.monitor_weight_outlined,
          'Weight',
          weight,
        ),
        _buildInfoTile(
          colorScheme,
          Icons.water_drop_outlined,
          'Blood Group',
          bloodGroup,
        ),
      ],
    );
  }

  Widget _buildSettingsSection(ThemeData theme, ColorScheme colorScheme) {
    return _buildSection(
      theme,
      colorScheme,
      'App Settings',
      [
        _buildActionTile(
          colorScheme,
          Icons.notifications_outlined,
          'Notifications',
          'Manage assessment reminders',
          onTap: () {
            SettingsBottomSheets.showNotifications(
              context,
              inAppEnabled: _inAppNotifications,
              emailEnabled: _emailNotifications,
              onInAppChanged: (v) => setState(() => _inAppNotifications = v),
              onEmailChanged: (v) => setState(() => _emailNotifications = v),
            );
          },
        ),
        _buildActionTile(
          colorScheme,
          Icons.security_outlined,
          'Privacy & Security',
          'Manage your data privacy',
          onTap: () {
            SettingsBottomSheets.showPrivacySecurity(
              context,
              twoFactor: _twoFactorAuth,
              allowAnalytics: _allowAnalytics,
              sharePublic: _shareActivityPublicly,
              onTwoFactorChanged: (v) => setState(() => _twoFactorAuth = v),
              onAllowAnalyticsChanged: (v) =>
                  setState(() => _allowAnalytics = v),
              onSharePublicChanged: (v) =>
                  setState(() => _shareActivityPublicly = v),
              onDeleteAccount: _confirmDeleteAccount,
            );
          },
        ),
        _buildActionTile(
          colorScheme,
          Icons.language_outlined,
          'Language',
          '${_languageDisplayName(_languageCode)} (Change language)',
          onTap: () {
            SettingsBottomSheets.showLanguage(
              context,
              languageCode: _languageCode,
              onChanged: (code) => setState(() => _languageCode = code),
            );
          },
        ),
        _buildActionTile(
          colorScheme,
          Icons.dark_mode_outlined,
          'Theme',
          _themeLabel(_selectedThemeMode),
          onTap: () {
            SettingsBottomSheets.showTheme(
              context,
              selected: _selectedThemeMode,
              onChanged: (mode) => setState(() => _selectedThemeMode = mode),
            );
          },
        ),
      ],
    );
  }

  Widget _buildSupportSection(ThemeData theme, ColorScheme colorScheme) {
    return _buildSection(
      theme,
      colorScheme,
      'Help & Support',
      [
        _buildActionTile(
          colorScheme,
          Icons.help_outline,
          'Help Center',
          'Get help with assessments',
          onTap: () => _openHelpCenter(),
        ),
        _buildActionTile(
          colorScheme,
          Icons.quiz_outlined,
          'Assessment Guide',
          'Learn about different tests',
          onTap: () => _showAssessmentGuide(),
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
          onTap: () {
            context.go("/login");
            _signOut();
          },
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
              color: colorScheme.outline,
            ),
            boxShadow: [
              BoxShadow(
                color: colorScheme.shadow.withAlpha((0.08 * 255).toInt()),
                blurRadius: 12,
                spreadRadius: 0,
                offset: const Offset(0, 4),
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

  // Remove old inline sheet implementations and helper

  // Action methods - Updated for general user context
  void _showEditProfileDialog() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Edit profile feature coming soon!')),
    );
  }

  void _shareProfile() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Share progress feature coming soon!')),
    );
  }

  void _copyToClipboard(String text) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Copied $text to clipboard')),
    );
  }

  void _openHelpCenter() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Help center coming soon!')),
    );
  }

  void _showAssessmentGuide() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Assessment guide coming soon!')),
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
      applicationName: 'Sports Talent Assessment',
      applicationVersion: '1.0.0',
      applicationLegalese: '© 2025 Sports Authority of India',
      children: [
        const Text(
            'AI-Powered Mobile Platform for Democratizing Sports Talent Assessment - Smart India Hackathon 2025'),
      ],
    );
  }

  void _confirmDeleteAccount() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete account?'),
        content: const Text(
            'This will permanently remove your account and all data. This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              Navigator.pop(ctx); // close dialog
              Navigator.pop(context); // close sheet
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content: Text('Account deleted and data removed')),
              );
              context.go('/login');
            },
            child: const Text('Delete'),
          ),
        ],
      ),
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

  String _themeLabel(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.light:
        return 'Light';
      case ThemeMode.dark:
        return 'Dark';
      case ThemeMode.system:
        return 'System default';
    }
  }

  String _languageDisplayName(String code) {
    switch (code) {
      case 'hi':
        return 'Hindi';
      case 'bn':
        return 'Bengali';
      case 'te':
        return 'Telugu';
      case 'mr':
        return 'Marathi';
      case 'ta':
        return 'Tamil';
      case 'gu':
        return 'Gujarati';
      case 'kn':
        return 'Kannada';
      case 'ml':
        return 'Malayalam';
      case 'or':
        return 'Odia';
      case 'pa':
        return 'Punjabi';
      case 'as':
        return 'Assamese';
      case 'ur':
        return 'Urdu';
      case 'en':
      default:
        return 'English';
    }
  }
}
