import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 120),
      children: [
        Align(
          alignment: Alignment.centerRight,
          child: GestureDetector(
            onTap: () => _notImplemented(context, 'Settings'),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.8),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.settings_outlined,
                size: 19,
                color: AppColors.ink,
              ),
            ),
          ),
        ),
        const SizedBox(height: 6),
        Center(
          child: Container(
            width: 104,
            height: 104,
            padding: const EdgeInsets.all(3),
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: AppColors.brandGradient,
            ),
            child: Container(
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [Color(0xFFF2C08A), Color(0xFFD98327)],
                ),
              ),
              alignment: Alignment.center,
              child: const Text(
                'A',
                style: TextStyle(
                  fontSize: 38,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        const Center(
          child: Text(
            'Amanda',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800),
          ),
        ),
        const SizedBox(height: 2),
        Center(
          child: Text(
            'amanda.sakuin@gmail.com',
            style: TextStyle(
              fontSize: 12.5,
              color: AppColors.inkSoft.withOpacity(0.85),
            ),
          ),
        ),
        const SizedBox(height: 14),
        Center(
          child: OutlinedButton.icon(
            onPressed: () => _notImplemented(context, 'Edit profile'),
            icon: const Icon(Icons.edit_outlined, size: 15),
            label: const Text('Edit profile'),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.primary,
              side: const BorderSide(color: AppColors.primary),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            ),
          ),
        ),
        const SizedBox(height: 26),
        const _GroupLabel('Account details'),
        _Tile(
          icon: Icons.person_outline_rounded,
          label: 'Account',
          onTap: () => _notImplemented(context, 'Account'),
        ),
        _Tile(
          icon: Icons.account_balance_wallet_outlined,
          label: 'Wallet',
          onTap: () => _notImplemented(context, 'Wallet'),
        ),
        const SizedBox(height: 18),
        const _GroupLabel('Settings'),
        _Tile(
          icon: Icons.translate_rounded,
          label: 'Language',
          trailingText: 'English',
          onTap: () => _showLanguage(context),
        ),
        _Tile(
          icon: Icons.palette_outlined,
          label: 'Theme',
          trailingText: 'Light',
          onTap: () => _notImplemented(context, 'Theme'),
        ),
        _Tile(
          icon: Icons.notifications_none_rounded,
          label: 'Notifications',
          onTap: () => _notImplemented(context, 'Notifications'),
        ),
        _Tile(
          icon: Icons.headset_mic_outlined,
          label: 'Contact Support',
          onTap: () => _notImplemented(context, 'Contact Support'),
        ),
        _Tile(
          icon: Icons.lock_outline_rounded,
          label: 'Security',
          trailingText: 'Face ID off',
          onTap: () => _notImplemented(context, 'Security'),
        ),
        const SizedBox(height: 18),
        const _GroupLabel('Other'),
        _Tile(
          icon: Icons.info_outline_rounded,
          label: 'About Application',
          onTap: () => _notImplemented(context, 'About Application'),
        ),
        _Tile(
          icon: Icons.logout_rounded,
          label: 'Log Out',
          onTap: () => _confirmLogout(context),
        ),
        _Tile(
          icon: Icons.delete_outline_rounded,
          label: 'Delete Account',
          danger: true,
          onTap: () => _confirmDelete(context),
        ),
        const SizedBox(height: 20),
        Center(
          child: Text(
            'SAKUin v1.0.0 (build 1)',
            style: TextStyle(
              fontSize: 11,
              color: AppColors.inkMuted.withOpacity(0.8),
            ),
          ),
        ),
      ],
    );
  }

  void _notImplemented(BuildContext context, String label) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text('$label is not wired up in this demo build yet.'),
          behavior: SnackBarBehavior.floating,
        ),
      );
  }

  void _showLanguage(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        margin: const EdgeInsets.all(12),
        padding: const EdgeInsets.fromLTRB(20, 18, 20, 24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(28),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Language',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 8),
            for (final language in ['English', 'Bahasa Indonesia'])
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(language),
                trailing: language == 'English'
                    ? const Icon(Icons.check_rounded, color: AppColors.primary)
                    : null,
                onTap: () {
                  Navigator.pop(context);
                  if (language != 'English') {
                    _notImplemented(context, 'Bahasa Indonesia');
                  }
                },
              ),
          ],
        ),
      ),
    );
  }

  void _confirmLogout(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: const Text('Log out?'),
        content: const Text(
          'You will need to sign in again to see your wallets and targets.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(minimumSize: const Size(96, 44)),
            onPressed: () => Navigator.pop(context),
            child: const Text('Log out'),
          ),
        ],
      ),
    );
  }

  void _confirmDelete(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: const Text('Delete account?'),
        content: const Text(
          'This erases your wallets, transactions and targets permanently. '
          'This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Keep account'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.danger,
              minimumSize: const Size(96, 44),
            ),
            onPressed: () => Navigator.pop(context),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}

class _GroupLabel extends StatelessWidget {
  const _GroupLabel(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6, left: 4),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 12.5,
          fontWeight: FontWeight.w600,
          color: AppColors.inkSoft,
        ),
      ),
    );
  }
}

class _Tile extends StatelessWidget {
  const _Tile({
    required this.icon,
    required this.label,
    required this.onTap,
    this.trailingText,
    this.danger = false,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final String? trailingText;
  final bool danger;

  @override
  Widget build(BuildContext context) {
    final color = danger ? AppColors.danger : AppColors.ink;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 13),
        child: Row(
          children: [
            Icon(icon, size: 21, color: color),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: color,
                ),
              ),
            ),
            if (trailingText != null)
              Text(
                trailingText!,
                style: const TextStyle(
                  fontSize: 11.5,
                  color: AppColors.inkMuted,
                ),
              ),
            const SizedBox(width: 6),
            Icon(
              Icons.chevron_right_rounded,
              size: 19,
              color: AppColors.inkMuted.withOpacity(0.8),
            ),
          ],
        ),
      ),
    );
  }
}
