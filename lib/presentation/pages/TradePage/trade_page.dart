import 'package:flutter/material.dart';
import '../../components/GlobalComponent/bottom_nav_bar.dart';
import '../../components/GlobalComponent/back_to_top.dart';
import '../../components/GlobalComponent/app_bar.dart';
import '../../components/GlobalComponent/hamburger_menu.dart';
import '../../components/TradeComponent/trade_pair_selector.dart';
import '../../components/TradeComponent/trade_chart_preview.dart';
import '../../components/TradeComponent/trade_order_form.dart';
import '../../components/TradeComponent/trade_amount_slider.dart';
import '../../components/TradeComponent/trade_action_buttons.dart';
import '../../components/TradeComponent/trade_summary_card.dart';
import '../../routes/app_routes.dart';

class TradePage extends StatefulWidget {
  const TradePage({super.key});

  @override
  State<TradePage> createState() => _TradePageState();
}

class _TradePageState extends State<TradePage> {
  final ScrollController _scrollController = ScrollController();
  
  String _selectedPair = 'BTC/USDT';
  String _selectedOrderType = 'buy';
  Map<String, dynamic>? _orderData;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // Initialize any required data here
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50, // Same as HomePage
      appBar: const HomeAppBar(), // Same as HomePage
      drawer: const HamburgerMenu(), // Same as HomePage
      body: Stack(
        children: [
          SingleChildScrollView(
            controller: _scrollController,
            child: Column(
              children: [
                // Add some top padding to match HomePage spacing
                const SizedBox(height: 10),
                
                // Trading Pair Selector
                TradePairSelector(
                  selectedPair: _selectedPair,
                  onPairChanged: _onPairChanged,
                ),
                
                // Chart Preview
                TradeChartPreview(
                  tradingPair: _selectedPair,
                ),
                
                const SizedBox(height: 20),
                
                // Order Form
                TradeOrderForm(
                  tradingPair: _selectedPair,
                  orderType: _selectedOrderType,
                  onOrderChanged: _onOrderChanged,
                ),
                
                const SizedBox(height: 20),
                
                // Amount Slider
                TradeAmountSlider(
                  tradingPair: _selectedPair,
                  orderType: _selectedOrderType,
                  onPercentageChanged: _onPercentageChanged,
                ),
                
                const SizedBox(height: 20),
                
                // Order Summary
                TradeSummaryCard(
                  orderData: _orderData,
                ),
                
                const SizedBox(height: 20),
                
                // Action Buttons
                TradeActionButtons(
                  selectedOrderType: _selectedOrderType,
                  onOrderTypeChanged: _onOrderTypeChanged,
                  orderData: _orderData,
                  onExecuteTrade: _executeTrade,
                  isLoading: _isLoading,
                ),
                
                const SizedBox(height: 100), // Space for bottom navigation
              ],
            ),
          ),
          
          // Back to Top Button - Same styling as HomePage
          BackToTop(
            scrollController: _scrollController,
            showOffset: 300.0,
            backgroundColor: const Color(0xFF6C5CE7),
            iconColor: Colors.white,
          ),
        ],
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: 2, // Trade page index
        onTap: _onBottomNavTap,
      ),
    );
  }

  void _onPairChanged(String pair) {
    // Use post frame callback to avoid setState during build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        setState(() {
          _selectedPair = pair;
          _orderData = null; // Reset order data when pair changes
        });
      }
    });
  }

  void _onOrderChanged(Map<String, dynamic> orderData) {
    // Use post frame callback to avoid setState during build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        setState(() {
          _orderData = orderData;
        });
      }
    });
  }

  void _onPercentageChanged(int percentage) {
    // Handle percentage change without setState if not needed
    debugPrint('Selected percentage: $percentage%');
    // If you need to update UI based on percentage, use post frame callback
  }

  void _onOrderTypeChanged(String orderType) {
    // Use post frame callback to avoid setState during build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        setState(() {
          _selectedOrderType = orderType;
          _orderData = null; // Reset order data when type changes
        });
      }
    });
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
        // Already on trade page
        break;
      case 3:
        Navigator.pushReplacementNamed(context, AppRoutes.settings);
        break;
    }
  }

  void _executeTrade() async {
    if (_orderData == null) return;
    
    setState(() {
      _isLoading = true;
    });
    
    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));
      
      // Show success dialog
      if (mounted) {
        _showTradeSuccessDialog();
      }
    } catch (e) {
      // Show error dialog
      if (mounted) {
        _showTradeErrorDialog(e.toString());
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _showTradeSuccessDialog() {
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
                color: Colors.green.shade100,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Icon(
                Icons.check_circle,
                color: Colors.green.shade600,
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            const Text('Trade Executed'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Your ${_selectedOrderType.toUpperCase()} order for $_selectedPair has been successfully executed.',
              style: const TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Order ID:', style: TextStyle(fontSize: 12)),
                      Text(
                        '#${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}',
                        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Status:', style: TextStyle(fontSize: 12)),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.green.shade100,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          'FILLED',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: Colors.green.shade700,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('View Portfolio'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                _orderData = null;
              });
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF6C5CE7),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text('New Trade', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showTradeErrorDialog(String error) {
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
                color: Colors.red.shade100,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Icon(
                Icons.error_outline,
                color: Colors.red.shade600,
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            const Text('Trade Failed'),
          ],
        ),
        content: Text(
          'Unable to execute your trade order. Please check your balance and try again.\n\nError: $error',
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
            child: const Text('Try Again', style: TextStyle(color: Colors.white)),
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