import 'package:flutter/material.dart';
import '../../components/GlobalComponent/bottom_nav_bar.dart';
import '../../components/GlobalComponent/back_to_top.dart';
import '../../components/GlobalComponent/app_bar.dart';
import '../../components/GlobalComponent/hamburger_menu.dart';
import '../../components/HomeComponent/home_header_banner.dart';
import '../../components/HomeComponent/wallet_card.dart';
import '../../components/HomeComponent/crypto_list.dart';
import '../../components/HomeComponent/your_assets_header.dart';
import '../../components/HomeComponent/assets_list.dart';
import '../../components/HomeComponent/home_quick_actions.dart';
import '../../components/HomeComponent/recent_transactions.dart';
import '../../routes/app_routes.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

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
                const HomeHeaderBanner(),
                Transform.translate(
                  offset: const Offset(0, -30),
                  child: const WalletCard(),
                ),
                const SizedBox(height: 10),
                const CryptoList(),
                const YourAssetsHeader(),
                const SizedBox(height: 16),
                const AssetsList(),
                const HomeQuickActions(),
                const RecentTransactions(),
                const SizedBox(height: 20),
              ],
            ),
          ),
          BackToTop(
            scrollController: _scrollController,
            showOffset: 300.0,
            backgroundColor: const Color(0xFF6C5CE7),
            iconColor: Colors.white,
          ),
        ],
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: 0,
        onTap: (index) {
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
              Navigator.pushReplacementNamed(context, AppRoutes.settings);
              break;
          }
        },
      ),
    );
  }
}