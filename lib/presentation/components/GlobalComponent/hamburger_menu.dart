import 'package:flutter/material.dart';
import '../../../core/services/session_manager.dart';

class HamburgerMenu extends StatelessWidget {
  const HamburgerMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      child: Column(
        children: [
          // Header Section - Menggunakan flexible height
          Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF6C5CE7),
                  Color(0xFF74B9FF),
                ],
              ),
            ),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min, // Penting: gunakan min size
                  children: [
                    // Header dengan logo dan close button
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Icon(
                                  Icons.account_balance_wallet,
                                  color: Color(0xFF6C5CE7),
                                  size: 20,
                                ),
                              ),
                              const SizedBox(width: 12),
                              const Expanded(
                                child: Text(
                                  'CryptoWalletPro',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: IconButton(
                            onPressed: () => Navigator.pop(context),
                            icon: const Icon(
                              Icons.close,
                              color: Colors.white,
                              size: 22,
                            ),
                            padding: const EdgeInsets.all(8),
                            constraints: const BoxConstraints(
                              minWidth: 40,
                              minHeight: 40,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    // Profile Section
                    Row(
                      children: [
                        Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(30),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.person,
                            size: 32,
                            color: Color(0xFF6C5CE7),
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
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                SessionManager().userEmail ?? 'no-email@example.com',
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 14,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Menu Items
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 8),
              children: [
                _buildMenuItem(
                  context,
                  icon: Icons.home_outlined,
                  title: 'Home',
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushReplacementNamed(context, '/home');
                  },
                ),
                _buildMenuItem(
                  context,
                  icon: Icons.notifications_outlined,
                  title: 'Notifications',
                  onTap: () {
                    Navigator.pop(context);
                    // Navigate to notifications
                  },
                ),
                _buildMenuItem(
                  context,
                  icon: Icons.person_outline,
                  title: 'My Account',
                  onTap: () {
                    Navigator.pop(context);
                    // Navigate to account
                  },
                ),
                _buildMenuItem(
                  context,
                  icon: Icons.bar_chart_outlined,
                  title: 'Market',
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushReplacementNamed(context, '/market');
                  },
                ),
                _buildMenuItem(
                  context,
                  icon: Icons.swap_horiz_outlined,
                  title: 'Trade',
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushReplacementNamed(context, '/trade');
                  },
                ),
                _buildMenuItem(
                  context,
                  icon: Icons.account_balance_wallet_outlined,
                  title: 'Wallet',
                  onTap: () {
                    Navigator.pop(context);
                    // Navigate to wallet
                  },
                ),
                _buildMenuItem(
                  context,
                  icon: Icons.history_outlined,
                  title: 'Transaction History',
                  onTap: () {
                    Navigator.pop(context);
                    // Navigate to transaction history
                  },
                ),
                _buildMenuItem(
                  context,
                  icon: Icons.security_outlined,
                  title: 'Security',
                  onTap: () {
                    Navigator.pop(context);
                    // Navigate to security
                  },
                ),
                const Divider(height: 32, indent: 20, endIndent: 20),
                _buildMenuItem(
                  context,
                  icon: Icons.settings_outlined,
                  title: 'Settings',
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushReplacementNamed(context, '/settings');
                  },
                ),
                _buildMenuItem(
                  context,
                  icon: Icons.help_outline,
                  title: 'Help & Support',
                  onTap: () {
                    Navigator.pop(context);
                    // Navigate to help
                  },
                ),
                _buildMenuItem(
                  context,
                  icon: Icons.info_outline,
                  title: 'About',
                  onTap: () {
                    Navigator.pop(context);
                    // Navigate to about
                  },
                ),
              ],
            ),
          ),
          // Footer
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(
                  color: Colors.grey.shade200,
                  width: 1,
                ),
              ),
            ),
            child: const Text(
              'Version 1.0.0',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 12,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: const Color(0xFF6C5CE7).withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            icon,
            color: const Color(0xFF6C5CE7),
            size: 20,
          ),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
        onTap: onTap,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        hoverColor: const Color(0xFF6C5CE7).withOpacity(0.05),
        splashColor: const Color(0xFF6C5CE7).withOpacity(0.1),
      ),
    );
  }
}