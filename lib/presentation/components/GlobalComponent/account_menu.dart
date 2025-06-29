import 'package:flutter/material.dart';
import '../../../core/services/session_manager.dart';

class AccountMenu extends StatelessWidget {
  const AccountMenu({super.key});

  static void show(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => const AccountMenu(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle Bar
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          // Header
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                const CircleAvatar(
                  radius: 25,
                  backgroundColor: Color(0xFF6C5CE7),
                  child: Icon(
                    Icons.person,
                    color: Colors.white,
                    size: 25,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        SessionManager().fullname ?? 'Guest User',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        SessionManager().userEmail ?? 'no-email@example.com',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          // Menu Items
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Column(
              children: [
                _buildAccountMenuItem(
                  context,
                  icon: Icons.person_outline,
                  title: 'View Profile',
                  subtitle: 'Manage your account information',
                  onTap: () {
                    Navigator.pop(context);
                    // Navigate to profile
                  },
                ),
                _buildAccountMenuItem(
                  context,
                  icon: Icons.security_outlined,
                  title: 'Security Settings',
                  subtitle: 'Password, 2FA, and security options',
                  onTap: () {
                    Navigator.pop(context);
                    // Navigate to security settings
                  },
                ),
                _buildAccountMenuItem(
                  context,
                  icon: Icons.palette_outlined,
                  title: 'Theme Settings',
                  subtitle: 'Light, Dark, or System theme',
                  onTap: () {
                    Navigator.pop(context);
                    _showThemeDialog(context);
                  },
                ),
                _buildAccountMenuItem(
                  context,
                  icon: Icons.language_outlined,
                  title: 'Language',
                  subtitle: 'Choose your preferred language',
                  onTap: () {
                    Navigator.pop(context);
                    _showLanguageDialog(context);
                  },
                ),
                _buildAccountMenuItem(
                  context,
                  icon: Icons.notifications_outlined,
                  title: 'Notification Settings',
                  subtitle: 'Manage your notification preferences',
                  onTap: () {
                    Navigator.pop(context);
                    // Navigate to notification settings
                  },
                ),
                const Divider(height: 32),
                _buildAccountMenuItem(
                  context,
                  icon: Icons.logout_outlined,
                  title: 'Logout',
                  subtitle: 'Sign out of your account',
                  isDestructive: true,
                  onTap: () {
                    Navigator.pop(context);
                    _showLogoutDialog(context);
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildAccountMenuItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: isDestructive 
              ? Colors.red.withOpacity(0.1)
              : const Color(0xFF6C5CE7).withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(
          icon,
          color: isDestructive ? Colors.red : const Color(0xFF6C5CE7),
          size: 22,
        ),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: isDestructive ? Colors.red : Colors.black,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: const TextStyle(
          fontSize: 12,
          color: Colors.grey,
        ),
      ),
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
    );
  }

  static void _showThemeDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Choose Theme'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.light_mode),
              title: const Text('Light'),
              onTap: () {
                Navigator.pop(context);
                // Set light theme
              },
            ),
            ListTile(
              leading: const Icon(Icons.dark_mode),
              title: const Text('Dark'),
              onTap: () {
                Navigator.pop(context);
                // Set dark theme
              },
            ),
            ListTile(
              leading: const Icon(Icons.auto_mode),
              title: const Text('System'),
              onTap: () {
                Navigator.pop(context);
                // Set system theme
              },
            ),
          ],
        ),
      ),
    );
  }

  static void _showLanguageDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Choose Language'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Text('🇺🇸'),
              title: const Text('English'),
              onTap: () {
                Navigator.pop(context);
                // Set English
              },
            ),
            ListTile(
              leading: const Text('🇮🇩'),
              title: const Text('Bahasa Indonesia'),
              onTap: () {
                Navigator.pop(context);
                // Set Indonesian
              },
            ),
            ListTile(
              leading: const Text('🇪🇸'),
              title: const Text('Español'),
              onTap: () {
                Navigator.pop(context);
                // Set Spanish
              },
            ),
          ],
        ),
      ),
    );
  }

  static void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // Perform logout
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }
}