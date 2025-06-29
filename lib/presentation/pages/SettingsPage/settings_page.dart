import 'package:flutter/material.dart';
import '../../components/GlobalComponent/bottom_nav_bar.dart';
import '../../components/GlobalComponent/back_to_top.dart';
import '../../components/GlobalComponent/app_bar.dart';
import '../../components/GlobalComponent/hamburger_menu.dart';
import '../../components/SettingsComponent/settings_section_title.dart';
import '../../components/SettingsComponent/settings_option_item.dart';
import '../../components/SettingsComponent/settings_toggle_item.dart';
import '../../components/SettingsComponent/settings_language_picker.dart';
import '../../components/SettingsComponent/settings_feedback_button.dart';
import '../../components/SettingsComponent/settings_logout_button.dart';
import '../../routes/app_routes.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final ScrollController _scrollController = ScrollController();
  
  // Settings state
  bool _isDarkMode = false;
  bool _isPushNotifications = true;
  bool _isBiometric = false;
  bool _isPriceAlerts = true;
  String _selectedLanguage = 'en';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: const HomeAppBar(),
      drawer: const HamburgerMenu(),
      body: Stack(
        children: [
          SingleChildScrollView(
            controller: _scrollController,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                
                // Account Section
                const SettingsSectionTitle(title: 'Account'),
                SettingsOptionItem(
                  icon: Icons.person_outline,
                  title: 'Profile',
                  subtitle: 'Manage your profile information',
                  onTap: () => _showComingSoonDialog('Profile'),
                ),
                SettingsOptionItem(
                  icon: Icons.security_outlined,
                  title: 'Security',
                  subtitle: 'Password, 2FA, and security settings',
                  onTap: () => _showComingSoonDialog('Security'),
                ),
                SettingsOptionItem(
                  icon: Icons.account_balance_wallet_outlined,
                  title: 'Wallet Settings',
                  subtitle: 'Manage your wallet preferences',
                  onTap: () => _showComingSoonDialog('Wallet Settings'),
                ),
                
                // Preferences Section
                const SettingsSectionTitle(title: 'Preferences'),
                SettingsToggleItem(
                  icon: Icons.dark_mode_outlined,
                  title: 'Dark Mode',
                  subtitle: 'Switch between light and dark theme',
                  value: _isDarkMode,
                  onChanged: (value) {
                    setState(() {
                      _isDarkMode = value;
                    });
                    _showFeatureDialog('Dark Mode', value ? 'enabled' : 'disabled');
                  },
                ),
                SettingsLanguagePicker(
                  selectedLanguage: _selectedLanguage,
                  onLanguageChanged: (language) {
                    setState(() {
                      _selectedLanguage = language;
                    });
                    _showFeatureDialog('Language', 'changed successfully');
                  },
                ),
                SettingsOptionItem(
                  icon: Icons.currency_exchange,
                  title: 'Currency',
                  subtitle: 'USD',
                  onTap: () => _showCurrencyPicker(),
                ),
                
                // Notifications Section
                const SettingsSectionTitle(title: 'Notifications'),
                SettingsToggleItem(
                  icon: Icons.notifications_outlined,
                  title: 'Push Notifications',
                  subtitle: 'Receive important updates',
                  value: _isPushNotifications,
                  onChanged: (value) {
                    setState(() {
                      _isPushNotifications = value;
                    });
                  },
                ),
                SettingsToggleItem(
                  icon: Icons.trending_up,
                  title: 'Price Alerts',
                  subtitle: 'Get notified about price changes',
                  value: _isPriceAlerts,
                  onChanged: (value) {
                    setState(() {
                      _isPriceAlerts = value;
                    });
                  },
                ),
                
                // Security Section
                const SettingsSectionTitle(title: 'Security'),
                SettingsToggleItem(
                  icon: Icons.fingerprint,
                  title: 'Biometric Login',
                  subtitle: 'Use fingerprint or face ID',
                  value: _isBiometric,
                  onChanged: (value) {
                    setState(() {
                      _isBiometric = value;
                    });
                    _showFeatureDialog('Biometric Login', value ? 'enabled' : 'disabled');
                  },
                ),
                SettingsOptionItem(
                  icon: Icons.vpn_key_outlined,
                  title: 'Change Password',
                  subtitle: 'Update your account password',
                  onTap: () => _showComingSoonDialog('Change Password'),
                ),
                
                // Support Section
                const SettingsSectionTitle(title: 'Support'),
                SettingsOptionItem(
                  icon: Icons.help_outline,
                  title: 'Help Center',
                  subtitle: 'FAQs and support articles',
                  onTap: () => _showComingSoonDialog('Help Center'),
                ),
                const SettingsFeedbackButton(),
                SettingsOptionItem(
                  icon: Icons.info_outline,
                  title: 'About',
                  subtitle: 'App version and information',
                  onTap: () => _showAboutDialog(),
                ),
                
                const SizedBox(height: 20),
                
                // Logout Button
                const SettingsLogoutButton(),
                
                const SizedBox(height: 100), // Space for bottom navigation
              ],
            ),
          ),
          
          // Back to Top Button
          BackToTop(
            scrollController: _scrollController,
            showOffset: 300.0,
            backgroundColor: const Color(0xFF6C5CE7),
            iconColor: Colors.white,
          ),
        ],
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: 3, // Settings page index
        onTap: _onBottomNavTap,
      ),
    );
  }

  void _onBottomNavTap(int index) {
    switch (index) {
      case 0:
        Navigator.pushReplacementNamed(context, AppRoutes.home);
        break;
      case 1:
        Navigator.pushReplacementNamed(context, AppRoutes.market);
        break;
      case 2:
        Navigator.pushReplacementNamed(context, AppRoutes.trade);
        break;
      case 3:
        // Already on settings page
        break;
    }
  }

  void _showComingSoonDialog(String feature) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFF6C5CE7).withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Icon(
                Icons.construction,
                color: Color(0xFF6C5CE7),
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            const Text('Coming Soon'),
          ],
        ),
        content: Text(
          '$feature feature is coming soon! We\'re working hard to bring you the best experience.',
          style: const TextStyle(fontSize: 14),
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF6C5CE7),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text('OK', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showFeatureDialog(String feature, String status) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$feature $status'),
        backgroundColor: const Color(0xFF6C5CE7),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  void _showCurrencyPicker() {
    final currencies = ['USD', 'EUR', 'GBP', 'JPY', 'IDR', 'SGD'];
    
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              margin: const EdgeInsets.only(top: 12),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(20),
              child: Text(
                'Select Currency',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            ...currencies.map((currency) => ListTile(
              title: Text(currency),
              trailing: currency == 'USD'
                  ? const Icon(Icons.check, color: Color(0xFF6C5CE7))
                  : null,
              onTap: () {
                Navigator.pop(context);
                _showFeatureDialog('Currency', 'changed to $currency');
              },
            )).toList(),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  void _showAboutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFF6C5CE7).withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Icon(
                Icons.info_outline,
                color: Color(0xFF6C5CE7),
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            const Text('About DomCry'),
          ],
        ),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'DomCry Crypto Wallet',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text('Version: 1.0.0'),
            Text('Build: 2024.01.15'),
            SizedBox(height: 16),
            Text(
              'A secure and user-friendly cryptocurrency wallet for managing your digital assets.',
              style: TextStyle(fontSize: 14),
            ),
            SizedBox(height: 16),
            Text(
              '© 2024 DomCry. All rights reserved.',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey,
              ),
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF6C5CE7),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text('OK', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}