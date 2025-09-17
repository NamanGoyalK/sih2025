import 'dart:math';

import 'package:flutter/material.dart';

class SettingsBottomSheets {
  // Shared sheet presenter matching profile page theme
  static Future<void> _showThemedBottomSheet(
    BuildContext context, {
    required Widget child,
  }) async {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        final theme = Theme.of(ctx);
        final colors = theme.colorScheme;
        final insets = MediaQuery.of(ctx).viewInsets;
        return SafeArea(
          top: false,
          child: Container(
            decoration: BoxDecoration(
              color: colors.surface,
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(28)),
              border: Border.all(color: colors.outline, width: 1),
              boxShadow: [
                BoxShadow(
                  color: colors.shadow.withAlpha((0.12 * 255).toInt()),
                  blurRadius: 24,
                  offset: const Offset(0, -8),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Grab handle
                Padding(
                  padding: const EdgeInsets.only(top: 10, bottom: 6),
                  child: Container(
                    width: 42,
                    height: 4,
                    decoration: BoxDecoration(
                      color: colors.onSurfaceVariant
                          .withAlpha((0.5 * 255).toInt()),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                // Removed the divider/strip under pull indicator as requested
                Padding(
                  padding: EdgeInsets.only(
                      left: 20, right: 20, bottom: 20 + insets.bottom),
                  child: child,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Common "Done" button (full-width, centered, white with outline)
  static Widget _doneButton(BuildContext context,
      {required VoidCallback onPressed, String label = 'Done'}) {
    final colors = Theme.of(context).colorScheme;
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: colors.outline, width: 1.2),
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          textStyle: const TextStyle(fontWeight: FontWeight.w600),
        ),
        onPressed: onPressed,
        child: Text(label, textAlign: TextAlign.center),
      ),
    );
  }

  // Notifications
  static Future<void> showNotifications(
    BuildContext context, {
    required bool inAppEnabled,
    required bool emailEnabled,
    required ValueChanged<bool> onInAppChanged,
    required ValueChanged<bool> onEmailChanged,
  }) async {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    // Local state to reflect changes immediately
    bool localInApp = inAppEnabled;
    bool localEmail = emailEnabled;

    await _showThemedBottomSheet(
      context,
      child: StatefulBuilder(
        builder: (ctx, setModalState) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: colors.primary.withAlpha((0.12 * 255).toInt()),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(Icons.notifications_active_outlined,
                        color: colors.primary),
                  ),
                  const SizedBox(width: 12),
                  Text('Notifications',
                      style: theme.textTheme.titleLarge
                          ?.copyWith(fontWeight: FontWeight.w800)),
                ],
              ),
              const SizedBox(height: 16),
              Container(
                decoration: BoxDecoration(
                  color: colors.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: colors.outline),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SwitchListTile.adaptive(
                      secondary: Icon(Icons.phone_iphone_outlined,
                          color: colors.primary),
                      title: const Text('In-app notifications'),
                      subtitle: const Text(
                          'Show reminders and updates inside the app'),
                      value: localInApp,
                      onChanged: (v) {
                        setModalState(() => localInApp = v);
                        onInAppChanged(v);
                      },
                    ),
                    const Divider(height: 1),
                    SwitchListTile.adaptive(
                      secondary:
                          Icon(Icons.mail_outline, color: colors.primary),
                      title: const Text('Email notifications'),
                      subtitle:
                          const Text('Receive important updates via email'),
                      value: localEmail,
                      onChanged: (v) {
                        setModalState(() => localEmail = v);
                        onEmailChanged(v);
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              _doneButton(
                context,
                onPressed: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Notification preferences saved')),
                  );
                },
              ),
            ],
          );
        },
      ),
    );
  }

  // Privacy & Security
  static Future<void> showPrivacySecurity(
    BuildContext context, {
    required bool twoFactor,
    required bool allowAnalytics,
    required bool sharePublic,
    required ValueChanged<bool> onTwoFactorChanged,
    required ValueChanged<bool> onAllowAnalyticsChanged,
    required ValueChanged<bool> onSharePublicChanged,
    required VoidCallback onDeleteAccount,
  }) async {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    bool localTwoFactor = twoFactor;
    bool localAllowAnalytics = allowAnalytics;
    bool localSharePublic = sharePublic;

    await _showThemedBottomSheet(
      context,
      child: StatefulBuilder(
        builder: (ctx, setModalState) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: colors.primary.withAlpha((0.12 * 255).toInt()),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(Icons.security_outlined, color: colors.primary),
                  ),
                  const SizedBox(width: 12),
                  Text('Privacy & Security',
                      style: theme.textTheme.titleLarge
                          ?.copyWith(fontWeight: FontWeight.w800)),
                ],
              ),
              const SizedBox(height: 16),
              Container(
                decoration: BoxDecoration(
                  color: colors.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: colors.outline),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SwitchListTile.adaptive(
                      secondary: Icon(Icons.verified_user_outlined,
                          color: colors.primary),
                      title: const Text('Two-factor authentication'),
                      subtitle: const Text(
                          'Add an extra layer of security to your account'),
                      value: localTwoFactor,
                      onChanged: (v) {
                        setModalState(() => localTwoFactor = v);
                        onTwoFactorChanged(v);
                      },
                    ),
                    const Divider(height: 1),
                    SwitchListTile.adaptive(
                      secondary:
                          Icon(Icons.analytics_outlined, color: colors.primary),
                      title: const Text('Personalized analytics'),
                      subtitle: const Text(
                          'Allow anonymized data to improve recommendations'),
                      value: localAllowAnalytics,
                      onChanged: (v) {
                        setModalState(() => localAllowAnalytics = v);
                        onAllowAnalyticsChanged(v);
                      },
                    ),
                    const Divider(height: 1),
                    SwitchListTile.adaptive(
                      secondary:
                          Icon(Icons.public_outlined, color: colors.primary),
                      title: const Text('Share activity publicly'),
                      subtitle: const Text(
                          'Allow others to view your public profile activity'),
                      value: localSharePublic,
                      onChanged: (v) {
                        setModalState(() => localSharePublic = v);
                        onSharePublicChanged(v);
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.red.withAlpha((0.08 * 255).toInt()),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                      color: Colors.red.withAlpha((0.4 * 255).toInt())),
                ),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.warning_amber_rounded,
                            color: Colors.red),
                        const SizedBox(width: 8),
                        Text('Danger zone',
                            style: theme.textTheme.titleMedium?.copyWith(
                                color: Colors.red,
                                fontWeight: FontWeight.w700)),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Remove your account and delete all data from the app\'s database. This action cannot be undone.',
                      style: theme.textTheme.bodyMedium
                          ?.copyWith(color: colors.onSurfaceVariant),
                    ),
                    const SizedBox(height: 12),
                    FilledButton.tonal(
                      style: FilledButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                      ),
                      onPressed: onDeleteAccount,
                      child: const Text('Delete account and data'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              _doneButton(
                context,
                onPressed: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Privacy settings saved')),
                  );
                },
              ),
            ],
          );
        },
      ),
    );
  }

  // Language
  static Future<void> showLanguage(
    BuildContext context, {
    required String languageCode,
    required ValueChanged<String> onChanged,
  }) async {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    const langs = [
      {'code': 'en', 'name': 'English'},
      {'code': 'hi', 'name': 'Hindi (हिन्दी)'},
      {'code': 'bn', 'name': 'Bengali (বাংলা)'},
      {'code': 'te', 'name': 'Telugu (తెలుగు)'},
      {'code': 'mr', 'name': 'Marathi (मराठी)'},
      {'code': 'ta', 'name': 'Tamil (தமிழ்)'},
      {'code': 'gu', 'name': 'Gujarati (ગુજરાતી)'},
      {'code': 'kn', 'name': 'Kannada (ಕನ್ನಡ)'},
      {'code': 'ml', 'name': 'Malayalam (മലയാളം)'},
      {'code': 'or', 'name': 'Odia (ଓଡିଆ)'},
      {'code': 'pa', 'name': 'Punjabi (ਪੰਜਾਬੀ)'},
      {'code': 'as', 'name': 'Assamese (অসমীয়া)'},
      {'code': 'ur', 'name': 'Urdu (اردو)'},
    ];

    String displayName(String code) {
      return (langs.firstWhere((e) => e['code'] == code,
          orElse: () => langs.first))['name']!;
    }

    // Local language selection for immediate reflect
    String localLang = languageCode;

    await _showThemedBottomSheet(
      context,
      child: StatefulBuilder(
        builder: (ctx, setModalState) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: colors.primary.withAlpha((0.12 * 255).toInt()),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(Icons.language_outlined, color: colors.primary),
                  ),
                  const SizedBox(width: 12),
                  Text('Language',
                      style: theme.textTheme.titleLarge
                          ?.copyWith(fontWeight: FontWeight.w800)),
                ],
              ),
              const SizedBox(height: 16),
              Container(
                decoration: BoxDecoration(
                  color: colors.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: colors.outline),
                ),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    // Cap list height so sheet doesn't go full screen
                    maxHeight:
                        min(MediaQuery.of(context).size.height * 0.6, 480),
                  ),
                  child: ListView.separated(
                    shrinkWrap: true,
                    itemCount: langs.length,
                    separatorBuilder: (_, __) => const Divider(height: 1),
                    itemBuilder: (ctx, i) {
                      final code = langs[i]['code']!;
                      final name = langs[i]['name']!;
                      return RadioListTile<String>(
                        value: code,
                        groupValue: localLang,
                        onChanged: (v) {
                          setModalState(() => localLang = v ?? 'en');
                          onChanged(localLang);
                        },
                        title: Text(name),
                        secondary: localLang == code
                            ? Icon(Icons.check_circle, color: colors.primary)
                            : const SizedBox.shrink(),
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(height: 16),
              _doneButton(
                context,
                onPressed: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content:
                            Text('Language set to ${displayName(localLang)}')),
                  );
                },
              ),
            ],
          );
        },
      ),
    );
  }

  // Theme
  static Future<void> showTheme(
    BuildContext context, {
    required ThemeMode selected,
    required ValueChanged<ThemeMode> onChanged,
  }) async {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    String label(ThemeMode mode) {
      switch (mode) {
        case ThemeMode.light:
          return 'Light';
        case ThemeMode.dark:
          return 'Dark';
        case ThemeMode.system:
          return 'System default';
      }
    }

    ThemeMode localSelected = selected;

    await _showThemedBottomSheet(
      context,
      child: StatefulBuilder(
        builder: (ctx, setModalState) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: colors.primary.withAlpha((0.12 * 255).toInt()),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child:
                        Icon(Icons.dark_mode_outlined, color: colors.primary),
                  ),
                  const SizedBox(width: 12),
                  Text('Theme',
                      style: theme.textTheme.titleLarge
                          ?.copyWith(fontWeight: FontWeight.w800)),
                ],
              ),
              const SizedBox(height: 16),
              Container(
                decoration: BoxDecoration(
                  color: colors.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: colors.outline),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    RadioListTile<ThemeMode>(
                      value: ThemeMode.light,
                      groupValue: localSelected,
                      onChanged: (v) {
                        setModalState(
                            () => localSelected = v ?? ThemeMode.system);
                        onChanged(localSelected);
                      },
                      title: const Text('Light'),
                      secondary: const Icon(Icons.wb_sunny_outlined),
                    ),
                    const Divider(height: 1),
                    RadioListTile<ThemeMode>(
                      value: ThemeMode.dark,
                      groupValue: localSelected,
                      onChanged: (v) {
                        setModalState(
                            () => localSelected = v ?? ThemeMode.system);
                        onChanged(localSelected);
                      },
                      title: const Text('Dark'),
                      secondary: const Icon(Icons.nightlight_round_outlined),
                    ),
                    const Divider(height: 1),
                    RadioListTile<ThemeMode>(
                      value: ThemeMode.system,
                      groupValue: localSelected,
                      onChanged: (v) {
                        setModalState(
                            () => localSelected = v ?? ThemeMode.system);
                        onChanged(localSelected);
                      },
                      title: const Text('System default'),
                      secondary: const Icon(Icons.settings_suggest_outlined),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              _doneButton(
                context,
                onPressed: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content: Text('Theme set to ${label(localSelected)}')),
                  );
                },
              ),
            ],
          );
        },
      ),
    );
  }
}
