import 'package:flutter/material.dart';
import 'account_menu.dart';

class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  const HomeAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 360;
    final isMediumScreen = screenWidth < 400;
    
    return AppBar(
      backgroundColor: const Color(0xFF6C5CE7),
      elevation: 0,
      automaticallyImplyLeading: false,
      titleSpacing: 0,
      leading: _buildLeadingButton(context, isSmallScreen),
      title: _buildTitle(context, isSmallScreen, isMediumScreen),
      actions: _buildActions(context, isSmallScreen),
      flexibleSpace: Container(
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
      ),
    );
  }

  Widget _buildLeadingButton(BuildContext context, bool isSmallScreen) {
    return Container(
      margin: EdgeInsets.all(isSmallScreen ? 6 : 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: IconButton(
        icon: Icon(
          Icons.menu,
          color: Colors.white,
          size: isSmallScreen ? 20 : 24,
        ),
        onPressed: () => Scaffold.of(context).openDrawer(),
        padding: EdgeInsets.zero,
        constraints: const BoxConstraints(),
      ),
    );
  }

  Widget _buildTitle(BuildContext context, bool isSmallScreen, bool isMediumScreen) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final availableWidth = constraints.maxWidth;
        
        // Calculate if we have enough space for full title
        final hasSpaceForFullTitle = availableWidth > 200;
        final hasSpaceForIcon = availableWidth > 120;
        
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (hasSpaceForIcon) ...[
              Container(
                padding: EdgeInsets.all(isSmallScreen ? 6 : 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.account_balance_wallet,
                  color: const Color(0xFF6C5CE7),
                  size: isSmallScreen ? 16 : 20,
                ),
              ),
              SizedBox(width: isSmallScreen ? 6 : 8),
            ],
            Flexible(
              child: Text(
                hasSpaceForFullTitle 
                    ? 'CryptoWalletPro'
                    : isMediumScreen 
                        ? 'CryptoWallet'
                        : 'Crypto',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: isSmallScreen ? 16 : 18,
                  fontWeight: FontWeight.bold,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ),
          ],
        );
      },
    );
  }

  List<Widget> _buildActions(BuildContext context, bool isSmallScreen) {
    final actionSize = isSmallScreen ? 40.0 : 48.0;
    final iconSize = isSmallScreen ? 20.0 : 24.0;
    final margin = isSmallScreen ? 4.0 : 8.0;
    
    return [
      Container(
        width: actionSize,
        height: actionSize,
        margin: EdgeInsets.all(margin),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.2),
          borderRadius: BorderRadius.circular(12),
        ),
        child: IconButton(
          icon: Icon(
            Icons.notifications_outlined, 
            color: Colors.white,
            size: iconSize,
          ),
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Row(
                  children: [
                    Icon(Icons.notifications, color: Colors.white, size: 20),
                    SizedBox(width: 12),
                    Text('Notifications clicked'),
                  ],
                ),
                backgroundColor: const Color(0xFF6C5CE7),
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                duration: const Duration(seconds: 2),
              ),
            );
          },
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
        ),
      ),
      Container(
        width: actionSize,
        height: actionSize,
        margin: EdgeInsets.only(
          top: margin,
          bottom: margin,
          right: margin,
        ),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.2),
          borderRadius: BorderRadius.circular(12),
        ),
        child: IconButton(
          icon: Icon(
            Icons.person_outline, 
            color: Colors.white,
            size: iconSize,
          ),
          onPressed: () => AccountMenu.show(context),
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
        ),
      ),
    ];
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}