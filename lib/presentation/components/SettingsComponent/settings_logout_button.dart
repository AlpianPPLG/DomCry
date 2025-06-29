import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../routes/app_routes.dart';
import '../../../../core/services/session_manager.dart';

class SettingsLogoutButton extends StatelessWidget {
  const SettingsLogoutButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: ElevatedButton(
        onPressed: () => _showLogoutDialog(context),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.red.shade50,
          foregroundColor: Colors.red,
          elevation: 0,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(color: Colors.red.shade200),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.logout,
              color: Colors.red.shade600,
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              'Logout',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.red.shade600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    HapticFeedback.lightImpact();

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Confirm Logout'),
        content: const Text('Are you sure you want to log out?'),
        actions: [
          TextButton(
            child: const Text('Cancel'),
            onPressed: () => Navigator.of(dialogContext).pop(),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Logout'),
            onPressed: () {
              Navigator.of(dialogContext).pop(); // Close the dialog
              _performLogout(context); // Perform logout
            },
          ),
        ],
      ),
    );
  }

  Future<void> _performLogout(BuildContext context) async {
    try {
      await SessionManager().logout();

      // Ensure the context is still valid before navigating
      if (context.mounted) {
        Navigator.pushNamedAndRemoveUntil(
          context,
          AppRoutes.login,
          (route) => false, // This removes all routes behind the new one
        );
      }
    } catch (e) {
      debugPrint('Logout failed: $e');
      // Optionally, show an error message to the user
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Logout failed. Please try again.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}